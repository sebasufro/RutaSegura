import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/direction_card.dart';
import '../widgets/direction_dialog.dart';
import '/modules/global/services/profile_service.dart';

class VolMyDirectionsScreen extends StatefulWidget {
  const VolMyDirectionsScreen({super.key});

  @override
  State<VolMyDirectionsScreen> createState() => _VolMyDirectionsScreenState();
}

class _VolMyDirectionsScreenState extends State<VolMyDirectionsScreen> {
  final _profileService = ProfileService();
  List<Map<String, dynamic>> _direcciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _isLoading = true);
    final data = await _profileService.getAddresses();
    if (mounted) setState(() { _direcciones = data; _isLoading = false; });
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : Colors.green,
    ));
  }

  void _agregar() {
    mostrarPopupAgregarDireccion(context, onGuardar: (alias, direccion) async {
      final nueva = await _profileService.createAddress(alias, direccion);
      if (!mounted) return;
      if (nueva != null) {
        setState(() => _direcciones.add(nueva));
        _snack('Dirección agregada correctamente');
      } else {
        _snack('Error al agregar la dirección', error: true);
      }
    });
  }

  void _editar(Map<String, dynamic> direccion) {
    mostrarPopupEditarDireccion(
      context,
      aliasActual: direccion['alias'],
      direccionActual: direccion['full_address'],
      onGuardar: (alias, fullAddress) async {
        final ok = await _profileService.updateAddress(direccion['id_address'], alias, fullAddress);
        if (!mounted) return;
        if (ok) {
          setState(() { direccion['alias'] = alias; direccion['full_address'] = fullAddress; });
          _snack('Dirección actualizada correctamente');
        } else {
          _snack('Error al actualizar la dirección', error: true);
        }
      },
    );
  }

  void _eliminar(Map<String, dynamic> direccion) {
    mostrarPopupEliminarDireccion(
      context,
      alias: direccion['alias'],
      onConfirmar: () async {
        final ok = await _profileService.deleteAddress(direccion['id_address']);
        if (!mounted) return;
        if (ok) {
          setState(() => _direcciones.remove(direccion));
          _snack('Dirección eliminada');
        } else {
          _snack('Error al eliminar la dirección', error: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const VolTopbar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Direcciones',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, height: 1.2, color: Color(0xFF0F172A)),
                  ),
                  ElevatedButton.icon(
                    onPressed: _agregar,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Agregar', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Guarda tus lugares frecuentes para acceder rápidamente durante una actividad.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _cargar,
                      child: _direcciones.isEmpty
                          ? ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.home_work_outlined, size: 50, color: Colors.grey[400]),
                                      const SizedBox(height: 12),
                                      Text('Sin direcciones registradas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                                      const SizedBox(height: 8),
                                      Text('Agrega tu hogar, trabajo u otros lugares frecuentes.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _direcciones.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (_, i) => DirectionCard(
                                alias: _direcciones[i]['alias'],
                                direccion: _direcciones[i]['full_address'],
                                onEdit: () => _editar(_direcciones[i]),
                                onDelete: () => _eliminar(_direcciones[i]),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

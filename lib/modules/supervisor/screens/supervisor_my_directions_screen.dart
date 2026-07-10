import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/direction_card.dart';
import '/modules/supervisor/widgets/direction_dialog.dart';
import '/modules/supervisor/services/address_service.dart';

class VolMyDirectionsScreen extends StatefulWidget {
  const VolMyDirectionsScreen({super.key});

  @override
  State<VolMyDirectionsScreen> createState() => _VolMyDirectionsScreenState();
}

class _VolMyDirectionsScreenState extends State<VolMyDirectionsScreen> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await AddressService.getAddresses();
      if (mounted) setState(() { _addresses = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _addAddress(String alias, String direccion) async {
    try {
      await AddressService.createAddress(alias, direccion);
      if (mounted) _loadAddresses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editAddress(
      String id, String alias, String direccion) async {
    try {
      await AddressService.updateAddress(id, alias, direccion);
      if (mounted) _loadAddresses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteAddress(String id) async {
    try {
      await AddressService.deleteAddress(id);
      if (mounted) _loadAddresses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const SupTopbar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, bottom: 20.0),
              child: Row(
                children: const [
                  Text(
                    'Mis Direcciones',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildList()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    mostrarPopupAgregarDireccion(
                      context,
                      onGuardar: (alias, direccion) =>
                          _addAddress(alias, direccion),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Agregar dirección',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAddresses,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_addresses.isEmpty) {
      return const Center(
        child: Text(
          'No tienes direcciones guardadas.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        final addr = _addresses[index];
        final id = addr['id_address'] as String;
        final alias = addr['alias'] as String? ?? '';
        final direccion = addr['full_address'] as String? ?? '';

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: DirectionCard(
            alias: alias,
            direccion: direccion,
            onEdit: () {
              mostrarPopupEditarDireccion(
                context,
                aliasActual: alias,
                direccionActual: direccion,
                onGuardar: (nuevoAlias, nuevaDireccion) =>
                    _editAddress(id, nuevoAlias, nuevaDireccion),
              );
            },
            onDelete: () {
              mostrarPopupEliminarDireccion(
                context,
                alias: alias,
                onConfirmar: () => _deleteAddress(id),
              );
            },
          ),
        );
      },
    );
  }
}

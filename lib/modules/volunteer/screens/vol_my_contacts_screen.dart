import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/contact_card.dart';
import '../widgets/contact_dialog.dart';
import '/modules/global/services/profile_service.dart';

class VolMyContactsScreen extends StatefulWidget {
  const VolMyContactsScreen({super.key});

  @override
  State<VolMyContactsScreen> createState() => _VolMyContactsScreenState();
}

class _VolMyContactsScreenState extends State<VolMyContactsScreen> {
  final _profileService = ProfileService();
  List<Map<String, dynamic>> _contactos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _isLoading = true);
    final data = await _profileService.getContacts();
    if (mounted) setState(() { _contactos = data; _isLoading = false; });
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : Colors.green,
    ));
  }

  void _agregar() {
    mostrarPopupAgregarContacto(context, onGuardar: (nombre, telefono) async {
      final nuevo = await _profileService.createContact(nombre, telefono);
      if (!mounted) return;
      if (nuevo != null) {
        setState(() => _contactos.add(nuevo));
        _snack('Contacto agregado correctamente');
      } else {
        _snack('Error al agregar el contacto', error: true);
      }
    });
  }

  void _editar(Map<String, dynamic> contacto) {
    mostrarPopupEditarContacto(
      context,
      nombreActual: contacto['contact_name'],
      telefonoActual: contacto['contact_number'],
      onGuardar: (nombre, telefono) async {
        final ok = await _profileService.updateContact(contacto['id_contact'], nombre, telefono);
        if (!mounted) return;
        if (ok) {
          setState(() { contacto['contact_name'] = nombre; contacto['contact_number'] = telefono; });
          _snack('Contacto actualizado correctamente');
        } else {
          _snack('Error al actualizar el contacto', error: true);
        }
      },
    );
  }

  void _eliminar(Map<String, dynamic> contacto) {
    mostrarPopupEliminarContacto(
      context,
      nombre: contacto['contact_name'],
      onConfirmar: () async {
        final ok = await _profileService.deleteContact(contacto['id_contact']);
        if (!mounted) return;
        if (ok) {
          setState(() => _contactos.remove(contacto));
          _snack('Contacto eliminado');
        } else {
          _snack('Error al eliminar el contacto', error: true);
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
                    'Contactos de\nEmergencia',
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
                'Personas de confianza que serán notificadas en caso de emergencia.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _cargar,
                      child: _contactos.isEmpty
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
                                      Icon(Icons.perm_contact_calendar_outlined, size: 50, color: Colors.grey[400]),
                                      const SizedBox(height: 12),
                                      Text('Sin contactos registrados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                                      const SizedBox(height: 8),
                                      Text('Agrega personas de confianza tocando el botón de arriba.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _contactos.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (_, i) => ContactCard(
                                nombre: _contactos[i]['contact_name'],
                                telefono: _contactos[i]['contact_number'],
                                onEdit: () => _editar(_contactos[i]),
                                onDelete: () => _eliminar(_contactos[i]),
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

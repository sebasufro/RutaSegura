import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_main_info.dart';
<<<<<<< HEAD
import 'vol_settings_screen.dart';
import 'vol_contacts_screen.dart';
import 'vol_addresses_screen.dart';
=======
import '../screens/vol_config_screen.dart';
import '../widgets/profile_edit_dialog.dart';
import '/modules/global/services/profile_service.dart';
>>>>>>> origin/integration

class VolProfileScreen extends StatefulWidget {
  const VolProfileScreen({super.key});

  @override
  State<VolProfileScreen> createState() => _VolProfileScreenState();
}

class _VolProfileScreenState extends State<VolProfileScreen> {
  final _profileService = ProfileService();
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final data = await _profileService.getProfile();
    if (mounted) setState(() { _profile = data; _isLoading = false; });
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);

    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_profile == null) return const Scaffold(body: Center(child: Text('No se pudo cargar el perfil')));

    final nombre = _profile!['full_name'] ?? '';
    final correo = _profile!['email'] ?? '';
    final rut = _profile!['rut'] ?? '';
    final telefono = _profile!['phone_number'] ?? 'Sin teléfono';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const VolTopbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileMainInfo(nombre: nombre, correo: correo, colorPrincipal: colorPrincipal),
            const SizedBox(height: 40),

            ProfileInfoCard(etiqueta: 'NOMBRE COMPLETO', valor: nombre, esEditable: false),
            const SizedBox(height: 15),
            ProfileInfoCard(etiqueta: 'RUT', valor: rut, esEditable: false),
            const SizedBox(height: 15),
            ProfileInfoCard(
              etiqueta: 'TELÉFONO',
              valor: telefono,
              esEditable: true,
              onEditar: () {
                mostrarPopupEditarPerfil(
                  context,
                  titulo: 'Editar Teléfono',
                  labelCampo: 'NÚMERO DE TELÉFONO',
                  valorInicial: telefono,
                  hintText: '+56 9 XXXX XXXX',
                  keyboardType: TextInputType.phone,
                  onGuardar: (nuevoValor) async {
                    final ok = await _profileService.updatePhoneNumber(nuevoValor);
                    if (!mounted) return;
                    if (ok) {
                      setState(() => _profile!['phone_number'] = nuevoValor);
                      _snack('Teléfono actualizado correctamente');
                    } else {
                      _snack('Error al actualizar el teléfono', error: true);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 15),
<<<<<<< HEAD

            ProfileInfoCard(
              etiqueta: 'CORREO ELECTRÓNICO',
              valor: 'juanperez@ejemplo.com',
              esEditable: true,
              onEditar: () {
                // TODO: Implementar lógica de edición de correo
              },
            ),
            const SizedBox(height: 30),

            // Mis Contactos
            _buildMenuOption(
              context,
              icon: Icons.contacts_outlined,
              label: 'Mis contactos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VolContactsScreen()),
              ),
            ),
            const SizedBox(height: 12),

            // Mis Direcciones
            _buildMenuOption(
              context,
              icon: Icons.location_on_outlined,
              label: 'Mis Direcciones',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VolAddressesScreen()),
              ),
            ),
            const SizedBox(height: 30),
=======
            ProfileInfoCard(etiqueta: 'CORREO ELECTRÓNICO', valor: correo, esEditable: false),
            const SizedBox(height: 35),
>>>>>>> origin/integration

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
<<<<<<< HEAD
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VolSettingsScreen()),
                  );
                },
=======
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VolConfigScreen()),
                ),
>>>>>>> origin/integration
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283593),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                ),
                child: const Text(
                  'Configuración',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1E3A8A)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
=======
}

>>>>>>> origin/integration

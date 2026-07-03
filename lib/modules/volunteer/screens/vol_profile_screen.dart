import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_main_info.dart';
import '../screens/vol_config_screen.dart';
import '../widgets/profile_edit_dialog.dart';
import '/modules/global/services/profile_service.dart';

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
    final data = await _profileService.getProfile();
    if (mounted) {
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return const Scaffold(
        body: Center(child: Text('No se pudo cargar el perfil')),
      );
    }

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
          children: [
            ProfileMainInfo(
              nombre: nombre,
              correo: correo,
              colorPrincipal: colorPrincipal,
            ),
            const SizedBox(height: 40),

            ProfileInfoCard(
              etiqueta: 'NOMBRE COMPLETO',
              valor: nombre,
              esEditable: false,
            ),
            const SizedBox(height: 15),

            ProfileInfoCard(
              etiqueta: 'RUT',
              valor: rut,
              esEditable: false,
            ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Teléfono actualizado correctamente')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al actualizar el teléfono')),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 15),

            ProfileInfoCard(
              etiqueta: 'CORREO ELECTRÓNICO',
              valor: correo,
              esEditable: false,
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VolConfigScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283593),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Configuración',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

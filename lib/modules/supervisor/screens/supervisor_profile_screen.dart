import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/profile_info_card.dart';
import '/modules/supervisor/widgets/profile_main_info.dart';
import '/modules/supervisor/screens/supervisor_config_screen.dart';
import '/modules/supervisor/widgets/profile_edit_dialog.dart';
import '/modules/global/services/profile_service.dart';

class SupervisorProfileScreen extends StatefulWidget {
  const SupervisorProfileScreen({super.key});

  @override
  State<SupervisorProfileScreen> createState() =>
      _SupervisorProfileScreenState();
}

class _SupervisorProfileScreenState extends State<SupervisorProfileScreen> {
  final _profileService = ProfileService();
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _profileService.getProfile();
      if (mounted) setState(() { _profile = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _updatePhone(String phone) async {
    try {
      await _profileService.updatePhoneNumber(phone);
      if (mounted) _loadProfile();
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
    final colorPrincipal = const Color(0xFF1E3A8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: SupTopbar(),
      body: _buildBody(colorPrincipal),
    );
  }

  Widget _buildBody(Color colorPrincipal) {
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
              onPressed: _loadProfile,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final nombre = _profile?['full_name'] as String? ?? '';
    final correo = _profile?['email'] as String? ?? '';
    final rut = _profile?['rut'] as String? ?? '';
    final telefono = _profile?['phone_number'] as String? ?? '';

    return SingleChildScrollView(
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
                onGuardar: (nuevoValor) => _updatePhone(nuevoValor),
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
                    builder: (context) => const SupervisorConfigScreen(),
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
    );
  }
}

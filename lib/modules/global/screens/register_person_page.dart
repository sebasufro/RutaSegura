import 'package:flutter/material.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_header.dart';
import 'package:ruta_segura/core/presentation/widgets/primary_button.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_card.dart';
import 'package:ruta_segura/core/presentation/widgets/custom_text_field.dart';
import 'package:ruta_segura/core/presentation/widgets/input_label.dart';
import 'package:ruta_segura/modules/global/screens/register_emergency_page.dart';

/// Página para capturar los datos personales del usuario.
class RegisterPersonPage extends StatefulWidget {
  const RegisterPersonPage({super.key});

  @override
  State<RegisterPersonPage> createState() => _RegisterPersonPageState();
}

class _RegisterPersonPageState extends State<RegisterPersonPage> {
  // Controladores con datos de prueba (Hardcoded)
  final _fullNameController = TextEditingController(text: 'Jhon Doe');
  final _rutController = TextEditingController(text: '12.345.678-K');
  final _phoneController = TextEditingController(text: '9 1234 5678');
  final _addressController = TextEditingController(text: 'Av. Providencia 1208, Providencia');

  @override
  void dispose() {
    _fullNameController.dispose();
    _rutController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Registro', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'Datos Personales',
                    style: TextStyle(color: Color(0xFF1E3A8A), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AuthCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingresa tus datos como están en tus documentos.',
                        style: TextStyle(color: Color(0xFF43474E), fontSize: 14),
                      ),
                      const SizedBox(height: 24),

                      const InputLabel(text: 'NOMBRE COMPLETO'),
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: 'Nombres y Apellidos',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'RUT'),
                      CustomTextField(
                        controller: _rutController,
                        hintText: '12.345.678-K',
                        prefixIcon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'NÚMERO DE TELÉFONO'),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('+56', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              VerticalDivider(width: 1, color: Colors.black.withOpacity(0.1), indent: 12, endIndent: 12),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: '9 1234 5678',
                                    hintStyle: TextStyle(color: Color(0xFF6B7280)),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'DIRECCIÓN DOMICILIO'),
                      CustomTextField(
                        controller: _addressController,
                        hintText: 'Dirección',
                        prefixIcon: Icons.home_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: 'Siguiente',
                onPressed: () {
                  if (_fullNameController.text.isEmpty ||
                      _rutController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, completa todos tus datos personales'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterEmergencyPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

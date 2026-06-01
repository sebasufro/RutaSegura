import 'package:flutter/material.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_header.dart';
import 'package:ruta_segura/core/presentation/widgets/primary_button.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_card.dart';
import 'package:ruta_segura/core/presentation/widgets/custom_text_field.dart';
import 'package:ruta_segura/core/presentation/widgets/input_label.dart';

/// Página final del registro para contacto de emergencia.
class RegisterEmergencyPage extends StatefulWidget {
  const RegisterEmergencyPage({super.key});

  @override
  State<RegisterEmergencyPage> createState() => _RegisterEmergencyPageState();
}

class _RegisterEmergencyPageState extends State<RegisterEmergencyPage> {
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  @override
  void dispose() {
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
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
                  const Text(
                    'Contacto de Emergencia',
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
                  backgroundColor: const Color(0x0C73000C), // Color SOS
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A quien notificaremos en caso de alerta SOS.',
                        style: TextStyle(color: Color(0xFF930013), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 24),

                      const InputLabel(text: 'NOMBRE DEL CONTACTO', color: Color(0x9973000C)),
                      CustomTextField(
                        controller: _emergencyNameController,
                        hintText: 'Familia cercana o Amigo',
                        prefixIcon: Icons.person_add_alt_1_outlined,
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'TELÉFONO DIRECTO', color: Color(0x9973000C)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('+56', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              VerticalDivider(width: 1, color: const Color(0xFF930013).withOpacity(0.1), indent: 12, endIndent: 12),
                              Expanded(
                                child: TextField(
                                  controller: _emergencyPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: '9 3390 4392',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Omitir este paso', style: TextStyle(color: Color(0xFF7A869C), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Finalizar Registro',
                    onPressed: () {
                      if (_emergencyNameController.text.isEmpty ||
                          _emergencyPhoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, completa los datos de contacto o presiona "Omitir"'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // Lógica de finalización
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

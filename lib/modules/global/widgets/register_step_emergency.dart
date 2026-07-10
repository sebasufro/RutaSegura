import 'package:flutter/material.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/widgets/custom_text_field.dart';
import '/modules/global/widgets/input_label.dart';
import '/modules/global/services/auth_service.dart';
import '/modules/global/utils/validators.dart'; 

/// Paso final del registro para ingresar un contacto de emergencia y enviar el payload completo.
class RegisterStepEmergency extends StatefulWidget {
  final Map<String, dynamic> formData;
  final Future<void> Function(Map<String, dynamic> payload) onFinish;

  const RegisterStepEmergency({
    super.key,
    required this.formData,
    required this.onFinish,
  });

  @override
  State<RegisterStepEmergency> createState() => _RegisterStepEmergencyState();
}

class _RegisterStepEmergencyState extends State<RegisterStepEmergency> {
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;

  @override
  void initState() {
    super.initState();
    _emergencyNameController = TextEditingController(text: widget.formData['emergency_contact_name'] ?? '');
    _emergencyPhoneController = TextEditingController(text: widget.formData['emergency_contact_number'] ?? '');
  }

  @override
  void dispose() {
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildPayload() {
    final payload = <String, dynamic>{
      'email': widget.formData['email'],
      'password': widget.formData['password'],
      'role': widget.formData['role'],
      'full_name': widget.formData['full_name'],
      'rut': widget.formData['rut'],
      'phone_number': widget.formData['phone_number'],
      'address': widget.formData['address'],
    };

    if (_emergencyNameController.text.isNotEmpty && _emergencyPhoneController.text.isNotEmpty) {
      payload['emergency_contact'] = {
        'contact_name': _emergencyNameController.text,
        'contact_number': '+56${_emergencyPhoneController.text}',
      };
    }

    if (widget.formData['role'] == 'SUPERVISOR') {
      payload['organization'] = widget.formData['organization'];
      payload['id_legal_person'] = widget.formData['id_legal_person'];
      if ((widget.formData['certificate_content'] as String?)?.isNotEmpty ?? false) {
        payload['certificate'] = {
          'name': widget.formData['certificate_name'],
          'content': widget.formData['certificate_content'],
        };
      }
    }

    return payload;
  }

  Future<void> _handleFinish() async {
    await widget.onFinish(_buildPayload());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Registro', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const Text('Contacto de Emergencia', style: TextStyle(color: Color(0xFF1E3A8A), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AuthCard(
              backgroundColor: const Color(0x0C73000C),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('A quien notificaremos en caso de alerta SOS.', style: TextStyle(color: Color(0xFF930013), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  const InputLabel(text: 'NOMBRE DEL CONTACTO', color: Color(0x9973000C)),
                  CustomTextField(controller: _emergencyNameController, hintText: 'Familia cercana o Amigo', prefixIcon: Icons.person_add_alt_1_outlined),
                  const SizedBox(height: 20),
                  const InputLabel(text: 'TELÉFONO DIRECTO', color: Color(0x9973000C)),
                  Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('+56', style: TextStyle(fontWeight: FontWeight.bold))),
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
                onPressed: _handleFinish,
                child: const Text('Omitir este paso', style: TextStyle(color: Color(0xFF7A869C), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Finalizar Registro',
              onPressed: () {
                  if (_emergencyNameController.text.isEmpty || _emergencyPhoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, completa los datos de contacto o presiona "Omitir"'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  if (!isValidClPhoneWithoutPrefix(_emergencyPhoneController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('El teléfono debe tener 9 dígitos y empezar con 9 (ej: 9 1234 5678)'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  _handleFinish();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/widgets/custom_text_field.dart';
import '/modules/global/widgets/input_label.dart';
import '/modules/global/utils/validators.dart';
import 'package:flutter/services.dart'; 
class RegisterStepPerson extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;

  const RegisterStepPerson({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<RegisterStepPerson> createState() => _RegisterStepPersonState();
}

class _RegisterStepPersonState extends State<RegisterStepPerson> {
  late TextEditingController _fullNameController;
  late TextEditingController _rutController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.formData['full_name'] ?? '');
    _rutController = TextEditingController(text: widget.formData['rut'] ?? '');
    _phoneController = TextEditingController(text: widget.formData['phone_number'] ?? '');
    _addressController = TextEditingController(text: widget.formData['address'] ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _rutController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
void _handleNext() {
    if (_fullNameController.text.isEmpty ||
        _rutController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos tus datos personales'), backgroundColor: Colors.red),
      );
      return;
    }

    if (!isValidRut(_rutController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El RUT ingresado no es válido'), backgroundColor: Colors.red),
      );
      return;
    }

    if (!isValidClPhoneWithoutPrefix(_phoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El teléfono debe tener 9 dígitos (ej: 9 1234 5678)'), backgroundColor: Colors.red),
      );
      return;
    }

    widget.formData['full_name'] = _fullNameController.text;
    widget.formData['rut'] = _rutController.text;
    widget.formData['phone_number'] = '+56${_phoneController.text}';
    widget.formData['address'] = _addressController.text;

    widget.onNext();
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
              const SizedBox(height: 8),
              const Text('Datos Personales', style: TextStyle(color: Color(0xFF1E3A8A), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
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
                  const Text('Ingresa tus datos como están en tus documentos.', style: TextStyle(color: Color(0xFF43474E), fontSize: 14)),
                  const SizedBox(height: 24),
                  const InputLabel(text: 'NOMBRE COMPLETO'),
                  CustomTextField(controller: _fullNameController, hintText: 'Nombres y Apellidos', prefixIcon: Icons.person_outline),
                  const SizedBox(height: 20),
                  const InputLabel(text: 'RUT'),
CustomTextField(
                    controller: _rutController,
                    hintText: '12.345.678-K',
                    prefixIcon: Icons.badge_outlined,
                    keyboardType: TextInputType.text,
                    inputFormatters: [RutInputFormatter()],
                  ),                  const SizedBox(height: 20),
                  const InputLabel(text: 'NÚMERO DE TELÉFONO'),
                  Container(
                    decoration: BoxDecoration(color: const Color(0xFFF2F4F6), borderRadius: BorderRadius.circular(12)),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('+56', style: TextStyle(fontWeight: FontWeight.bold))),
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
                  CustomTextField(controller: _addressController, hintText: 'Dirección', prefixIcon: Icons.home_outlined),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: PrimaryButton(label: 'Siguiente', onPressed: _handleNext),
        ),
      ],
    );
  }
}
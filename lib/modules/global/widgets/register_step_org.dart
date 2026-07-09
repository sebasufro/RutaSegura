import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/widgets/custom_text_field.dart';
import '/modules/global/widgets/input_label.dart';
import '/modules/global/utils/validators.dart';

class RegisterStepOrg extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;

  const RegisterStepOrg({
    super.key,
    required this.formData,
    required this.onNext,
  });

  @override
  State<RegisterStepOrg> createState() => _RegisterStepOrgState();
}

class _RegisterStepOrgState extends State<RegisterStepOrg> {
  late TextEditingController _orgNameController;
  late TextEditingController _pjNumberController;
  late TextEditingController _addressController;
  final _pjNumberFocusNode = FocusNode();
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _orgNameController = TextEditingController(text: widget.formData['organization'] ?? '');
    _pjNumberController = TextEditingController(text: widget.formData['id_legal_person'] ?? '');
    _addressController = TextEditingController(text: widget.formData['address'] ?? '');
    _fileName = widget.formData['certificate_name']?.toString().isEmpty ?? true
        ? null
        : widget.formData['certificate_name'];
        _pjNumberFocusNode.addListener(() {
      if (!_pjNumberFocusNode.hasFocus && _pjNumberController.text.isNotEmpty) {
        if (!isValidRut(_pjNumberController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El número de persona jurídica no es válido'), backgroundColor: Colors.red),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _orgNameController.dispose();
    _pjNumberController.dispose();
    _addressController.dispose();
    _pjNumberFocusNode.dispose();
    super.dispose();
  }
static const int _maxCertificateBytes = 300 * 1024; // 300 KB

  Future<void> _pickCertificate() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    final bytes = result.files.single.bytes!;

    if (bytes.length > _maxCertificateBytes) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El archivo debe pesar menos de 300 KB. Sube una versión más liviana.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _fileName = result.files.single.name;
    });
    widget.formData['certificate_name'] = result.files.single.name;
    widget.formData['certificate_content'] = base64Encode(bytes);
  }
 
void _handleNext() {
    if (_orgNameController.text.isEmpty ||
        _pjNumberController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos obligatorios'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_fileName == null || (widget.formData['certificate_content'] as String?)?.isEmpty != false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes subir el certificado de vigencia'), backgroundColor: Colors.red),
      );
      return;
    }

    widget.formData['organization'] = _orgNameController.text;
    widget.formData['id_legal_person'] = _pjNumberController.text;
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
              const Text('Registro', style: TextStyle(color: Colors.black, fontSize: 36, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Datos de Organización', style: TextStyle(color: Color(0xFF1E3A8A), fontSize: 14, fontStyle: FontStyle.italic, fontFamily: 'Inter', fontWeight: FontWeight.w700)),
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
                  const Text('Ingresa los datos de la organización como están en tus documentos', style: TextStyle(color: Color(0xFF43474E), fontSize: 14, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 24),
                  const InputLabel(text: 'NOMBRE DE ORGANIZACIÓN'),
                  CustomTextField(controller: _orgNameController, hintText: 'Ej: Ruta Segura ONG'),
                  const SizedBox(height: 20),
                  const InputLabel(text: 'NÚMERO PERSONA JURÍDICA'),
CustomTextField(
                    controller: _pjNumberController,
                    hintText: '12.345.674-0',
                    inputFormatters: [RutInputFormatter()],
                                        focusNode: _pjNumberFocusNode,

                  ),                  const SizedBox(height: 20),
                  const InputLabel(text: 'CERTIFICADO DE VIGENCIA'),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _pickCertificate,
                      icon: Icon(_fileName == null ? Icons.upload_file : Icons.check_circle_outline, color: Colors.white),
                      label: Text(_fileName ?? 'Subir Certificado', style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _fileName == null ? const Color(0xFF1E40AF) : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const InputLabel(text: 'DIRECCIÓN DOMICILIO ORGANIZACIÓN'),
                  CustomTextField(controller: _addressController, hintText: 'Dirección completa', prefixIcon: Icons.location_on_outlined),
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
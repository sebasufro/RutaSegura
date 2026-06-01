import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_header.dart';
import 'package:ruta_segura/core/presentation/widgets/primary_button.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_card.dart';
import 'package:ruta_segura/core/presentation/widgets/custom_text_field.dart';
import 'package:ruta_segura/core/presentation/widgets/input_label.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_person_page.dart';

/// Página para capturar los datos legales de la organización.
/// Solo se muestra en el flujo de registro de 'Supervisor'.
class RegisterOrgPage extends StatefulWidget {
  const RegisterOrgPage({super.key});

  @override
  State<RegisterOrgPage> createState() => _RegisterOrgPageState();
}

class _RegisterOrgPageState extends State<RegisterOrgPage> {
  final _orgNameController = TextEditingController();
  final _pjNumberController = TextEditingController();
  final _addressController = TextEditingController();
  String? _fileName;

  @override
  void dispose() {
    _orgNameController.dispose();
    _pjNumberController.dispose();
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
            const AuthHeader(), // Cabecera reutilizable

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registro',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Datos de Organización',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AuthCard( // Tarjeta blanca reutilizable
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingresa los datos de la organización como están en tus documentos',
                        style: TextStyle(
                          color: Color(0xFF43474E),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const InputLabel(text: 'NOMBRE DE ORGANIZACIÓN'),
                      CustomTextField(
                        controller: _orgNameController,
                        hintText: 'Ej: Ruta Segura ONG',
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'NÚMERO PERSONA JURÍDICA'),
                      CustomTextField(
                        controller: _pjNumberController,
                        hintText: 'PJ-12.345.674-0',
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'CERTIFICADO DE VIGENCIA'),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'jpg', 'png'],
                            );

                            if (result != null) {
                              setState(() {
                                _fileName = result.files.single.name;
                              });
                            }
                          },
                          icon: Icon(
                            _fileName == null ? Icons.upload_file : Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: Text(
                            _fileName ?? 'Subir Certificado',
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _fileName == null ? const Color(0xFF1E40AF) : Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const InputLabel(text: 'DIRECCIÓN DOMICILIO ORGANIZACIÓN'),
                      CustomTextField(
                        controller: _addressController,
                        hintText: 'Dirección completa',
                        prefixIcon: Icons.location_on_outlined,
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
                  if (_orgNameController.text.isEmpty ||
                      _pjNumberController.text.isEmpty ||
                      _addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, completa todos los campos obligatorios'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPersonPage()),
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

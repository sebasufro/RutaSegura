import 'package:flutter/material.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_person_page.dart';

/// Página para capturar los datos legales de la organización.
/// Solo se muestra en el flujo de registro de 'Supervisor'.
class RegisterOrgPage extends StatefulWidget {
  const RegisterOrgPage({super.key});

  @override
  State<RegisterOrgPage> createState() => _RegisterOrgPageState();
}

class _RegisterOrgPageState extends State<RegisterOrgPage> {
  // Controladores de texto para capturar los inputs del usuario
  final _orgNameController = TextEditingController();
  final _pjNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    // Es una buena práctica liberar los controladores al cerrar la pantalla
    // para evitar fugas de memoria (memory leaks).
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
            // --- Cabecera: Botón Volver y Logo ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset(
                    "assets/images/logo_minimalista.png",
                    width: 80,
                    height: 75,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 48), // Espaciador para centrado perfecto
                ],
              ),
            ),

            // --- Títulos de la Sección ---
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

            // --- Formulario dentro de una Tarjeta Blanca ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
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

                      // Campo: Nombre
                      _buildLabel('NOMBRE DE ORGANIZACIÓN'),
                      _buildTextField(
                        controller: _orgNameController,
                        hintText: 'Ej: Ruta Segura ONG',
                      ),
                      const SizedBox(height: 20),

                      // Campo: Persona Jurídica
                      _buildLabel('NÚMERO PERSONA JURÍDICA'),
                      _buildTextField(
                        controller: _pjNumberController,
                        hintText: 'PJ-12.345.674-0',
                      ),
                      const SizedBox(height: 20),

                      // Botón: Selector de Documento
                      _buildLabel('CERTIFICADO DE VIGENCIA'),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Integrar lógica de file picker
                          },
                          icon: const Icon(Icons.upload_file, color: Colors.white),
                          label: const Text(
                            'Subir Certificado',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E40AF),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Campo: Dirección
                      _buildLabel('DIRECCIÓN DOMICILIO ORGANIZACIÓN'),
                      _buildTextField(
                        controller: _addressController,
                        hintText: 'Dirección completa',
                        prefixIcon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Botón de Navegación ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega al siguiente paso: Datos Personales
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPersonPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Siguiente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Crea etiquetas de texto estandarizadas para los inputs
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF74777F),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.60,
        ),
      ),
    );
  }

  /// Construye campos de texto con el estilo visual del proyecto
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFF6B7280)) : null,
        filled: true,
        fillColor: const Color(0xFFF2F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

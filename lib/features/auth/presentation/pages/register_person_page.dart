import 'package:flutter/material.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_emergency_page.dart';

/// Página para capturar los datos personales del usuario (Nombre, RUT, Teléfono, Dirección).
/// Es un paso común tanto para Voluntarios como para Supervisores.
class RegisterPersonPage extends StatefulWidget {
  const RegisterPersonPage({super.key});

  @override
  State<RegisterPersonPage> createState() => _RegisterPersonPageState();
}

class _RegisterPersonPageState extends State<RegisterPersonPage> {
  // Controladores para gestionar el texto ingresado en los campos
  final _fullNameController = TextEditingController();
  final _rutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    // Liberación de recursos al destruir el widget
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
            // --- Cabecera con Logo Centrado ---
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
                  const SizedBox(width: 48), // Balance visual para el botón volver
                ],
              ),
            ),

            // --- Títulos Informativos ---
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
                    'Datos Personales',
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

            // --- Contenedor del Formulario ---
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
                        'Ingresa tus datos como están en tus documentos.',
                        style: TextStyle(
                          color: Color(0xFF43474E),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Input: Nombre
                      _buildLabel('NOMBRE COMPLETO'),
                      _buildTextField(
                        controller: _fullNameController,
                        hintText: 'Nombres y Apellidos',
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),

                      // Input: RUT (Formato Chileno)
                      _buildLabel('RUT'),
                      _buildTextField(
                        controller: _rutController,
                        hintText: '12.345.678-K',
                        prefixIcon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Input: Teléfono con Prefijo +56
                      _buildLabel('NÚMERO DE TELÉFONO'),
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
                                child: Text(
                                  '+56',
                                  style: TextStyle(
                                    color: Color(0xFF191C1E),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                indent: 12,
                                endIndent: 12,
                                color: Colors.black.withOpacity(0.1),
                              ),
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

                      // Input: Dirección Domiciliaria
                      _buildLabel('DIRECCIÓN DOMICILIO'),
                      _buildTextField(
                        controller: _addressController,
                        hintText: 'Dirección',
                        prefixIcon: Icons.home_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Botón de Acción ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega al paso de contacto de emergencia
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterEmergencyPage(),
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

  /// Etiquetas de campo consistentes
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

  /// TextField personalizado para el diseño del proyecto
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

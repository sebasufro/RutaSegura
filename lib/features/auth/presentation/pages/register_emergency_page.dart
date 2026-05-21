import 'package:flutter/material.dart';

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
            // Header: Back Button and Logo
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
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Titles
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
                    'Contacto de Emergencia',
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

            // Emergency Card (with specific reddish styling for alert)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: ShapeDecoration(
                    color: const Color(0x0C73000C), // Very light red background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x4C490303),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A quien notificaremos en caso de alerta SOS.',
                        style: TextStyle(
                          color: Color(0xFF930013),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nombre del Contacto
                      _buildLabel('NOMBRE DEL CONTACTO', color: const Color(0x9973000C)),
                      _buildTextField(
                        controller: _emergencyNameController,
                        hintText: 'Familia cercana o Amigo',
                        prefixIcon: Icons.person_add_alt_1_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Teléfono Directo
                      _buildLabel('TELÉFONO DIRECTO', color: const Color(0x9973000C)),
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
                                color: const Color(0xFF930013).withOpacity(0.1),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _emergencyPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    hintText: '9 3390 4392',
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
                    ],
                  ),
                ),
              ),
            ),

            // Buttons Area
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Action for skip
                    },
                    child: const Text(
                      'Omitir este paso',
                      style: TextStyle(
                        color: Color(0xFF7A869C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Finalize registration
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Finalizar Registro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.60,
        ),
      ),
    );
  }

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
        fillColor: Colors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

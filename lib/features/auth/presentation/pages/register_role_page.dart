import 'package:flutter/material.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_header.dart';
import 'package:ruta_segura/core/presentation/widgets/primary_button.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_card.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_org_page.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_person_page.dart';

/// Página de selección de rol durante el proceso de registro.
/// Permite al usuario elegir entre ser 'Voluntario' o 'Supervisor'.
class RegisterRolePage extends StatefulWidget {
  const RegisterRolePage({super.key});

  @override
  State<RegisterRolePage> createState() => _RegisterRolePageState();
}

class _RegisterRolePageState extends State<RegisterRolePage> {
  // Estado local para almacenar el rol seleccionado (por defecto 'voluntario')
  String _selectedRole = 'voluntario';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(), // Widget reutilizable para la cabecera
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Títulos de la sección
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registro',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.35,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Selección de Rol',
                          style: TextStyle(
                            color: Color(0xFF1E3A8A),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Contenedor de opciones
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AuthCard( // Widget reutilizable para la tarjeta
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '¿Eres organizador o voluntario?',
                              style: TextStyle(
                                color: Color(0xFF43474E),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildRoleOption(
                              id: 'voluntario',
                              title: 'Voluntario',
                              description: 'Gestión de equipos y monitoreo de seguridad de voluntarios.',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildRoleOption(
                              id: 'supervisor',
                              title: 'Supervisor',
                              description: 'Coordinación general y supervisión de rutas y seguridad.',
                              icon: Icons.admin_panel_settings_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón Siguiente reutilizable
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                label: 'Siguiente',
                onPressed: () {
                  if (_selectedRole == 'supervisor') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterOrgPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPersonPage()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget para construir las tarjetas de selección de rol.
  Widget _buildRoleOption({
    required String id,
    required String title,
    required String description,
    required IconData icon,
  }) {
    bool isSelected = _selectedRole == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = id),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF002045), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF002045),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF43474E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFFC4C6CF),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF1E40AF) : Colors.transparent,
              ),
              child: isSelected 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
            ),
          ],
        ),
      ),
    );
  }
}

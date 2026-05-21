import 'package:flutter/material.dart';
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
            // Cabecera: Botón Volver y Logo Centrado
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
                  const SizedBox(width: 48), // Espaciador técnico para equilibrar el botón volver y centrar el logo
                ],
              ),
            ),
            
            // --- Cuerpo Principal ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Títulos de la sección
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registro',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selección de Rol',
                          style: TextStyle(
                            color: const Color(0xFF1E3A8A),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Contenedor de opciones con scroll
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
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
                            // Opción: Voluntario
                            _buildRoleOption(
                              id: 'voluntario',
                              title: 'Voluntario',
                              description: 'Gestión de equipos y monitoreo de seguridad de voluntarios.',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                            // Opción: Supervisor
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
            
            // --- Botón de Acción Inferior ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica de navegación basada en el rol seleccionado
                    if (_selectedRole == 'supervisor') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterOrgPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPersonPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
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

  /// Helper widget para construir las tarjetas de selección de rol.
  /// [id] identificador único del rol.
  /// [title] nombre visible del rol.
  /// [description] texto explicativo.
  /// [icon] icono representativo.
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
            // Indicador visual de selección (Checkmark)
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

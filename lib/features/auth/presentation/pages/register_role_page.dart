import 'package:flutter/material.dart';

class RegisterRolePage extends StatefulWidget {
  const RegisterRolePage({super.key});

  @override
  State<RegisterRolePage> createState() => _RegisterRolePageState();
}

class _RegisterRolePageState extends State<RegisterRolePage> {
  String _selectedRole = 'voluntario'; // 'voluntario' o 'supervisor'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "assets/images/logo_minimalista.png",
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar a la siguiente parte del registro
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

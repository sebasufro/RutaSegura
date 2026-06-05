import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/profile_avatar_section.dart';
import '/modules/supervisor/widgets/info_field.dart';

class ProfileSupervisorScreen extends StatefulWidget {
  const ProfileSupervisorScreen({super.key});

  @override
  State<ProfileSupervisorScreen> createState() => _ProfileSupervisorScreenState();
}

class _ProfileSupervisorScreenState extends State<ProfileSupervisorScreen> {
  // User data
  final String userName = 'Juan Perez';
  final String userEmail = 'juanperez@ejemplo.com';
  final String fullName = 'Juan Ignacio Perez Olivares';
  final String rut = '19.640.973-4';
  final String phone = '+56 9 3310 9203';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
          width: double.infinity,
          height: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                // Main Content
                Column(
                  children: [
                    // Topbar
                    const SupTopbar(),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Profile Avatar Section
                            ProfileAvatarSection(
                              name: userName,
                              email: userEmail,
                            ),

                            // Info Fields Section
                            Container(
                              color: const Color(0xFFF5F7FA),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              child: Column(
                                spacing: 20,
                                children: [
                                  // Full Name Field
                                  InfoField(
                                    label: 'NOMBRE COMPLETO',
                                    value: fullName,
                                    isEditable: false,
                                  ),

                                  // RUT Field
                                  InfoField(
                                    label: 'RUT',
                                    value: rut,
                                    isEditable: false,
                                  ),

                                  // Phone Field
                                  InfoField(
                                    label: 'TELÉFONO',
                                    value: phone,
                                    isEditable: true,
                                    onEditPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Editar teléfono'),
                                        ),
                                      );
                                    },
                                  ),

                                  // Email Field
                                  InfoField(
                                    label: 'CORREO ELECTRÓNICO',
                                    value: userEmail,
                                    isEditable: true,
                                    onEditPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Editar correo'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // Configuration Button
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 24,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF1E40AF),
                                        Color(0xFF1E3A8A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            const Color(0xFF1E40AF)
                                                .withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Ir a Configuración'),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: const Center(
                                        child: Text(
                                          'CONFIGURACIÓN',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Extra space for bottom nav
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
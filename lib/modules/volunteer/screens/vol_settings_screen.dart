import 'package:flutter/material.dart';

class VolSettingsScreen extends StatelessWidget {
  const VolSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header simulado del código proporcionado
            Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 26,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://placehold.co/28x26"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'RUTA SEGURA',
                      style: TextStyle(
                        color: Color(0xFF1E3A8A),
                        fontSize: 20,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Column(
                    children: [
                      // Título y botón volver
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, size: 24),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                'Preferencias',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF002045),
                                  fontSize: 32,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // Balance
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),

                      // Tarjeta Accesibilidad
                      _buildSectionCard(
                        icon: Icons.accessibility_new,
                        title: 'Accesibilidad',
                        children: [
                          _buildToggleTile(
                            title: 'Modo Oscuro',
                            subtitle: 'Reduce la fatiga visual.',
                            value: false,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tamaño de Letra',
                            style: TextStyle(
                              color: Color(0xFF191C1D),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFontSizeSelector(),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Tarjeta Notificaciones
                      _buildSectionCard(
                        icon: Icons.notifications_none,
                        title: 'Notificaciones',
                        children: [
                          _buildActionTile(
                            title: 'Alertas de Ruta',
                            trailing: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFF002373),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.check, size: 16, color: Colors.white),
                            ),
                          ),
                          const Divider(height: 32, color: Color(0xFFECEEEF)),
                          _buildActionTile(
                            title: 'Actualizaciones',
                            trailing: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFC5C5D4)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Tarjeta Privacidad
                      _buildSectionCard(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacidad',
                        children: [
                          _buildActionTile(
                            title: 'Ubicación',
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCE1FF),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Text(
                                'Siempre',
                                style: TextStyle(
                                  color: Color(0xFF002373),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 32, color: Color(0xFFECEEEF)),
                          const _buildActionTile(
                            title: 'Historial de Rutas',
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7A869C)),
                          ),
                          const Divider(height: 32, color: Color(0xFFECEEEF)),
                          const _buildActionTile(
                            title: 'Eliminar Cuenta',
                            titleColor: Color(0xFFBA1A1A),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7A869C)),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 100),
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

  Widget _buildSectionCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191C1D),
            blurRadius: 32,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0x191B3A92),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF1B3A92), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF191C1D),
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleTile({required String title, required String subtitle, required bool value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF191C1D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF444652),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 24,
            decoration: BoxDecoration(
              color: value ? const Color(0xFF1B3A92) : const Color(0xFFE1E3E4),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: value ? 24 : 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFECEEEF), width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE1E3E4),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          _buildFontSizeOption('A-', false),
          _buildFontSizeOption('A', true),
          _buildFontSizeOption('A+', false),
        ],
      ),
    );
  }

  Widget _buildFontSizeOption(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: isSelected ? [
            const BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            )
          ] : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF002373) : const Color(0xFF444652),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({required String title, Color? titleColor, required Widget trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? const Color(0xFF191C1D),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing,
      ],
    );
  }
}

class _buildActionTile extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget trailing;

  const _buildActionTile({
    required this.title,
    this.titleColor,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? const Color(0xFF191C1D),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing,
      ],
    );
  }
}

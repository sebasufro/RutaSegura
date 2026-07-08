import 'package:flutter/material.dart';
import '../../volunteer/widgets/vol_topbar.dart';

/// Página de Preferencias Globales (Accesibilidad, Notificaciones, Privacidad).
class GlobalSettingsPage extends StatefulWidget {
  const GlobalSettingsPage({super.key});

  @override
  State<GlobalSettingsPage> createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
  // Estados locales para interactividad visual solamente
  bool _isDarkMode = false;
  String _fontSize = 'A';
  bool _routeAlerts = true;
  bool _updates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: const VolTopbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 100),
            child: Column(
                    children: [
                      // Título con botón de retroceso
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
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
                            const SizedBox(width: 48), // Espaciador para centrar el título
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Sección Accesibilidad
                      _buildSectionCard(
                        icon: Icons.accessibility_new,
                        iconColor: const Color(0xFF1B3A92),
                        iconBgColor: const Color(0x191B3A92),
                        title: 'Accesibilidad',
                        children: [
                          _buildToggleTile(
                            title: 'Modo Oscuro',
                            subtitle: 'Reduce la fatiga visual.',
                            value: _isDarkMode,
                            onTap: () => setState(() => _isDarkMode = !_isDarkMode),
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

                      // Sección Notificaciones
                      _buildSectionCard(
                        icon: Icons.notifications_none,
                        iconColor: const Color(0xFF1E3A8A),
                        iconBgColor: const Color(0x4CCDD5FF),
                        title: 'Notificaciones',
                        children: [
                          _buildActionTile(
                            title: 'Alertas de Ruta',
                            onTap: () => setState(() => _routeAlerts = !_routeAlerts),
                            trailing: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _routeAlerts ? const Color(0xFF002373) : Colors.transparent,
                                border: Border.all(color: _routeAlerts ? const Color(0xFF002373) : const Color(0xFFC5C5D4)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _routeAlerts ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                            ),
                          ),
                          const Divider(height: 32, color: Color(0xFFECEEEF)),
                          _buildActionTile(
                            title: 'Actualizaciones',
                            onTap: () => setState(() => _updates = !_updates),
                            trailing: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: _updates ? const Color(0xFF002373) : Colors.transparent,
                                border: Border.all(color: _updates ? const Color(0xFF002373) : const Color(0xFFC5C5D4)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: _updates ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Sección Privacidad
                      _buildSectionCard(
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFFB45309),
                        iconBgColor: const Color(0x66FFDBCD),
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
                          _buildActionTile(
                            title: 'Historial de Rutas',
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF7A869C)),
                          ),
                          const Divider(height: 32, color: Color(0xFFECEEEF)),
                          _buildActionTile(
                            title: 'Eliminar Cuenta',
                            titleColor: const Color(0xFFBA1A1A),
                            trailing: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFBA1A1A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    )
    );
  }

  Widget _buildSectionCard({
    required IconData icon, 
    required Color iconColor,
    required Color iconBgColor,
    required String title, 
    required List<Widget> children,
  }) {
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
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
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

  Widget _buildToggleTile({required String title, required String subtitle, required bool value, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          _buildFontSizeOption('A-', _fontSize == 'A-'),
          _buildFontSizeOption('A', _fontSize == 'A'),
          _buildFontSizeOption('A+', _fontSize == 'A+'),
        ],
      ),
    );
  }

  Widget _buildFontSizeOption(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _fontSize = label),
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
      ),
    );
  }

  Widget _buildActionTile({required String title, Color? titleColor, required Widget trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
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
      ),
    );
  }
}

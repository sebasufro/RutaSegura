import 'package:flutter/material.dart';
import 'package:ruta_segura/features/auth/presentation/pages/login_page.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_role_page.dart';

/// Página de bienvenida y entrada principal a la aplicación.
/// Ofrece las opciones iniciales de Iniciar Sesión o Crear una Cuenta.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones de la pantalla para asegurar la responsividad en diferentes dispositivos
    final screenSize = MediaQuery.of(context).size;


    return Scaffold(
      // Fondo pastel definido en el diseño de marca
      backgroundColor: const Color(0xFFDBEAFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            // Asegura que el contenido ocupe al menos el alto disponible de la pantalla
            constraints: BoxConstraints(
              minHeight: screenSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ilustración principal / Logo de la aplicación
                Container(
                  width: double.infinity,
                  height: screenSize.height * 0.35, // Ocupa el 35% del alto de pantalla
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_principal.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Botón: Crear Cuenta (Inicia el flujo de registro)
                _buildActionButton(
                  context: context,
                  label: 'Crear Cuenta',
                  backgroundColor: const Color(0xFF002045), 
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterRolePage()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Botón:  Iniciar Sesión (Acceso para usuarios existentes)
                _buildActionButton(
                  context: context,
                  label: 'Iniciar Sesión',
                  backgroundColor: const Color(0xFF1E40AF), // color-blue-40
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye un botón de acción estandarizado para la pantalla de bienvenida.
  /// 
  /// [context] Contexto de construcción para la navegación.
  /// [label] Texto descriptivo del botón.
  /// [backgroundColor] Color de fondo del botón.
  /// [onPressed] Callback que se ejecuta al presionar el botón.
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320), // Limita el ancho en pantallas grandes (tablets)
      height: 56, // Altura estándar ergonómica
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4C002045),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color(0x4C002045),
            blurRadius: 15,
            offset: Offset(0, 10),
            spreadRadius: -3,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

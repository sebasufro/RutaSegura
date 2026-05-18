import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones de la pantalla para asegurar la responsividad
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // Definimos el color de fondo pastel que venía desde Figma
      backgroundColor: const Color(0xFFDBEAFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            // Forzamos a que el contenedor ocupe al menos el alto disponible del dispositivo
            constraints: BoxConstraints(
              minHeight: screenSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: screenSize.height * 0.35, // 35% del alto de la pantalla
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_principal.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Botón: Sign Up (Crear Cuenta)
                _buildActionButton(
                  context: context,
                  label: 'Crear Cuenta',
                  backgroundColor: const Color(0xFF002045), // color-azure-14
                  onPressed: () {
                    // TODO: Navegar a RegisterPage
                  },
                ),
                const SizedBox(height: 16),

                // Botón: Sign In (Iniciar Sesión)
                _buildActionButton(
                  context: context,
                  label: 'Iniciar Sesión',
                  backgroundColor: const Color(0xFF1E40AF), // color-blue-40
                  onPressed: () {
                    // TODO: Navegar a LoginPage
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Componente interno reutilizable para evitar duplicar código de botones
  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity, // El botón se adapta al ancho de la pantalla
      constraints: const BoxConstraints(maxWidth: 320), // Evita que en pantallas grandes se deforme
      height: 56,             // Altura estándar ergonómica para interacción móvil
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
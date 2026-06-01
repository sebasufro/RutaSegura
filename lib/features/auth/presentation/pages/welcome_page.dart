import 'package:flutter/material.dart';
import 'package:ruta_segura/core/presentation/widgets/primary_button.dart';
import 'package:ruta_segura/features/auth/presentation/pages/login_page.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_role_page.dart';

import 'package:ruta_segura/features/auth/presentation/pages/register_account_page.dart';

/// Página de bienvenida y entrada principal a la aplicación.
/// Ofrece las opciones iniciales de Iniciar Sesión o Crear una Cuenta.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones de la pantalla para asegurar la responsividad
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
                  height: screenSize.height * 0.35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo_principal.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Botón: Crear Cuenta (Usa el PrimaryButton compartido)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: PrimaryButton(
                    label: 'Crear Cuenta',
                    backgroundColor: const Color(0xFF002045), // Azul oscuro
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterAccountPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Botón: Iniciar Sesión (Usa el PrimaryButton compartido)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: PrimaryButton(
                    label: 'Iniciar Sesión',
                    backgroundColor: const Color(0xFF1E40AF), // Azul brillante
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

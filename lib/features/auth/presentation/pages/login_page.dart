import 'package:flutter/material.dart';

/// Página de Iniciar Sesión.
/// Permite a los usuarios registrados acceder a su cuenta mediante correo y contraseña.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Control de estado para la visibilidad de la contraseña
  bool _obscurePassword = true;
  // Control de estado para la opción "Recordarme"
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Cabecera: Botón Volver y Logo Centrado ---
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
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
                      const SizedBox(width: 48), // Espaciador para balancear el botón y centrar el logo
                    ],
                  ),
                ),

                // Tarjeta contenedora del formulario de login
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(32),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x1F000000), // Sombra suave para elevación visual
                        blurRadius: 50,
                        offset: Offset(0, 25),
                        spreadRadius: -12,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Títulos de bienvenida
                      const Center(
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Color(0xFF002045),
                            fontSize: 28,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Ingresa a tu cuenta para continuar',
                          style: TextStyle(
                            color: Color(0xFF43474E),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Campo: Correo Electrónico
                      const Text(
                        'Correo Electrónico',
                        style: TextStyle(
                          color: Color(0xFF191C1E),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'nombre@ejemplo.com',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF74777F)),
                          filled: true,
                          fillColor: const Color(0xFFF2F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cabecera de Contraseña con enlace de recuperación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Contraseña',
                            style: TextStyle(
                              color: Color(0xFF191C1E),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Implementar flujo de recuperación de contraseña
                            },
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Color(0xFF002045),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Campo: Contraseña con selector de visibilidad
                      TextField(
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF74777F)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: const Color(0xFF74777F),
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF2F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Opción: Mantener sesión iniciada
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: const Color(0xFF002045),
                            onChanged: (val) => setState(() => _rememberMe = val!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          const Text(
                            'Mantener sesión iniciada',
                            style: TextStyle(color: Color(0xFF43474E), fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Botón: Iniciar Sesión (Acción principal)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implementar lógica de autenticación
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002045),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 8,
                            shadowColor: const Color(0x4C002045),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Iniciar Sesión', style: TextStyle(fontSize: 18, color: Colors.white)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Enlace para nuevos usuarios
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navegar al flujo de registro
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(color: Color(0xFF43474E), fontSize: 16),
                              children: [
                                TextSpan(text: '¿No tienes una cuenta? '),
                                TextSpan(
                                  text: 'Regístrate ahora',
                                  style: TextStyle(color: Color(0xFF002045), fontWeight: FontWeight.bold),
                                ),
                              ],
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
        ),
      ),
    );
  }
}

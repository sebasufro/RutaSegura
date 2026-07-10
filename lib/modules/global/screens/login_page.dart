import 'package:flutter/material.dart';
import '/modules/global/screens/forgot_password_page.dart';
import '/modules/global/widgets/auth_header.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/widgets/custom_text_field.dart';
import '/modules/global/widgets/input_label.dart';
import '/modules/global/screens/register_flow_screen.dart';
import '/modules/global/services/auth_service.dart';
import '/modules/volunteer/widgets/vol_navbar.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';

/// Página de inicio de sesión para acceder a la aplicación con correo y contraseña.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                const AuthHeader(), // Cabecera reutilizable

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AuthCard(
                    // Tarjeta blanca reutilizable
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

                        // Campo de Correo Electrónico
                        const InputLabel(text: 'Correo Electrónico'),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'nombre@ejemplo.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),

                        // Cabecera de Contraseña
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const InputLabel(text: 'Contraseña'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage(),
                                  ),
                                );
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
                        CustomTextField(
                          controller: _passwordController,
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF74777F),
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Opción Recordarme
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: const Color(0xFF002045),
                              onChanged: (val) =>
                                  setState(() => _rememberMe = val!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Text(
                              'Mantener sesión iniciada',
                              style: TextStyle(
                                color: Color(0xFF43474E),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Botón de Iniciar Sesión
                        PrimaryButton(
                          label: _isLoading ? 'Cargando...' : 'Iniciar Sesión',
                          backgroundColor: const Color(0xFF002045),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text
                                      .trim();

                                  if (email.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Ingresa tu correo y contraseña',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() => _isLoading = true);

                                  final result = await _authService.login(
                                    email,
                                    password,
                                  );

                                  if (!mounted) return;
                                  setState(() => _isLoading = false);

                                  if (result['success']) {
                                    final role = result['role'] as String;
                                    if (role == 'VOLUNTEER') {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const VolNavbar(),
                                        ),
                                        (route) => false,
                                      );
                                    } else if (role == 'SUPERVISOR') {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SupNavbar(),
                                        ),
                                        (route) => false,
                                      );
                                    } else if (role == 'ADMIN') {
                                      SnackBar(
                                        content: Text(
                                          result['message'] ??
                                              'No es posible iniciar sesión como admin',
                                        ),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result['message'] ??
                                              'Error al iniciar sesión',
                                        ),
                                      ),
                                    );
                                  }
                                },
                        ),
                        const SizedBox(height: 32),

                        // Enlace de Registro
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterFlowScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Color(0xFF43474E),
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(text: '¿No tienes una cuenta? '),
                                  TextSpan(
                                    text: 'Regístrate ahora',
                                    style: TextStyle(
                                      color: Color(0xFF002045),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

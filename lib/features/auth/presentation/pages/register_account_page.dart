import 'package:flutter/material.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_header.dart';
import 'package:ruta_segura/core/presentation/widgets/primary_button.dart';
import 'package:ruta_segura/core/presentation/widgets/auth_card.dart';
import 'package:ruta_segura/core/presentation/widgets/custom_text_field.dart';
import 'package:ruta_segura/core/presentation/widgets/input_label.dart';
import 'package:ruta_segura/features/auth/presentation/pages/login_page.dart';
import 'package:ruta_segura/features/auth/presentation/pages/register_role_page.dart';

/// Primera página del flujo de registro.
/// Captura las credenciales básicas: Correo, Contraseña y Confirmación.
class RegisterAccountPage extends StatefulWidget {
  const RegisterAccountPage({super.key});

  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage> {
  // Controladores con datos de prueba (Hardcoded)
  final _emailController = TextEditingController(text: 'jhon.doe@example.com');
  final _passwordController = TextEditingController(text: 'Password123!');
  final _confirmPasswordController = TextEditingController(text: 'Password123!');

  // Estados para visibilidad de contraseñas
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AuthHeader(), // Cabecera con logo centrado

            // Títulos de la página
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registro',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Información de Cuenta',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tarjeta con el formulario
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AuthCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ingresa tu correo y contraseña.',
                        style: TextStyle(
                          color: Color(0xFF43474E),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Campo: Correo Electrónico
                      const InputLabel(text: 'CORREO ELECTRÓNICO'),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'ejemplo@rutasegura.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),

                      // Campo: Contraseña
                      const InputLabel(text: 'CONTRASEÑA'),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF74777F),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo: Confirmar Contraseña
                      const InputLabel(text: 'CONFIRMAR CONTRASEÑA'),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_clock_outlined,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF74777F),
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Botones de acción
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Ingresar a Cuenta Existente',
                      style: TextStyle(
                        color: Color(0xFF7A869C),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Siguiente',
                    onPressed: () {
                      // Validación básica
                      if (_emailController.text.isEmpty || 
                          _passwordController.text.isEmpty || 
                          _confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, completa todos los campos'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Las contraseñas no coinciden'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Navega al siguiente paso: Selección de Rol
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterRolePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

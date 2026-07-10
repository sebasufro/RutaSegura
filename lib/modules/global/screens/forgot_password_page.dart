import 'package:flutter/material.dart';
import '/modules/global/widgets/auth_header.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/widgets/custom_text_field.dart';
import '/modules/global/widgets/input_label.dart';
import '/modules/global/screens/verify_code_page.dart';

/// Página para solicitar el código de recuperación de contraseña.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController(text: 'jhon.doe@example.com');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthHeader(), // Cabecera reutilizable

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'Recuperación Cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.35,
                      ),
                    ),

                    const SizedBox(height: 30),

                    AuthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Solicitar código',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF002373),
                                fontSize: 32,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.80,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ingresa el correo electrónico asociado a tu cuenta de Ruta Segura. Te enviaremos un código de seguridad para restablecer tu acceso.',
                            style: TextStyle(
                              color: Color(0xFF444652),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),

                          const InputLabel(text: 'Correo electrónico'),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'ejemplo@correo.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),

                          PrimaryButton(
                            label: 'Enviar código',
                            backgroundColor: const Color(0xFF1E40AF),
                            onPressed: () {
                              if (_emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Por favor, ingresa tu correo electrónico',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              // Simulación de envío de código y navegación
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Código enviado satisfactoriamente',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VerifyCodePage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: Color(0xFF002373),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Volver al inicio de sesión',
                            style: TextStyle(
                              color: Color(0xFF002373),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

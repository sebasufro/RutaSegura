import 'package:flutter/material.dart';
import '/modules/global/widgets/auth_header.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/widgets/custom_text_field.dart';
import '/modules/global/widgets/input_label.dart';

/// Página para que el usuario establezca su nueva contraseña.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              const AuthHeader(),

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
                              'Establecer contraseña',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF002373),
                                fontSize: 30,
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.75,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          const InputLabel(text: 'Nueva contraseña'),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Ingresa tu nueva contraseña',
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
                          
                          const InputLabel(text: 'Confirmar contraseña'),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Repite la nueva contraseña',
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: const Color(0xFF74777F),
                              ),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          PrimaryButton(
                            label: 'Actualizar contraseña',
                            onPressed: () {
                              if (_passwordController.text != _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Las contraseñas no coinciden'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              
                              // Lógica de actualización
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Contraseña actualizada correctamente'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              
                              // Volver al login o inicio
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
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

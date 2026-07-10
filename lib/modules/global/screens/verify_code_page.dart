import 'dart:async';
import 'package:flutter/material.dart';
import '/modules/global/widgets/auth_header.dart';
import '/modules/global/widgets/primary_button.dart';
import '/modules/global/widgets/auth_card.dart';
import '/modules/global/screens/reset_password_page.dart';

/// Pantalla para validar el código de seguridad enviado al correo del usuario.
class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  Timer? _timer;
  int _start = 60;

  void startTimer() {
    setState(() {
      _start = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildCodeDigit(int index) {
    return Container(
      width: 48,
      height: 56,
      decoration: ShapeDecoration(
        color: const Color(0xFFF2F4F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: 'Manrope',
          color: Color(0xFF191C1D),
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Verifica tu identidad',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF002373),
                              fontSize: 32,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.80,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Hemos enviado un código de seguridad temporal a tu correo electrónico.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF444652),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) => _buildCodeDigit(index)),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          const Text(
                            '¿No recibiste el código?',
                            style: TextStyle(
                              color: Color(0xFF444652),
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextButton(
                            onPressed: _start == 0 ? startTimer : null,
                            child: Text(
                              'Reenviar en $timerText',
                              style: TextStyle(
                                color: _start == 0 ? const Color(0xFF002373) : const Color(0xFF444652).withAlpha(128),
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          PrimaryButton(
                            label: 'Verificar',
                            onPressed: () {
                              // Simulación de validación exitosa
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
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
                            'Volver atrás',
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

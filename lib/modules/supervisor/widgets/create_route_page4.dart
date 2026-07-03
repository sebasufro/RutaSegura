import 'package:flutter/material.dart';

class CreateRoutePage4 extends StatelessWidget {
  final VoidCallback onFinish;

  const CreateRoutePage4({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Spacer
        const Expanded(child: SizedBox()),

        // Success Message Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            spacing: 32,
            children: [
              const Text(
                'Creado Correctamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF002045),
                  height: 1.25,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: onFinish,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF002045),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF003B7E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Finalizar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE7ECFB),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Spacer
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

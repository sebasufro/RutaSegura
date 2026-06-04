import 'package:flutter/material.dart';

class EditRoutePage4 extends StatelessWidget {
  final VoidCallback onFinish;

  const EditRoutePage4({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: const Text(
            'Editar Ruta Social',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF002045),
            ),
          ),
        ),

        // Success Message
        Expanded(
          child: Center(
            child: Container(
              width: 306,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 32,
                children: [
                  const Text(
                    'Ruta Editada Correctamente',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF002045),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: onFinish,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          ),
        ),

        // Bottom padding for spacing
        const SizedBox(height: 110),
      ],
    );
  }
}

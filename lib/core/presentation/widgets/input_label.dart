import 'package:flutter/material.dart';

/// Etiqueta de texto para campos de formulario.
/// Estilo en mayúsculas, negrita y color gris suave.
class InputLabel extends StatelessWidget {
  final String text;
  final Color? color;

  const InputLabel({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color ?? const Color(0xFF74777F),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.60,
        ),
      ),
    );
  }
}

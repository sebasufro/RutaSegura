import 'package:flutter/material.dart';

/// Etiqueta visual para mostrar información clave (como zona, horario o capacidad).
/// Utilizada comúnmente debajo del título de una ruta.
class RouteDetailsLabel extends StatelessWidget {
  final IconData icono;
  final String texto;
  final Color colorFondo;
  final Color colorTexto;

  const RouteDetailsLabel({
    super.key,
    required this.icono,
    required this.texto,
    required this.colorFondo,
    required this.colorTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 16, color: colorTexto),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorTexto,
            ),
          ),
        ],
      ),
    );
  }
}
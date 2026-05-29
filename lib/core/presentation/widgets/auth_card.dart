import 'package:flutter/material.dart';

/// Contenedor en forma de tarjeta blanca con bordes redondeados y sombra.
/// Se utiliza para agrupar campos de formulario en las páginas de auth.
class AuthCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const AuthCard({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: ShapeDecoration(
        color: backgroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: child,
    );
  }
}

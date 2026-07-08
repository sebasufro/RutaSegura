import 'package:flutter/material.dart';

/// Cabecera estandarizada para pantallas de autenticación.
/// Incluye un botón de retroceso y el logo de la aplicación centrado.
class AuthHeader extends StatelessWidget {
  /// Acción al presionar la flecha. Si no se especifica, hace
  /// Navigator.pop(context) (comportamiento por defecto).
  final VoidCallback? onBack;

  const AuthHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: onBack ?? () => Navigator.pop(context),
          ),
          Image.asset(
            "assets/images/logo_minimalista.png",
            width: 80,
            height: 75,
            fit: BoxFit.contain,
          ),
          // Espaciador técnico de 48px para equilibrar el IconButton y lograr un centrado perfecto del logo
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
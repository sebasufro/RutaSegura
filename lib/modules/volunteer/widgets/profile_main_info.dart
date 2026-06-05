import 'package:flutter/material.dart';

// Componente visual del perfil que muestra el avatar,
// nombre y correo electrónico del usuario.
class ProfileMainInfo extends StatelessWidget {
  final String nombre;
  final String correo;
  final Color colorPrincipal;

  const ProfileMainInfo({
    super.key,
    required this.nombre,
    required this.correo,
    required this.colorPrincipal,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorPrincipal, width: 4),
              color: Colors.white,
            ),
            child: Icon(
              Icons.person,
              size: 60,
              color: colorPrincipal,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            nombre,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorPrincipal,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            correo,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

// Tarjeta para mostrar y opcionalmente editar
// información específica del perfil del usuario.

class ProfileInfoCard extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool esEditable;
  final VoidCallback? onEditar;

  const ProfileInfoCard({
    super.key,
    required this.etiqueta,
    required this.valor,
    this.esEditable = false,
    this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (esEditable)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E3A8A)),
              onPressed: onEditar ?? () {},
            ),
        ],
      ),
    );
  }
}
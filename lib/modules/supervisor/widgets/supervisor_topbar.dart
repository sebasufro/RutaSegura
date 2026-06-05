import 'package:flutter/material.dart';

class SupTopbar extends StatelessWidget implements PreferredSizeWidget {
  const SupTopbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);
    
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Icon(Icons.hub_outlined, color: colorPrincipal),
          const SizedBox(width: 8),
          Text(
            'RUTA SEGURA',
            style: TextStyle(
              color: colorPrincipal,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); 
}
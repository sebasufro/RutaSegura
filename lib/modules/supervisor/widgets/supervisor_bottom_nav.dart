import 'package:flutter/material.dart';

class ListRoutesBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const ListRoutesBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(22, 16, 24, 76).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NavItem(
              icon: Icons.star,
              label: 'RUTAS',
              isActive: currentIndex == 0,
              onTap: () => onNavigate(0),
            ),
            const SizedBox(width: 36),
            _NavItem(
              icon: Icons.location_on,
              label: 'MAPA',
              isActive: currentIndex == 1,
              onTap: () => onNavigate(1),
            ),
            const SizedBox(width: 36),
            _NavItem(
              icon: Icons.person,
              label: 'PERFIL',
              isActive: currentIndex == 2,
              onTap: () => onNavigate(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26.42, vertical: 6.5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFdbeafe) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

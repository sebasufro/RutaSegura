import 'package:flutter/material.dart';

class ProfileSupervisorBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const ProfileSupervisorBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE8EAED),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.star,
            label: 'RUTAS',
            isActive: currentIndex == 0,
            onTap: () => onNavigate(0),
          ),
          _NavItem(
            icon: Icons.location_on,
            label: 'MAPA',
            isActive: currentIndex == 1,
            onTap: () => onNavigate(1),
          ),
          _NavItem(
            icon: Icons.person,
            label: 'PERFIL',
            isActive: currentIndex == 2,
            onTap: () => onNavigate(2),
          ),
        ],
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
        color: isActive ? const Color(0xFFF5F7FA) : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFF1E40AF) : const Color(0xFF7A869C),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color:
                    isActive ? const Color(0xFF1E40AF) : const Color(0xFF7A869C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

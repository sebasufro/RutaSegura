import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_main_info.dart';
import 'vol_settings_screen.dart';
import 'vol_contacts_screen.dart';
import 'vol_addresses_screen.dart';

class VolProfileScreen extends StatelessWidget {
  const VolProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A); 

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), 
      appBar: const VolTopbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            ProfileMainInfo(
              nombre: 'Juan Perez',
              correo: 'juanperez@ejemplo.com',
              colorPrincipal: colorPrincipal,
            ),
            const SizedBox(height: 40),

            const ProfileInfoCard(
              etiqueta: 'NOMBRE COMPLETO',
              valor: 'Juan Ignacio Perez Olivares',
              esEditable: false,
            ),
            const SizedBox(height: 15),
            
            const ProfileInfoCard(
              etiqueta: 'RUT',
              valor: '19.640.973-4',
              esEditable: false,
            ),
            const SizedBox(height: 15),

            ProfileInfoCard(
              etiqueta: 'TELÉFONO',
              valor: '+56 9 3310 9203',
              esEditable: true,
              onEditar: () {
                // TODO: Implementar lógica de edición de teléfono
              },
            ),
            const SizedBox(height: 15),

            ProfileInfoCard(
              etiqueta: 'CORREO ELECTRÓNICO',
              valor: 'juanperez@ejemplo.com',
              esEditable: true,
              onEditar: () {
                // TODO: Implementar lógica de edición de correo
              },
            ),
            const SizedBox(height: 30),

            // Mis Contactos
            _buildMenuOption(
              context,
              icon: Icons.contacts_outlined,
              label: 'Mis contactos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VolContactsScreen()),
              ),
            ),
            const SizedBox(height: 12),

            // Mis Direcciones
            _buildMenuOption(
              context,
              icon: Icons.location_on_outlined,
              label: 'Mis Direcciones',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VolAddressesScreen()),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VolSettingsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283593),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Configuración',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1E3A8A)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

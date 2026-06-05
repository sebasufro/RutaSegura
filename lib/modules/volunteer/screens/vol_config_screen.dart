import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/vol_config_card.dart';
import '../screens/vol_my_contacts_screen.dart';
import '../screens/vol_my_directions_screen.dart';

class VolConfigScreen extends StatelessWidget {
  const VolConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const VolTopbar(), 
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 20.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Configuración',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  VolConfigCard(
                    titulo: 'Mis Direcciones',
                    subtitulo: 'Casa, trabajo y lugares frecuentes',
                    icono: Icons.home_work_outlined,
                    colorFondoIcono: const Color(0xFFE0E7FF),
                    colorIcono: const Color(0xFF3730A3),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VolMyDirectionsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  VolConfigCard(
                    titulo: 'Contactos de Emergencia',
                    subtitulo: 'Personas de confianza para alertas',
                    icono: Icons.perm_contact_calendar_outlined,
                    colorFondoIcono: const Color(0xFFFFE4E6), 
                    colorIcono: const Color(0xFFE11D48),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VolMyContactsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  VolConfigCard(
                    titulo: 'Ajustes de Preferencia',
                    subtitulo: 'Notificaciones, idioma y privacidad',
                    icono: Icons.tune,
                    colorFondoIcono: const Color(0xFFE0E7FF), 
                    colorIcono: const Color(0xFF4F46E5),
                    onTap: () {
                      // Navegar a direcciones
                    },
                  ),
                  
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Lógica para cerrar sesión futura
                      },
                      icon: const Icon(Icons.logout, color: Color(0xFFB91C1C)),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Color(0xFFB91C1C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.red[200]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
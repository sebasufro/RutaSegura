import 'package:flutter/material.dart';
import '../vol_widgets/vol_topbar.dart';
import '../vol_widgets/contact_card.dart';

class VolMyContactsScreen extends StatelessWidget {
  const VolMyContactsScreen({super.key});

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
                    'Mis contactos',
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
                  ContactCard(
                    nombre: 'María Andrea Yáñez',
                    telefono: '+56 9 8765 4321',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                  const SizedBox(height: 15),
                  ContactCard(
                    nombre: 'Carlos Ruiz',
                    telefono: '+56 9 1234 5678',
                    onEdit: () {},
                    onDelete: () {},
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Mostrar popup agregar contacto
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Agregar contacto',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
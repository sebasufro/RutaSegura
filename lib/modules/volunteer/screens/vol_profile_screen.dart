import 'package:flutter/material.dart';
import '../widgets/vol_topbar.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_main_info.dart';

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
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vista de configuración en desarrollo...')),
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
}
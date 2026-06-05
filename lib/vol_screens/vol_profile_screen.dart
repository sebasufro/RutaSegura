import 'package:flutter/material.dart';
import '../vol_widgets/vol_topbar.dart';
import '../vol_widgets/profile_info_card.dart';
import '../vol_widgets/profile_main_info.dart';
import '../vol_screens/vol_config_screen.dart'; 
import '../vol_widgets/profile_edit_dialog.dart';

class VolProfileScreen extends StatefulWidget {
  const VolProfileScreen({super.key});

  @override
  State<VolProfileScreen> createState() => _VolProfileScreenState();
}

class _VolProfileScreenState extends State<VolProfileScreen> {
  String _telefono = '+56 9 3310 9203';
  String _correo = 'juanperez@ejemplo.com';

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
              correo: _correo,
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
              valor: _telefono,
              esEditable: true,
              onEditar: () {
                mostrarPopupEditarPerfil(
                  context,
                  titulo: 'Editar Teléfono',
                  labelCampo: 'NÚMERO DE TELÉFONO',
                  valorInicial: _telefono,
                  hintText: '+56 9 XXXX XXXX',
                  keyboardType: TextInputType.phone,
                  onGuardar: (nuevoValor) {
                    setState(() => _telefono = nuevoValor);
                    // TODO: llamar API PATCH
                  },
                );
              },
            ),
            const SizedBox(height: 15),

            ProfileInfoCard(
              etiqueta: 'CORREO ELECTRÓNICO',
              valor: _correo,
              esEditable: true,
              onEditar: () {
                mostrarPopupEditarPerfil(
                  context,
                  titulo: 'Editar Correo',
                  labelCampo: 'CORREO ELECTRÓNICO',
                  valorInicial: _correo,
                  hintText: 'ejemplo@correo.com',
                  keyboardType: TextInputType.emailAddress,
                  onGuardar: (nuevoValor) {
                    setState(() => _correo = nuevoValor);
                    // TODO: llamar API PATCH
                  },
                );
              },
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VolConfigScreen(),
                    ),
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
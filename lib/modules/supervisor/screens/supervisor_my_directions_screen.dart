import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/direction_card.dart';
import '/modules/supervisor/widgets/direction_dialog.dart';

// Pantalla de direcciones guardadas del supervisor.
// Navegada desde el perfil, permite agregar, editar y eliminar direcciones.
class VolMyDirectionsScreen extends StatelessWidget {
  const VolMyDirectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const SupTopbar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 20.0),
              child: Row(
                children: const [
                  Text(
                    'Mis Direcciones',
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
                  DirectionCard(
                    alias: 'Trabajo',
                    direccion: 'Avenida Alemania 0671, Temuco',
                    onEdit: () {
                      mostrarPopupEditarDireccion(
                        context,
                        aliasActual: 'Trabajo',
                        direccionActual: 'Avenida Alemania 0671, Temuco',
                        onGuardar: (alias, direccion) {
                          // TODO: llamar API PATCH
                          debugPrint('Editar: $alias - $direccion');
                        },
                      );
                    },
                    onDelete: () {
                      mostrarPopupEliminarDireccion(
                        context,
                        alias: 'Trabajo',
                        onConfirmar: () {
                          // TODO: llamar API DELETE
                          debugPrint('Eliminar: Trabajo');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  DirectionCard(
                    alias: 'Hogar',
                    direccion: 'Pasaje Los Boldos 1234, Temuco',
                    onEdit: () {
                      mostrarPopupEditarDireccion(
                        context,
                        aliasActual: 'Hogar',
                        direccionActual: 'Pasaje Los Boldos 1234, Temuco',
                        onGuardar: (alias, direccion) {
                          // TODO: llamar API PATCH
                          debugPrint('Editar: $alias - $direccion');
                        },
                      );
                    },
                    onDelete: () {
                      mostrarPopupEliminarDireccion(
                        context,
                        alias: 'Hogar',
                        onConfirmar: () {
                          // TODO: llamar API DELETE
                          debugPrint('Eliminar: Hogar');
                        },
                      );
                    },
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
                    mostrarPopupAgregarDireccion(
                      context,
                      onGuardar: (alias, direccion) {
                        // TODO: llamar API POST
                        debugPrint('Agregar: $alias - $direccion');
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Agregar dirección',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
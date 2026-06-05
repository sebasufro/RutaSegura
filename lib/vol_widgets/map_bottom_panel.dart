import 'package:flutter/material.dart';

// Panel inferior expansible que muestra los compañeros cercanos en ruta.
// Al tocar el panel, alterna entre estado contraído y expandido.
// En estado expandido muestra la lista completa y el botón para finalizar rastreo.
class MapBottomPanel extends StatefulWidget {
  // Cantidad de compañeros activos cercanos al usuario.
  final int cantidadCompaneros;

  const MapBottomPanel({super.key, required this.cantidadCompaneros});

  @override
  State<MapBottomPanel> createState() => _MapBottomPanelState();
}

class _MapBottomPanelState extends State<MapBottomPanel> {
  // Controla si el panel está expandido o contraído.
  bool _expandido = false;

  // Lista simulada de voluntarios activos en el sector.
  // TODO: Reemplazar con llamada a la API.
  final List<Map<String, dynamic>> _companerosCercanos = [
    {'nombre': 'María José',  'iniciales': 'MJ', 'color': const Color(0xFFF59E0B)},
    {'nombre': 'Sofía Karina','iniciales': 'SK', 'color': const Color(0xFF4F46E5)},
    {'nombre': 'Carlos Ruiz', 'iniciales': 'CR', 'color': const Color(0xFF10B981)},
  ];

  // Muestra un diálogo de confirmación antes de finalizar el rastreo GPS.
  // Si el usuario confirma, cierra el diálogo y regresa a la pantalla anterior.
  void _mostrarPopupFinalizar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, color: Colors.redAccent, size: 28),
              SizedBox(width: 10),
              Text('Finalizar Rastreo', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Recuerda desactivar siempre el rastreo GPS en un área segura.',
            style: TextStyle(fontSize: 15, height: 1.4),
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Cierra el diálogo
                        Navigator.pop(context); // Sale de la pantalla del mapa
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Finalizar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expandido = !_expandido),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E7EB).withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cerca de ti: ${widget.cantidadCompaneros} compañeros',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Zona Segura - Sector Noroeste',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                // Alterna entre mini avatares (contraído) y flecha (expandido)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: !_expandido
                      ? _MiniAvataresCompaneros(
                          key: const ValueKey('avatares'),
                          companeros: _companerosCercanos,
                        )
                      : Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 28,
                          key: const ValueKey('flecha'),
                        ),
                ),
              ],
            ),

            // Animación de expansión del panel
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: _expandido
                  ? Column(
                      children: [
                        const SizedBox(height: 15),
                        const Divider(thickness: 1, color: Colors.white),
                        const SizedBox(height: 10),

                        // Lista de compañeros activos en la ruta
                        ..._companerosCercanos.map(
                          (comp) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: comp['color'] as Color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      comp['iniciales']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  comp['nombre']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.gps_fixed, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 4),
                                const Text(
                                  'En ruta',
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Botón para finalización de rastreo
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _mostrarPopupFinalizar(context),
                            icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 20),
                            label: const Text(
                              'FINALIZAR RASTREO',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Center(
                        child: Icon(Icons.keyboard_arrow_up, color: Colors.grey, size: 20),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar privado que muestra un grupo de hasta 2 avatares superpuestos.
// Se renderiza en la cabecera del panel cuando este está contraído.
class _MiniAvataresCompaneros extends StatelessWidget {
  // Lista de compañeros desde la que se toman los primeros 2 para mostrar.
  final List<Map<String, dynamic>> companeros;

  const _MiniAvataresCompaneros({super.key, required this.companeros});

  @override
  Widget build(BuildContext context) {
    final visibles = companeros.take(2).toList();

    return SizedBox(
      width: 65,
      height: 35,
      child: Stack(
        children: List.generate(
          visibles.length,
          (i) => Positioned(
            left: i * 25.0,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: visibles[i]['color'] as Color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  visibles[i]['iniciales']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
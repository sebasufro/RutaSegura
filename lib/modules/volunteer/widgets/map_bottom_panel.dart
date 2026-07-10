import 'package:flutter/material.dart';

class MapBottomPanel extends StatefulWidget {
  final List<Map<String, dynamic>> companeros;
  final String? routeName;
  final String? miId;
  final Future<void> Function()? onFinalizar;

  const MapBottomPanel({super.key, required this.companeros, this.routeName, this.miId, this.onFinalizar});

  @override
  State<MapBottomPanel> createState() => _MapBottomPanelState();
}

const _kColores = [
  Color(0xFF4F46E5),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF8B5CF6),
  Color(0xFF06B6D4),
];

class _MapBottomPanelState extends State<MapBottomPanel> {
  bool _expandido = false;

  // Muestra un diálogo de confirmación antes de finalizar el rastreo GPS.
  // Si el usuario confirma, cierra el diálogo y regresa a la pantalla anterior.
  void _mostrarPopupFinalizar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        bool _cargando = false;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                'Recuerda desactivar siempre el rastreo GPS en un área segura. Se te desinscribirá de la ruta automáticamente.',
                style: TextStyle(fontSize: 15, height: 1.4),
                textAlign: TextAlign.center,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _cargando ? null : () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _cargando ? null : () async {
                            setStateDialog(() => _cargando = true);
                            Navigator.pop(dialogContext);
                            if (widget.onFinalizar != null) {
                              await widget.onFinalizar!();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _cargando
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Finalizar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
                        'En ruta: ${widget.companeros.where((c) => c['id_user'] != widget.miId).length} compañeros',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.routeName ?? 'Sin nombre de ruta',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
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
                          companeros: widget.companeros.where((c) => c['id_user'] != widget.miId).toList(),
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

                        if (widget.companeros.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              'Ningún compañero ha compartido su ubicación aún.',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                            ),
                          )
                        else
                          ...(() {
                            final ordenados = [...widget.companeros]..sort((a, b) {
                              if (a['id_user'] == widget.miId) return -1;
                              if (b['id_user'] == widget.miId) return 1;
                              return 0;
                            });
                            return ordenados.asMap().entries.map((entry) {
                            final i = entry.key;
                            final comp = entry.value;
                            final esYo = comp['id_user'] == widget.miId;
                            final nombre = esYo ? 'Yo' : (comp['full_name'] ?? '?').toString();
                            final fullName = (comp['full_name'] ?? '?').toString();
                            final partes = fullName.trim().split(' ');
                            final iniciales = esYo ? 'YO' : (partes.length >= 2
                                ? '${partes[0][0]}${partes[1][0]}'.toUpperCase()
                                : fullName.substring(0, fullName.length >= 2 ? 2 : 1).toUpperCase());
                            final color = esYo ? const Color(0xFF1A73E8) : _kColores[i % _kColores.length];
                            final tieneSos = comp['sos_active'] == true;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: tieneSos ? Colors.red[700] : color,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        iniciales,
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      nombre,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (tieneSos) ...[
                                    const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                                    const SizedBox(width: 4),
                                    const Text('SOS', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ] else ...[
                                    const Icon(Icons.gps_fixed, size: 14, color: Color(0xFF10B981)),
                                    const SizedBox(width: 4),
                                    const Text('En ruta', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                                  ],
                                ],
                              ),
                            );
                          });
                          })(),

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

class _MiniAvataresCompaneros extends StatelessWidget {
  final List<Map<String, dynamic>> companeros;

  const _MiniAvataresCompaneros({super.key, required this.companeros});

  @override
  Widget build(BuildContext context) {
    final visibles = companeros.take(2).toList();
    if (visibles.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: 25.0 * visibles.length + 10,
      height: 35,
      child: Stack(
        children: List.generate(visibles.length, (i) {
          final nombre = (visibles[i]['full_name'] ?? '?').toString();
          final partes = nombre.trim().split(' ');
          final iniciales = partes.length >= 2
              ? '${partes[0][0]}${partes[1][0]}'.toUpperCase()
              : nombre.substring(0, nombre.length >= 2 ? 2 : 1).toUpperCase();
          final color = _kColores[i % _kColores.length];
          return Positioned(
            left: i * 25.0,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(iniciales, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
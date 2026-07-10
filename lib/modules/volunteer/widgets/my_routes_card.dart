import 'package:flutter/material.dart';
import '../screens/vol_route_details_screen.dart';
import '/modules/global/services/geocoding_service.dart';

enum _EstadoUnirse { activo, bloqueado }

// Componente visual que representa una ruta a la que el usuario está inscrito.
// Incluye información general, un menú de opciones para desinscribirse
// y botones para unirse a la actividad o ver sus detalles.
class MyRoutesCard extends StatefulWidget {
  final String titulo;
  final String horario;
  final int voluntariosActivos;
  final String imagenUrl;
  final VoidCallback onDesinscribir;
  final VoidCallback? onUnirse;
  final Map<String, dynamic> rutaDatos;
  final String? startingDatetime;

  const MyRoutesCard({
    super.key,
    required this.titulo,
    required this.horario,
    required this.voluntariosActivos,
    required this.imagenUrl,
    required this.onDesinscribir,
    required this.rutaDatos,
    this.onUnirse,
    this.startingDatetime,
  });

  @override
  State<MyRoutesCard> createState() => _MyRoutesCardState();
}

class _MyRoutesCardState extends State<MyRoutesCard> {
  String? _comuna;

  @override
  void initState() {
    super.initState();
    _cargarComuna();
  }

  Future<void> _cargarComuna() async {
    final puntos = (widget.rutaDatos["base_points"] ?? widget.rutaDatos["street_geometry"] ?? []) as List;
    if (puntos.isEmpty) return;
    final lat = (puntos.first['lat'] as num).toDouble();
    final lng = (puntos.first['lng'] as num).toDouble();
    final comuna = await GeocodingService.getComuna(lat, lng);
    if (mounted && comuna != null) setState(() => _comuna = comuna);
  }

  _EstadoUnirse _calcularEstado() {
    if (widget.startingDatetime == null) return _EstadoUnirse.bloqueado;
    final inicio = DateTime.tryParse(widget.startingDatetime!)?.toLocal();
    if (inicio == null) return _EstadoUnirse.bloqueado;
    final ahora = DateTime.now();
    final diferencia = inicio.difference(ahora);
    if (diferencia.isNegative && ahora.isBefore(inicio.add(const Duration(hours: 4)))) {
      return _EstadoUnirse.activo; // ya comenzó y no ha pasado más de 4h
    }
    if (diferencia.inMinutes <= 15 && !diferencia.isNegative) {
      return _EstadoUnirse.activo; // faltan ≤15 min
    }
    return _EstadoUnirse.bloqueado;
  }

  String _textoTiempoRestante() {
    if (widget.startingDatetime == null) return 'Unirse';
    final inicio = DateTime.tryParse(widget.startingDatetime!)?.toLocal();
    if (inicio == null) return 'Unirse';
    final diff = inicio.difference(DateTime.now());
    if (diff.isNegative) return 'En curso';
    if (diff.inHours >= 1) return 'En ${diff.inHours}h ${diff.inMinutes % 60}min';
    return 'En ${diff.inMinutes}min';
  }

  void _mostrarPopupDesinscribir(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text('Confirmar', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            '¿Estás seguro de que deseas desinscribirte de "${widget.titulo}"? Ya no aparecerás en la lista de asistencia de esta actividad.',
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDesinscribir();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Te has desinscrito de la ruta correctamente.',
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sí, desinscribir',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.imagenUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildTag(
                          Icons.location_on,
                          _comuna ?? '...',
                          const Color(0xFFE8F5E9),
                          const Color(0xFF2E7D32),
                        ),
                        _buildTag(
                          Icons.access_time,
                          widget.horario,
                          const Color(0xFFE3F2FD),
                          const Color(0xFF1565C0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'desinscribir') _mostrarPopupDesinscribir(context);
                },
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'desinscribir',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Desinscribir',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildStackedAvatars(),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Voluntarios inscritos: ${widget.voluntariosActivos}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(builder: (_) {
                final estado = _calcularEstado();
                final activo = estado == _EstadoUnirse.activo;
                return ElevatedButton.icon(
                  onPressed: activo ? widget.onUnirse : null,
                  icon: Icon(activo ? Icons.directions_run : Icons.schedule, size: 18),
                  label: Text(
                    activo ? 'Unirse' : _textoTiempoRestante(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activo ? const Color(0xFF10B981) : Colors.grey[200],
                    foregroundColor: activo ? Colors.white : Colors.grey[500],
                    disabledBackgroundColor: Colors.grey[200],
                    disabledForegroundColor: Colors.grey[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 0,
                  ),
                );
              }),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VolRouteDetailsScreen(
                        rutaDatos: widget.rutaDatos,
                        yaInscrito: true,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Text(
                      'Detalles',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(
      IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedAvatars() {
    return SizedBox(
      width: 75,
      height: 28,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=1',
              ),
              backgroundColor: Colors.grey[200],
            ),
          ),
          Positioned(
            left: 18,
            child: CircleAvatar(
              radius: 14,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/100?img=33',
              ),
              backgroundColor: Colors.grey[300],
            ),
          ),
          Positioned(
            left: 36,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[300],
              child: Text(
                '+${widget.voluntariosActivos > 2 ? widget.voluntariosActivos - 2 : 0}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:math';
import 'package:flutter/material.dart';
import '../screens/vol_route_details_screen.dart';
import '/modules/global/services/geocoding_service.dart';

// Componente visual que representa una ruta disponible en la plataforma.
// Muestra información clave como el nombre, descripción, capacidad,
// distancia y permite navegar a los detalles de la ruta.
class TarjetaRuta extends StatefulWidget {
  final Map<String, dynamic> datosRuta;

  const TarjetaRuta({super.key, required this.datosRuta});

  @override
  State<TarjetaRuta> createState() => _TarjetaRutaState();
}

class _TarjetaRutaState extends State<TarjetaRuta> {
  String? _comuna;

  @override
  void initState() {
    super.initState();
    _cargarComuna();
  }

  Future<void> _cargarComuna() async {
    final puntos = (widget.datosRuta["base_points"] ?? widget.datosRuta["street_geometry"] ?? []) as List;
    if (puntos.isEmpty) return;
    final lat = (puntos.first['lat'] as num).toDouble();
    final lng = (puntos.first['lng'] as num).toDouble();
    final comuna = await GeocodingService.getComuna(lat, lng);
    if (mounted && comuna != null) setState(() => _comuna = comuna);
  }

  @override
  Widget build(BuildContext context) {
    final datosRuta = widget.datosRuta;
    final titulo = datosRuta["route_name"] ?? "Ruta Desconocida";
    final descripcion = datosRuta["descripcion"] ??
        "Breve descripción del trayecto y puntos de control a lo largo del perímetro monitoreado.";
    const imagenUrl =
        'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=800&auto=format&fit=crop';

    final rawDist = datosRuta["distancia_metros"] ?? datosRuta["distance_meters"] ?? 0;
    double distanciaMetros = double.tryParse(rawDist.toString()) ?? 0.0;
    if (distanciaMetros == 0) {
      final puntos = (datosRuta["street_geometry"] ?? datosRuta["base_points"] ?? []) as List;
      distanciaMetros = _calcularDistancia(puntos);
    }
    String textoDistancia = distanciaMetros > 1000
        ? '${(distanciaMetros / 1000).toStringAsFixed(1)} KM'
        : distanciaMetros > 0 ? '${distanciaMetros.toInt()} M' : 'Sin dato';

    final transporteTipo = (datosRuta["transport_type"] ?? 'A PIE').toString();
    final rawFecha = datosRuta["starting_datetime"] ?? datosRuta["starting_date"];
    String textoHorario = 'SIN HORARIO';
    if (rawFecha != null) {
      final fecha = DateTime.tryParse(rawFecha.toString())?.toLocal();
      if (fecha != null) {
        final h = fecha.hour.toString().padLeft(2, '0');
        final m = fecha.minute.toString().padLeft(2, '0');
        textoHorario = '$h:$m';
      }
    }

    final int voluntariosActivos = (datosRuta["capacidad_maxima"] ?? 10) ~/ 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imagenUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildTag(Icons.location_on, _comuna ?? '...'),
                    _buildTag(Icons.access_time, textoHorario,
                        const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildStackedAvatars(voluntariosActivos),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Voluntarios inscritos: $voluntariosActivos',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  descripcion,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_walk,
                            color: Color(0xFF1E3A8A)),
                        const SizedBox(width: 5),
                        Text(
                          textoDistancia,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VolRouteDetailsScreen(rutaDatos: datosRuta),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward,
                              size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  double _calcularDistancia(List puntos) {
    if (puntos.length < 2) return 0;
    const r = 6371000.0;
    double total = 0;
    for (int i = 0; i < puntos.length - 1; i++) {
      final lat1 = (puntos[i]['lat'] as num).toDouble() * pi / 180;
      final lat2 = (puntos[i + 1]['lat'] as num).toDouble() * pi / 180;
      final dLat = lat2 - lat1;
      final dLng = ((puntos[i + 1]['lng'] as num) - (puntos[i]['lng'] as num)).toDouble() * pi / 180;
      final a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
      total += r * 2 * atan2(sqrt(a), sqrt(1 - a));
    }
    return total;
  }

  Widget _buildTag(IconData icon, String text,
      [Color bgColor = const Color(0xFFE8F5E9), Color textColor = const Color(0xFF2E7D32)]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStackedAvatars(int activos) {
    return SizedBox(
      width: 80,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/100?img=1'),
              backgroundColor: Colors.grey[200],
            ),
          ),
          Positioned(
            left: 20,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/100?img=33'),
              backgroundColor: Colors.grey[300],
            ),
          ),
          Positioned(
            left: 40,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey[300],
              child: Text(
                '+${activos > 2 ? activos - 2 : 0}',
                style: const TextStyle(
                  fontSize: 11,
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
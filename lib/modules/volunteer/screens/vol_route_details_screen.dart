import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/route_details_map.dart';
import '../widgets/route_details_label.dart';
import '../widgets/vol_topbar.dart';
import '/modules/global/services/routes_service.dart';

// Pantalla que muestra los detalles completos de una ruta.
// Incluye información sobre el supervisor, horario, mapa del trazado
// y permite al voluntario inscribirse en la actividad.

class VolRouteDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> rutaDatos;
  final bool yaInscrito;

  const VolRouteDetailsScreen({super.key, required this.rutaDatos, this.yaInscrito = false});

  @override
  State<VolRouteDetailsScreen> createState() => _VolRouteDetailsScreenState();
}

class _VolRouteDetailsScreenState extends State<VolRouteDetailsScreen> {
  late bool _estaInscrito;
  bool _cargandoInscripcion = false;
  final _routesService = RoutesService();

  @override
  void initState() {
    super.initState();
    _estaInscrito = widget.yaInscrito;
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);
    
    final titulo = widget.rutaDatos["route_name"] ?? "Ruta Sin Nombre";
    final descripcion = widget.rutaDatos["description"] ?? widget.rutaDatos["descripcion"] ?? "Sin descripción.";
    final capacidad = widget.rutaDatos["spots_remaining"] ?? widget.rutaDatos["capacidad_maxima"] ?? 0;
    final supervisor = widget.rutaDatos["supervisor"];
    final supervisorNombre = supervisor != null ? (supervisor["full_name"] ?? "Sin supervisor") : "Sin supervisor";
    final transporteTipo = widget.rutaDatos["transport_type"] ?? "A PIE";

    final List<dynamic> baseData = widget.rutaDatos["base_points"] ?? widget.rutaDatos["puntos_base"] ?? [];
    final List<LatLng> puntosBase = baseData.map((punto) {
      return LatLng((punto["lat"] as num).toDouble(), (punto["lng"] as num).toDouble());
    }).toList();

    final List<dynamic> geoData = widget.rutaDatos["street_geometry"] ?? widget.rutaDatos["geometria_calle"] ?? baseData;
    final List<LatLng> lineaDeCalle = geoData.map((punto) {
      return LatLng((punto["lat"] as num).toDouble(), (punto["lng"] as num).toDouble());
    }).toList();

    final LatLng centroDeRespaldo = const LatLng(-38.769, -72.597);

    final rawDistancia = widget.rutaDatos["distance_meters"] ?? widget.rutaDatos["distancia_metros"] ?? 0;
    double distanciaTotalMetros = double.tryParse(rawDistancia.toString()) ?? 0.0;
    if (distanciaTotalMetros == 0) {
      final puntos = (widget.rutaDatos["street_geometry"] ?? widget.rutaDatos["base_points"] ?? widget.rutaDatos["geometria_calle"] ?? widget.rutaDatos["puntos_base"] ?? []) as List;
      if (puntos.length >= 2) {
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
        distanciaTotalMetros = total;
      }
    }
    String textoDistancia = distanciaTotalMetros > 1000
        ? '${(distanciaTotalMetros / 1000).toStringAsFixed(1)} KM'
        : '${distanciaTotalMetros.toInt()} METROS';

    final rawFecha = widget.rutaDatos["starting_datetime"] ?? widget.rutaDatos["starting_date"];
    String textoFecha = "Sin fecha definida";
    if (rawFecha != null) {
      try {
        DateTime fecha = DateTime.parse(rawFecha);
        String dia = fecha.day.toString().padLeft(2, '0');
        String mes = fecha.month.toString().padLeft(2, '0');
        String hora = fecha.hour.toString().padLeft(2, '0');
        String minuto = fecha.minute.toString().padLeft(2, '0');
        textoFecha = "$dia/$mes/${fecha.year} a las $hora:$minuto";
      } catch (e) {
        debugPrint("Error parseando fecha: $e");
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const VolTopbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo.toUpperCase(),
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.1, color: colorPrincipal),
              ),
              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF283593), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_circle_outlined, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text('SUPERVISOR: ${supervisorNombre.toUpperCase()}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                descripcion,
                style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.4),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  RouteDetailsLabel(
                    icono: Icons.directions,
                    texto: transporteTipo.toUpperCase(),
                    colorFondo: const Color(0xFFE8F5E9),
                    colorTexto: const Color(0xFF2E7D32),
                  ),
                  RouteDetailsLabel(
                    icono: Icons.access_time,
                    texto: textoFecha,
                    colorFondo: const Color(0xFFE3F2FD),
                    colorTexto: const Color(0xFF1565C0),
                  ),
                  RouteDetailsLabel(
                    icono: Icons.group,
                    texto: 'MÁX $capacidad VOLUNTARIOS',
                    colorFondo: Colors.orange[100]!,
                    colorTexto: Colors.orange[900]!,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: RouteDetailsMap(
                  lineaDeCalle: lineaDeCalle,
                  puntosBase: puntosBase,
                  centroDeRespaldo: centroDeRespaldo,
                  colorPrincipal: colorPrincipal,
                ),
              ),
              
              if (distanciaTotalMetros > 0) ...[
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.route_outlined, size: 20, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Distancia aproximada a recorrer: $textoDistancia',
                        style: TextStyle(
                          fontSize: 15, 
                          color: Colors.grey[800], 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ] else ...[
                const SizedBox(height: 30),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_estaInscrito || _cargandoInscripcion) ? null : () async {
                    final routeId = widget.rutaDatos['id_route'] as String?;
                    if (routeId == null) return;
                    setState(() => _cargandoInscripcion = true);
                    final token = await _routesService.enroll(routeId);
                    if (!mounted) return;
                    setState(() => _cargandoInscripcion = false);
                    if (token) {
                      setState(() => _estaInscrito = true);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Te has inscrito con éxito en la ruta!'), backgroundColor: Colors.green));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al inscribirse. Intenta de nuevo.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrincipal, 
                    disabledBackgroundColor: Colors.grey[400], 
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                    elevation: _estaInscrito ? 0 : 4
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_estaInscrito) ...[
                        const Icon(Icons.event_available, color: Colors.white70), 
                        const SizedBox(width: 8)
                      ],
                      Expanded(
                        child: Text(
                          _estaInscrito 
                              ? 'Agendada para: $textoFecha' 
                              : 'Inscribirse en ruta', 
                          style: TextStyle(
                            fontSize: _estaInscrito ? 15 : 18, 
                            fontWeight: FontWeight.bold, 
                            color: _estaInscrito ? Colors.white70 : Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (_estaInscrito) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Puedes ingresar a la actividad desde 15 minutos antes de la hora establecida.',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], fontStyle: FontStyle.italic, height: 1.3),
                      ),
                    ),
                  ],
                )
              ],
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/route_details_map.dart';
import '../widgets/route_details_label.dart';
import '../widgets/vol_topbar.dart';

// Pantalla que muestra los detalles completos de una ruta.
// Incluye información sobre el supervisor, horario, mapa del trazado
// y permite al voluntario inscribirse en la actividad.

class VolRouteDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> rutaDatos;

  const VolRouteDetailsScreen({super.key, required this.rutaDatos});

  @override
  State<VolRouteDetailsScreen> createState() => _VolRouteDetailsScreenState();
}

class _VolRouteDetailsScreenState extends State<VolRouteDetailsScreen> {
  /// Indica si el voluntario ya se ha inscrito en esta ruta.
  bool _estaInscrito = false;
  
  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);
    
    final titulo = widget.rutaDatos["route_name"] ?? "Ruta Sin Nombre";
    final capacidad = widget.rutaDatos["capacidad_maxima"] ?? 0;
    
    final List<dynamic> geoData = widget.rutaDatos["geometria_calle"] ?? [];
    final List<LatLng> lineaDeCalle = geoData.map((punto) {
      return LatLng((punto["lat"] as num).toDouble(), (punto["lng"] as num).toDouble());
    }).toList();

    final List<dynamic> baseData = widget.rutaDatos["puntos_base"] ?? [];
    final List<LatLng> puntosBase = baseData.map((punto) {
      return LatLng((punto["lat"] as num).toDouble(), (punto["lng"] as num).toDouble());
    }).toList();

    // Centro por defecto de la ciudad en caso de no haber trazado
    final LatLng centroDeRespaldo = const LatLng(-38.769, -72.597);

    final double distanciaTotalMetros = (widget.rutaDatos["distancia_metros"] ?? 0).toDouble();
    String textoDistancia = distanciaTotalMetros > 1000
        ? '${(distanciaTotalMetros / 1000).toStringAsFixed(1)} KM'
        : '${distanciaTotalMetros.toInt()} METROS';

    String textoFecha = "25/05/2026 a las 20:00"; 
    if (widget.rutaDatos["starting_date"] != null) {
      try {
        DateTime fecha = DateTime.parse(widget.rutaDatos["starting_date"]);
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle_outlined, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('SUPERVISOR A CARGO: JOHN DOE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Recorrido de monitoreo para la seguridad de la comunidad.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.4),
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  RouteDetailsLabel(
                    icono: Icons.location_on,
                    texto: 'ZONA CENTRO',
                    colorFondo: const Color(0xFFE8F5E9),
                    colorTexto: const Color(0xFF2E7D32),
                  ),
                  RouteDetailsLabel(
                    icono: Icons.access_time,
                    texto: 'HORARIO NOCTURNO',
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
                  onPressed: _estaInscrito ? null : () {
                    setState(() { _estaInscrito = true; });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Te has inscrito con éxito en la ruta!'), backgroundColor: Colors.green));
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
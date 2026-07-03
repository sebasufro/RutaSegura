import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/my_routes_card.dart';
import '../widgets/vol_topbar.dart';
import '/modules/global/services/routes_service.dart';
import '../screens/vol_map_screen.dart';

class VolMyRoutesScreen extends StatefulWidget {
  const VolMyRoutesScreen({super.key});

  @override
  State<VolMyRoutesScreen> createState() => _VolMyRoutesScreenState();
}

class _VolMyRoutesScreenState extends State<VolMyRoutesScreen> {
  final _routesService = RoutesService();
  List<Map<String, dynamic>> _enrollments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarMisRutas();
  }

  Future<void> _cargarMisRutas() async {
    setState(() => _isLoading = true);
    final data = await _routesService.getMyEnrollments();
    if (mounted) {
      setState(() {
        _enrollments = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _desinscribir(String routeId) async {
    final ok = await _routesService.unenroll(routeId);
    if (!mounted) return;
    if (ok) {
      setState(() => _enrollments.removeWhere((e) => e['id_route'] == routeId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te has desinscrito de la ruta correctamente.'), backgroundColor: Colors.redAccent),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al desinscribirse. Intenta de nuevo.')),
      );
    }
  }

  String _determinarHorario(String? startingDatetime) {
    if (startingDatetime == null) return 'SIN HORARIO';
    final hour = DateTime.tryParse(startingDatetime)?.toLocal().hour ?? 12;
    return hour >= 19 || hour < 6 ? 'NOCTURNO' : 'DIURNO';
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const VolTopbar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarMisRutas,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                children: [
                  Text(
                    'MIS RUTAS\nACTIVAS',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.1, color: colorPrincipal),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Trayectos en los que te has inscrito como voluntario.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 25),

                  if (_enrollments.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.directions_run_outlined, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 15),
                          Text('Sin rutas inscritas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
                          const SizedBox(height: 10),
                          Text(
                            'Actualmente no estás participando en ningún trayecto. ¡Ve a la pestaña de exploración y únete a alguna ruta!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.4),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._enrollments.map((enrollment) {
                      final route = enrollment['route'] as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: MyRoutesCard(
                          titulo: route['route_name'] ?? 'Sin nombre',
                          zona: route['transport_type'] ?? 'SIN ZONA',
                          horario: _determinarHorario(route['starting_datetime']),
                          voluntariosActivos: 0,
                          imagenUrl: 'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=400&auto=format&fit=crop',
                          rutaDatos: {
                            'id_route': enrollment['id_route'],
                            'route_name': route['route_name'],
                            'description': route['description'],
                            'transport_type': route['transport_type'],
                            'starting_datetime': route['starting_datetime'],
                            'ending_datetime': route['ending_datetime'],
                            'distance_meters': route['distance_meters'],
                            'street_geometry': route['street_geometry'],
                            'base_points': route['base_points'],
                            'supervisor': route['supervisor'],
                          },
                          startingDatetime: route['starting_datetime'],
                          onDesinscribir: () => _desinscribir(enrollment['id_route']),
                          onUnirse: () {
                            final geo = enrollment['route']['street_geometry'] as List? ??
                                enrollment['route']['base_points'] as List? ?? [];
                            final puntos = geo.map<LatLng>((p) =>
                                LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble())
                            ).toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VolMapScreen(
                                  routeId: enrollment['id_route'],
                                  routePoints: puntos,
                                  routeName: enrollment['route']['route_name'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

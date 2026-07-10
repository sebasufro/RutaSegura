import 'package:flutter/material.dart';
import '../widgets/route_card.dart';
import '../widgets/button_active_route.dart';
import '../../global/services/route_service.dart';

class VolSearchRoutesScreen extends StatefulWidget {
  const VolSearchRoutesScreen({super.key});

  @override
  State<VolSearchRoutesScreen> createState() => _VolSearchRoutesScreenState();
}

class _VolSearchRoutesScreenState extends State<VolSearchRoutesScreen> {
  final _routesService = RoutesService();
  List<Map<String, dynamic>> _rutas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRutas();
  }

  Future<void> _cargarRutas() async {
    setState(() => _isLoading = true);
    final rutas = await _routesService.getAvailableRoutes();
    if (mounted) {
      setState(() {
        _rutas = rutas;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset("assets/images/logo_minimalista.png", height: 28),
            const SizedBox(width: 8),
            Text(
              'RUTA SEGURA',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _cargarRutas,
        color: Theme.of(context).primaryColor,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                children: [
                  Text(
                    'EXPLORAR\nRUTAS',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Selecciona un trayecto monitoreado por nuestra comunidad de guardianes.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 25),

                  if (_rutas.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.map, size: 50, color: Colors.blueGrey),
                          SizedBox(height: 10),
                          Text(
                            'No hay rutas disponibles por el momento.\n¡Desliza hacia abajo para actualizar!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._rutas.map((ruta) {
                      final rutaMapeada = {
                        'route_name': ruta['route_name'],
                        'descripcion': ruta['description'],
                        'distancia_metros': ruta['distance_meters'] != null
                            ? double.tryParse(ruta['distance_meters'].toString()) ?? 0.0
                            : 0.0,
                        'capacidad_maxima': ruta['spots_remaining'],
                        'id_route': ruta['id_route'],
                        'transport_type': ruta['transport_type'],
                        'starting_datetime': ruta['starting_datetime'],
                        'supervisor': ruta['supervisor'],
                        'street_geometry': ruta['street_geometry'],
                        'base_points': ruta['base_points'],
                      };
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: TarjetaRuta(datosRuta: rutaMapeada),
                      );
                    }),

                  const SizedBox(height: 80),
                ],
              ),
      ),
      floatingActionButton: const ButtonActiveRoute(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../screens/vol_map_screen.dart';
import '../../global/services/route_service.dart';

class ButtonActiveRoute extends StatefulWidget {
  const ButtonActiveRoute({super.key});

  @override
  State<ButtonActiveRoute> createState() => _ButtonActiveRouteState();
}

class _ButtonActiveRouteState extends State<ButtonActiveRoute>
    with SingleTickerProviderStateMixin {
  late AnimationController _controlador;
  Map<String, dynamic>? _rutaActiva;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _verificarRutaActiva();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _verificarRutaActiva() async {
    final enrollments = await RoutesService().getMyEnrollments();
    if (!mounted) return;
    final ahora = DateTime.now();
    Map<String, dynamic>? activa;
    for (final e in enrollments) {
      final raw = e['route']?['starting_datetime'] as String?;
      if (raw == null) continue;
      final inicio = DateTime.tryParse(raw)?.toLocal();
      if (inicio == null) continue;
      final diff = inicio.difference(ahora);
      final dentroVentana = diff.inMinutes <= 15 &&
          (diff.isNegative ? ahora.isBefore(inicio.add(const Duration(hours: 4))) : true);
      if (dentroVentana) {
        activa = e;
        break;
      }
    }
    setState(() {
      _rutaActiva = activa;
      _cargando = false;
    });
  }

  void _irARuta() {
    if (_rutaActiva == null) return;
    final route = _rutaActiva!['route'] as Map<String, dynamic>;
    final geo = route['street_geometry'] as List? ?? route['base_points'] as List? ?? [];
    final puntos = geo.map<LatLng>((p) =>
        LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble())).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VolMapScreen(
          routeId: _rutaActiva!['id_route'],
          routePoints: puntos,
          routeName: route['route_name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return const SizedBox.shrink();
    if (_rutaActiva == null) return const SizedBox.shrink();

    return CustomPaint(
      painter: _PintorOnda(_controlador),
      child: FloatingActionButton(
        onPressed: _irARuta,
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.directions_run, color: Colors.white),
      ),
    );
  }
}

class _PintorOnda extends CustomPainter {
  final Animation<double> animacion;

  _PintorOnda(this.animacion) : super(repaint: animacion);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A8A).withValues(alpha: 0.5 * (1 - animacion.value))
      ..style = PaintingStyle.fill;

    final centro = Offset(size.width / 2, size.height / 2);
    final radio = (size.width / 2) + (animacion.value * 25.0);

    canvas.drawCircle(centro, radio, paint);
  }

  @override
  bool shouldRepaint(_PintorOnda oldDelegate) => true;
}

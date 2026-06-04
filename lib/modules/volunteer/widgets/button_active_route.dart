import 'package:flutter/material.dart';
import '../screens/vol_map_screen.dart';

/// Botón flotante animado que indica que hay una ruta actualmente activa.
/// Al pulsarlo, redirige al usuario al mapa en tiempo real de la ruta.
class ButtonActiveRoute extends StatefulWidget {
  const ButtonActiveRoute({super.key});

  @override
  State<ButtonActiveRoute> createState() => _ButtonActiveRouteState();
}

class _ButtonActiveRouteState extends State<ButtonActiveRoute>
    with SingleTickerProviderStateMixin {
  late AnimationController _controlador;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PintorOnda(_controlador),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VolMapScreen()),
          );
        },
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.directions_run, color: Colors.white),
      ),
    );
  }
}

/// CustomPainter privado encargado de dibujar las ondas expansivas
/// detrás del botón principal.
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
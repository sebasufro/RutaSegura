import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../vol_widgets/sos_temporizador.dart';
import '../vol_widgets/sos_tarjeta.dart';

// Pantalla encargada de gestionar el protocolo de emergencia (SOS).
// Muestra un temporizador regresivo que, al finalizar, simula una llamada
// a los servicios de emergencia y alerta sobre la ubicación del usuario.

class ProtocoloSosScreen extends StatefulWidget {
  const ProtocoloSosScreen({super.key});

  @override
  State<ProtocoloSosScreen> createState() => _ProtocoloSosScreenState();
}

class _ProtocoloSosScreenState extends State<ProtocoloSosScreen>
    with SingleTickerProviderStateMixin {
  // Tiempo restante para que la alerta sea enviada automáticamente.
  int _segundosRestantes = 5;

  // Temporizador que controla la cuenta regresiva.
  Timer? _timer;

  // Controlador de la animación del anillo del temporizador.
  late AnimationController _controladorAnimacion;

  // Indica si la alerta ya fue enviada o si el temporizador sigue activo.
  bool _alertaEnviada = false;

  @override
  void initState() {
    super.initState();

    _controladorAnimacion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _iniciarCuentaRegresiva();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controladorAnimacion.dispose();
    super.dispose();
  }

  // Inicia el temporizador de cuenta regresiva y la animación.
  // Si el tiempo llega a cero, detiene el temporizador y ejecuta el protocolo de llamada.
  void _iniciarCuentaRegresiva() {
    _controladorAnimacion.forward(from: 0.0);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 1) {
        setState(() {
          _segundosRestantes--;
        });
        _controladorAnimacion.forward(from: 0.0);
      } else {
        setState(() {
          _segundosRestantes = 0;
          _alertaEnviada = true;
        });
        _timer?.cancel();
        _controladorAnimacion.stop();
        _controladorAnimacion.value = 1.0;

        debugPrint("ALERTA SOS ENVIADA");
        // Simulación de llamada.
        _simularLlamadaCarabineros();
      }
    });
  }

  // Cancela el temporizador, detiene la animación y regresa a la pantalla anterior.
  void _cancelarAlerta() {
    _timer?.cancel();
    _controladorAnimacion.stop();
    Navigator.pop(context);
  }

  // Muestra un cuadro de diálogo informando la conexión con los servicios
  // de emergencia e invoca el canal de métodos nativo para realizar la llamada.
  Future<void> _simularLlamadaCarabineros() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(
          0xFF1E1E1E,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.phone_in_talk,
              color: Color(0xFF10B981),
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Llamando al 133',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Conectando con Carabineros de Chile...\n\nTu ubicación ya ha sido transmitida al supervisor encargado.',
          style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'FINALIZAR LLAMADA',
              style: TextStyle(
                color: Color(0xFFEF5350),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    const channel = MethodChannel('com.tuapp/llamada');
    try {
      //Definir número a marcar.
      await channel.invokeMethod('hacerLlamada', {'numero': '133'});
    } on PlatformException catch (e) {
      debugPrint('Error al llamar: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5E1717), Color(0xFF2A0808)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ESTADO DE EMERGENCIA',
                    style: TextStyle(
                      color: Color(0xFFEF5350),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Text(
                  _alertaEnviada ? '¡Alerta Enviada!' : 'Solicitando Ayuda',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(flex: 2),

                SizedBox(
                  width: 230,
                  height: 230,
                  child: AnimatedBuilder(
                    animation: _controladorAnimacion,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: SosTemporizador(
                          progreso: _alertaEnviada
                              ? 1.0
                              : _controladorAnimacion.value,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_segundosRestantes',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 90,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0,
                                ),
                              ),
                              const Text(
                                'SEGUNDOS',
                                style: TextStyle(
                                  color: Color(0xFFEF5350),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(flex: 3),

                const SosTarjeta(),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _alertaEnviada
                        ? () => Navigator.pop(context)
                        : _cancelarAlerta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _alertaEnviada ? Icons.check : Icons.close,
                          color: const Color(0xFF8B0000),
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _alertaEnviada ? 'ENTENDIDO' : 'CANCELAR ALERTA',
                          style: const TextStyle(
                            color: Color(0xFF8B0000),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      _alertaEnviada
                          ? 'EL PROTOCOLO SE HA ACTIVADO\nEXITOSAMENTE.'
                          : 'PULSA UNA VEZ\nPARA DETENER EL PROTOCOLO DE\nEMERGENCIA.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF8C4A4A),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
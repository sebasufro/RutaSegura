import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Pantalla encargada de gestionar el protocolo de emergencia (SOS).
// Muestra un temporizador regresivo que, al finalizar, simula una llamada
// a los servicios de emergencia y alerta sobre la ubicación del usuario.

class ProtocoloSosScreen extends StatefulWidget {
  const ProtocoloSosScreen({super.key});

  @override
  State<ProtocoloSosScreen> createState() => _ProtocoloSosScreenState();
}

class _ProtocoloSosScreenState extends State<ProtocoloSosScreen> {
  // Tiempo restante para que la alerta sea enviada automáticamente.
  int _segundosRestantes = 5;

  // Temporizador que controla la cuenta regresiva.
  Timer? _timer;

  // Indica si la alerta ya fue enviada o si el temporizador sigue activo.
  bool _alertaEnviada = false;

  @override
  void initState() {
    super.initState();
    _iniciarCuentaRegresiva();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Inicia el temporizador de cuenta regresiva.
  // Si el tiempo llega a cero, detiene el temporizador y ejecuta el protocolo de llamada.
  void _iniciarCuentaRegresiva() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 1) {
        setState(() {
          _segundosRestantes--;
        });
      } else {
        setState(() {
          _segundosRestantes = 0;
          _alertaEnviada = true;
        });
        _timer?.cancel();

        debugPrint("ALERTA SOS ENVIADA");
        // Simulación de llamada.
        _simularLlamadaCarabineros();
      }
    });
  }

  // Cancela el temporizador y regresa a la pantalla anterior.
  void _cancelarAlerta() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  // Muestra un cuadro de diálogo informando la conexión con los servicios
  // de emergencia e invoca el canal de métodos nativo para realizar la llamada.
  Future<void> _simularLlamadaCarabineros() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Llamando al 133'),
        content: const Text(
          'Conectando con Carabineros de Chile...\n\nTu ubicación exacta ya ha sido transmitida a la central de monitoreo.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('FINALIZAR LLAMADA'),
          ),
        ],
      ),
    );

    const channel = MethodChannel('com.tuapp/llamada');
    try {
      await channel.invokeMethod('hacerLlamada', {'numero': '133'});
    } on PlatformException catch (e) {
      debugPrint('Error al llamar: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba SOS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _alertaEnviada ? '¡Alerta Enviada!' : 'Solicitando Ayuda en:',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              '$_segundosRestantes',
              style: const TextStyle(
                fontSize: 80, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _alertaEnviada 
                  ? () => Navigator.pop(context) 
                  : _cancelarAlerta,
              child: Text(_alertaEnviada ? 'ENTENDIDO' : 'CANCELAR ALERTA'),
            ),
          ],
        ),
      ),
    );
  }
}
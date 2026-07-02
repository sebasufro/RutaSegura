import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_bottom_panel.dart';
import '../widgets/sos_button.dart';
import '../widgets/vol_topbar.dart';

// Pantalla principal del voluntario durante una ruta activa.
// Muestra un mapa con la ubicación en tiempo real del usuario
// y la de sus compañeros de equipo.

class VolMapScreen extends StatefulWidget {
  const VolMapScreen({super.key});

  @override
  State<VolMapScreen> createState() => _VolMapScreenState();
}

class _VolMapScreenState extends State<VolMapScreen> {
  // Canal de comunicación nativa para obtener la ubicación del dispositivo.
  static const _channel = MethodChannel('com.tuapp/ubicacion');
  
  // Controlador del mapa para gestionar el zoom y la posición de la cámara.
  final MapController _mapController = MapController();
  
  // Indica si se está esperando la respuesta de hardware del GPS.
  bool _cargandoUbicacion = false;
  
  // Almacena la última ubicación conocida del usuario.
  LatLng? _miUbicacion;

  // Lista simulada para pruebas con compañeros asignados a la misma ruta.
  // TODO: Reemplazar con llamada real a la API.
  final List<Map<String, dynamic>> _companerosFalsos = [
    {
      "id_user": 8,
      "nombre": "MJ",
      "latitude": -38.7710,
      "longitude": -72.5990,
      "sos_status": false,
    },
    {
      "id_user": 12,
      "nombre": "SK",
      "latitude": -38.7680,
      "longitude": -72.5950,
      "sos_status": false,
    },
    {
      "id_user": 15,
      "nombre": "RP",
      "latitude": -38.7720,
      "longitude": -72.6010,
      "sos_status": true,
    },
  ];

  // Solicitud de ubicación actual del dispositivo por el canal nativo.
  // En caso de éxito, centra la cámara del mapa en las coordenadas obtenidas.
  Future<void> _irAMiUbicacion() async {
    setState(() => _cargandoUbicacion = true);
    try {
      final resultado = await _channel.invokeMapMethod<String, dynamic>(
        'obtenerUbicacion',
      );
      if (resultado != null) {
        final lat = resultado['lat'] as double;
        final lng = resultado['lng'] as double;

        if (lat.isNaN || lng.isNaN || lat == 0.0 && lng == 0.0) {
          debugPrint('Ubicación inválida recibida');
          return;
        }

        setState(() => _miUbicacion = LatLng(lat, lng));
        _mapController.move(LatLng(lat, lng), 16.0);
        _mapController.rotate(0.0);
      }
    } on PlatformException catch (e) {
      debugPrint('Error ubicación: ${e.message}');
      if (mounted) {
        final mensaje = e.code == 'PERMISO_DENEGADO'
            ? 'Permiso de ubicación denegado.'
            : 'GPS activo pero sin señal. Intenta en exterior.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
      }
    } finally {
      setState(() => _cargandoUbicacion = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);
    final double espacioInferiorSeguro = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: const VolTopbar(),
      body: Stack(
        children: [
          // Capa base del mapa interactivo
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(-38.769, -72.597),
              initialZoom: 14.0,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ruta_segura',
              ),

              // Capa de marcadores de compañeros simulados
              MarkerLayer(
                markers: _companerosFalsos.map((c) {
                  final tieneSos = c['sos_status'] as bool;
                  return Marker(
                    point: LatLng(
                      c['latitude'] as double,
                      c['longitude'] as double,
                    ),
                    width: 44,
                    height: 44,
                    rotate: true,
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: tieneSos
                                ? const Color(0xFFEF5350)
                                : const Color(0xFF4F46E5),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: (tieneSos ? Colors.red : Colors.indigo)
                                    .withValues(alpha: 0.4),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              c['nombre'].toString().substring(0, 2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Capa de marcador de la ubicación actual del usuario
              if (_miUbicacion != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _miUbicacion!,
                      width: 20,
                      height: 20,
                      rotate: true,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1A73E8),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF1A73E8,
                              ).withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Botón flotante para centrar la cámara en la ubicación actual
          Positioned(
            bottom: 305 + espacioInferiorSeguro,
            right: 20,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorPrincipal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _irAMiUbicacion,
                  child: _cargandoUbicacion
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 26,
                        ),
                ),
              ),
            ),
          ),

          // Botón flotante para activar el protocolo de emergencia (SOS)
          Positioned(
            bottom: 220 + espacioInferiorSeguro,
            right: 20,
            child: const SosButton(),
          ),

          // Panel inferior de información y búsqueda de compañeros
          Positioned(
            bottom: 20 + espacioInferiorSeguro,
            left: 20,
            right: 20,
            child: MapBottomPanel(
              cantidadCompaneros: _companerosFalsos.length,
            ),
          ),
        ],
      ),
    );
  }
}
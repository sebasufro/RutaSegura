import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Widget encargado de mostrar el mapa estático con el trazado
/// de la ruta y los marcadores de inicio y fin de la actividad.
class RouteDetailsMap extends StatefulWidget {
  final List<LatLng> lineaDeCalle;
  final List<LatLng> puntosBase;
  final LatLng centroDeRespaldo;
  final Color colorPrincipal;

  const RouteDetailsMap({
    super.key,
    required this.lineaDeCalle,
    required this.puntosBase,
    required this.centroDeRespaldo,
    required this.colorPrincipal,
  });

  @override
  State<RouteDetailsMap> createState() => _RouteDetailsMapState();
}

class _RouteDetailsMapState extends State<RouteDetailsMap> {
  final MapController _controladorMapa = MapController();

  @override
  Widget build(BuildContext context) {
    if (widget.lineaDeCalle.isEmpty) {
      return Container(
        width: double.infinity,
        height: 300,
        color: Colors.grey[200],
        child: const Center(
          child: Text(
            'No hay trazado disponible para esta ruta',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final limitesRuta = LatLngBounds.fromPoints(widget.lineaDeCalle);
    final esPuntoUnico = limitesRuta.southWest == limitesRuta.northEast;

    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.grey[200],
      child: Stack(
        children: [
          FlutterMap(
            mapController: _controladorMapa,
            options: MapOptions(
              initialCameraFit: esPuntoUnico
                  ? null
                  : CameraFit.bounds(
                      bounds: limitesRuta,
                      padding: const EdgeInsets.all(40.0),
                      maxZoom: 18.0,
                    ),
              initialCenter: widget.lineaDeCalle.first,
              initialZoom: 14.0,
              minZoom: 3.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ruta_segura',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.lineaDeCalle,
                    color: Colors.blueAccent,
                    strokeWidth: 5.0,
                  ),
                ],
              ),
              MarkerLayer(markers: _construirMarcadores(widget.puntosBase)),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              mini: true,
              heroTag: 'btn_centrar_ruta',
              backgroundColor: Colors.white,
              onPressed: () {
                if (!esPuntoUnico) {
                  _controladorMapa.fitCamera(
                    CameraFit.bounds(
                      bounds: limitesRuta,
                      padding: const EdgeInsets.all(40.0),
                      maxZoom: 18.0,
                    ),
                  );
                } else {
                  _controladorMapa.move(widget.lineaDeCalle.first, 14.0);
                }
              },
              child: Icon(Icons.my_location, color: widget.colorPrincipal),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _construirMarcadores(List<LatLng> puntos) {
    if (puntos.isEmpty) return [];
    List<Marker> marcadores = [];
    marcadores.add(Marker(point: puntos.first, width: 50, height: 50, child: _buildPinColor(const Color(0xFF4CAF50))));
    if (puntos.length > 1) {
      marcadores.add(Marker(point: puntos.last, width: 50, height: 50, child: _buildPinColor(const Color(0xFFE53935))));
    }
    return marcadores;
  }

  Widget _buildPinColor(Color colorPrincipal) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 46),
        Positioned(top: 3, child: Icon(Icons.location_on, color: colorPrincipal, size: 38)),
        Positioned(top: 12, child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
      ],
    );
  }
}
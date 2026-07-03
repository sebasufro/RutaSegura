import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class InteractiveMapWidget extends StatefulWidget {
  final Function(List<LatLng>) onRouteSaved;
  final List<LatLng>? initialPoints;

  const InteractiveMapWidget({
    Key? key,
    required this.onRouteSaved,
    this.initialPoints,
  }) : super(key: key);

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  final List<LatLng> _puntosDeRuta = [];
  List<LatLng> _lineaDeCalle = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPoints != null) {
      _puntosDeRuta.addAll(widget.initialPoints!);
      if (_puntosDeRuta.length >= 2) {
        _calcularRuta();
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  void _notifyParent() {
    widget.onRouteSaved(List.unmodifiable(_puntosDeRuta));
  }

  Future<void> _calcularRuta() async {
    if (_puntosDeRuta.length < 2) {
      setState(() => _lineaDeCalle.clear());
      return;
    }
    setState(() => _cargando = true);

    List<List<double>> coordenadasORS =
        _puntosDeRuta.map((p) => [p.longitude, p.latitude]).toList();
    final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/foot-walking/geojson');

    try {
      final respuesta = await http.post(
        url,
        headers: {
          'Accept':
              'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
          'Authorization':
              'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDAxY2Y2MjQ4IiwiaWQiOiJkNmNhYjlhNTMzMWU0NDM1ODIwMzc2NzExMTY2OWRkNiIsImgiOiJtdXJtdXI2NCJ9',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({"coordinates": coordenadasORS}),
      );

      if (respuesta.statusCode == 200) {
        final data = jsonDecode(respuesta.body);
        if (data['features'] != null && data['features'].isNotEmpty) {
          final geometria = data['features'][0]['geometry']['coordinates'] as List;
          setState(() {
            _lineaDeCalle = geometria
                .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
                .where((point) => point.latitude.isFinite && point.longitude.isFinite)
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _cargando = false);
    }
  }

  Future<void> _deshacerUltimoPunto() async {
    if (_puntosDeRuta.isEmpty) return;
    setState(() {
      _puntosDeRuta.removeLast();
      if (_puntosDeRuta.length < 2) _lineaDeCalle.clear();
    });
    _notifyParent();
    if (_puntosDeRuta.length >= 2) await _calcularRuta();
  }

  void _borrarTodosPuntos() {
    setState(() {
      _puntosDeRuta.clear();
      _lineaDeCalle.clear();
    });
    _notifyParent();
  }

  List<Marker> _construirMarcadores() {
    return _puntosDeRuta.asMap().entries.map((entry) {
      int i = entry.key;
      Color colorPin = (i == 0)
          ? Colors.green
          : (i == _puntosDeRuta.length - 1 && _puntosDeRuta.length > 1)
              ? Colors.red
              : Colors.orange;
      double tamano = (i == 0 || i == _puntosDeRuta.length - 1) ? 40.0 : 25.0;
      IconData icono = (i == 0 || i == _puntosDeRuta.length - 1)
          ? Icons.location_on
          : Icons.circle;

      return Marker(
        point: entry.value,
        width: tamano,
        height: tamano,
        child: Icon(icono, color: colorPin, size: tamano),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map
        FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(-38.769, -72.597),
            initialZoom: 14.0,
            maxZoom: 18.0,
            minZoom: 3.0,
            onTap: (tapPosition, point) async {
              if (!point.latitude.isFinite || !point.longitude.isFinite) return;
              setState(() => _puntosDeRuta.add(point));
              _notifyParent();
              await _calcularRuta();
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.ruta_segura',
            ),
            PolylineLayer(
              polylines: [
                // Direct line between tapped points (always visible)
                if (_puntosDeRuta.length >= 2)
                  Polyline(
                    points: _puntosDeRuta,
                    color: Colors.blueAccent.withOpacity(0.3),
                    strokeWidth: 3.0,
                  ),
                // Street-following route from OpenRouteService
                if (_lineaDeCalle.isNotEmpty)
                  Polyline(
                    points: _lineaDeCalle,
                    color: Colors.blueAccent,
                    strokeWidth: 5.0,
                  ),
              ],
            ),
            MarkerLayer(markers: _construirMarcadores()),
          ],
        ),

        // Loading Indicator
        if (_cargando)
          const Center(
            child: CircularProgressIndicator(),
          ),

        // Undo and Erase Buttons (Top Left)
        Positioned(
          top: 12,
          left: 12,
          child: Column(
            spacing: 8,
            children: [
              // Undo Button
              GestureDetector(
                onTap: _puntosDeRuta.isNotEmpty ? _deshacerUltimoPunto : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _puntosDeRuta.isNotEmpty
                        ? Colors.white
                        : Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.undo,
                      color: _puntosDeRuta.isNotEmpty
                          ? Colors.black87
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Erase Button
              GestureDetector(
                onTap: _puntosDeRuta.isNotEmpty ? _borrarTodosPuntos : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _puntosDeRuta.isNotEmpty
                        ? Colors.white
                        : Colors.grey[300],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: _puntosDeRuta.isNotEmpty
                          ? Colors.black87
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Point counter (Top Right)
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${_puntosDeRuta.length} puntos',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

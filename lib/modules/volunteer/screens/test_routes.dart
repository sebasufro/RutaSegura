import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

// Clase que actúa como base de datos local en memoria. (SOLO PARA FINES DE TESTING)
// Permite almacenar y recuperar las rutas creadas durante las pruebas
// sin necesidad de tener el backend conectado todavía.

class MiniBaseDeDatos {
  static final List<Map<String, dynamic>> tablaRutas = [];

  // Almacena una nueva ruta en la lista temporal en memoria.
  static void guardarRuta(Map<String, dynamic> nuevaRuta) {
    tablaRutas.add(nuevaRuta);
    debugPrint("DB Simulada: Ruta guardada. Total: ${tablaRutas.length}");
  }

  // Devuelve todas las rutas almacenadas en la sesión actual.
  static List<Map<String, dynamic>> obtenerTodasLasRutas() {
    return tablaRutas;
  }
}

// Pantalla de pruebas para simular la creación de rutas por parte de un supervisor.
// Permite tocar el mapa para generar puntos de control, y consulta una API externa
// (OpenRouteService) para trazar la ruta caminable entre ellos.

class TestRoutes extends StatefulWidget {
  const TestRoutes({super.key});

  @override
  State<TestRoutes> createState() => _TestRoutesState();
}

class _TestRoutesState extends State<TestRoutes> {
  // Lista de puntos base (coordenadas) tocados por el usuario en el mapa.
  final List<LatLng> _puntosDeRuta = [];
  
  // Trazado de la ruta (geometría) devuelta por la API de OpenRouteService.
  List<LatLng> _lineaDeCalle = []; 
  
  // Indica si se está realizando la consulta HTTP a la API de rutas.
  bool _cargando = false;

  // Consulta la API de OpenRouteService enviando los puntos seleccionados
  // para obtener el trazado exacto de las calles y senderos entre dichos puntos.
  Future<void> _calcularRuta() async {
    if (_puntosDeRuta.length < 2) return;
    setState(() => _cargando = true);

    List<List<double>> coordenadasORS = _puntosDeRuta.map((p) => [p.longitude, p.latitude]).toList();
    final url = Uri.parse('https://api.openrouteservice.org/v2/directions/foot-walking/geojson');

    try {
      final respuesta = await http.post(
        url,
        headers: {
          'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
          
          //Codigo de API de OSR
          'Authorization': 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjE4YmUxNTIwODNiOTQwYjRiZGE4ODFjMGJhMGY5NjgwIiwiaCI6Im11cm11cjY0In0=', 
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

  // Elimina el último punto seleccionado en el mapa.
  // Si aún quedan 2 o más puntos, recalcula la ruta automáticamente.
  Future<void> _deshacerUltimoPunto() async {
    if (_puntosDeRuta.isEmpty) return; 
    setState(() {
      _puntosDeRuta.removeLast(); 
      if (_puntosDeRuta.length < 2) _lineaDeCalle.clear();
    });
    if (_puntosDeRuta.length >= 2) await _calcularRuta();
  }

  // Calcula la distancia total del trazado actual y empaqueta todos los datos
  // en un formato JSON (Map) para guardarlos en la base de datos simulada.
  void _empaquetarRuta() {
    if (_lineaDeCalle.isEmpty) return;

    final Distance calculadorDistancia = const Distance();
    double distanciaTotalMetros = 0;

    for (int i = 0; i < _lineaDeCalle.length - 1; i++) {
      distanciaTotalMetros += calculadorDistancia.as(
        LengthUnit.Meter,
        _lineaDeCalle[i],
        _lineaDeCalle[i + 1],
      );
    }

    final datosDeLaRuta = {
      "id": DateTime.now().millisecondsSinceEpoch, 
      "route_name": "Ruta Social Centro ${MiniBaseDeDatos.tablaRutas.length + 1}",
      "starting_date": DateTime.now().add(const Duration(days: 1)).toIso8601String(), 
      "capacidad_maxima": 10,
      "distancia_metros": distanciaTotalMetros,
      "puntos_base": _puntosDeRuta.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList(),
      "geometria_calle": _lineaDeCalle.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList(),
    };

    MiniBaseDeDatos.guardarRuta(datosDeLaRuta);

    setState(() {
      _puntosDeRuta.clear();
      _lineaDeCalle.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Ruta guardada!'), backgroundColor: Colors.green),
    );
  }

  // Construye los marcadores visuales para el mapa interactivo.
  // El primer punto es verde (inicio), el último es rojo (fin) 
  // y los intermedios son de color naranja.
  List<Marker> _construirMarcadores() {
    return _puntosDeRuta.asMap().entries.map((entry) {
      int i = entry.key;
      Color colorPin = (i == 0) ? Colors.green : (i == _puntosDeRuta.length - 1 && _puntosDeRuta.length > 1) ? Colors.red : Colors.orange;
      double tamano = (i == 0 || i == _puntosDeRuta.length - 1) ? 40.0 : 25.0;
      IconData icono = (i == 0 || i == _puntosDeRuta.length - 1) ? Icons.location_on : Icons.circle;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Supervisor: Crear'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _puntosDeRuta.isNotEmpty ? _deshacerUltimoPunto : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() { _puntosDeRuta.clear(); _lineaDeCalle.clear(); }),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-38.769, -72.597),
              initialZoom: 14.0,
              maxZoom: 18.0, minZoom: 3.0,
              onTap: (tapPosition, point) async {
                if (!point.latitude.isFinite || !point.longitude.isFinite) return;
                setState(() => _puntosDeRuta.add(point));
                await _calcularRuta(); 
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.test_mapas',
              ),
              PolylineLayer(
                polylines: [
                  if (_lineaDeCalle.isNotEmpty) 
                    Polyline(points: _lineaDeCalle, color: Colors.blueAccent, strokeWidth: 5.0),
                ],
              ),
              MarkerLayer(markers: _construirMarcadores()),
            ],
          ),
          if (_cargando) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _lineaDeCalle.isNotEmpty ? _empaquetarRuta : null,
        backgroundColor: _lineaDeCalle.isNotEmpty ? Colors.green : Colors.grey,
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text("Guardar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
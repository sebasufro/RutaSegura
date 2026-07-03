import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/map_bottom_panel.dart';
import '../widgets/sos_button.dart';
import '../widgets/vol_topbar.dart';
import '/modules/global/services/location_service.dart';
import '/modules/global/services/auth_service.dart';

class VolMapScreen extends StatefulWidget {
  final String? routeId;
  final List<LatLng> routePoints;
  final String? routeName;

  const VolMapScreen({super.key, this.routeId, this.routePoints = const [], this.routeName});

  @override
  State<VolMapScreen> createState() => _VolMapScreenState();
}

class _VolMapScreenState extends State<VolMapScreen> {
  final MapController _mapController = MapController();
  final _locationService = LocationService();

  LatLng? _miUbicacion;
  bool _cargandoUbicacion = false;
  List<Map<String, dynamic>> _companeros = [];
  Timer? _pollingTimer;
  String? _miId;

  @override
  void initState() {
    super.initState();
    AuthService.getUserId().then((id) => _miId = id);
    _irAMiUbicacion();
    if (widget.routeId != null) {
      _iniciarPolling();
    }
    if (widget.routePoints.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(widget.routePoints.first, 15.0);
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _iniciarPolling() {
    _cargarCompaneros();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _cargarCompaneros();
      if (_miUbicacion != null) {
        _locationService.sendLocation(
          widget.routeId!,
          _miUbicacion!.latitude,
          _miUbicacion!.longitude,
        );
      }
    });
  }

  Future<void> _cargarCompaneros() async {
    if (widget.routeId == null) return;
    final locs = await _locationService.getRouteLocations(widget.routeId!);
    if (mounted) setState(() => _companeros = locs);
  }

  void _verRuta() {
    if (widget.routePoints.length < 2) return;
    final lats = widget.routePoints.map((p) => p.latitude);
    final lngs = widget.routePoints.map((p) => p.longitude);
    final bounds = LatLngBounds(
      LatLng(lats.reduce((a, b) => a < b ? a : b), lngs.reduce((a, b) => a < b ? a : b)),
      LatLng(lats.reduce((a, b) => a > b ? a : b), lngs.reduce((a, b) => a > b ? a : b)),
    );
    _mapController.fitCamera(CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(40)));
  }

  Future<void> _irAMiUbicacion() async {
    setState(() => _cargandoUbicacion = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de ubicación denegado.')),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final latLng = LatLng(position.latitude, position.longitude);
      setState(() => _miUbicacion = latLng);
      _mapController.move(latLng, 16.0);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener la ubicación.')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargandoUbicacion = false);
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

              // Trazado de la ruta
              if (widget.routePoints.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: widget.routePoints,
                      strokeWidth: 5.0,
                      color: const Color(0xFF29B6F6),
                    ),
                  ],
                ),

              // Puntos de inicio y fin de la ruta
              if (widget.routePoints.isNotEmpty)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.routePoints.first,
                      width: 32,
                      height: 32,
                      child: const Icon(Icons.trip_origin, color: Color(0xFF10B981), size: 28),
                    ),
                    if (widget.routePoints.length > 1)
                      Marker(
                        point: widget.routePoints.last,
                        width: 32,
                        height: 32,
                        child: const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 30),
                      ),
                  ],
                ),

              // Marcadores de compañeros
              if (_companeros.isNotEmpty)
                MarkerLayer(
                  markers: _companeros.where((c) => c['id_user'] != _miId).map((c) {
                    final tieneSos = c['sos_active'] == true;
                    final nombre = (c['full_name'] ?? '??').toString();
                    final initials = nombre.length >= 2
                        ? nombre.substring(0, 2).toUpperCase()
                        : nombre.toUpperCase();
                    return Marker(
                      point: LatLng(
                        (c['latitude'] as num).toDouble(),
                        (c['longitude'] as num).toDouble(),
                      ),
                      width: 44,
                      height: 44,
                      rotate: true,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: tieneSos ? const Color(0xFFEF5350) : const Color(0xFF4F46E5),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: (tieneSos ? Colors.red : Colors.indigo).withValues(alpha: 0.4),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              // Marcador de mi ubicación
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
                              color: const Color(0xFF1A73E8).withValues(alpha: 0.4),
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

          // Botón ver ruta completa
          if (widget.routePoints.length >= 2)
            Positioned(
              bottom: 220 + espacioInferiorSeguro,
              left: 20,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF29B6F6),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: _verRuta,
                    child: const Icon(Icons.route, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),

          // Botón centrar ubicación
          Positioned(
            bottom: 305 + espacioInferiorSeguro,
            right: 20,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorPrincipal,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _irAMiUbicacion,
                  child: _cargandoUbicacion
                      ? const Padding(padding: EdgeInsets.all(14), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.my_location, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),

          // Botón SOS
          Positioned(
            bottom: 220 + espacioInferiorSeguro,
            right: 20,
            child: const SosButton(),
          ),

          // Panel inferior
          Positioned(
            bottom: 20 + espacioInferiorSeguro,
            left: 20,
            right: 20,
            child: MapBottomPanel(companeros: _companeros, routeName: widget.routeName, miId: _miId),
          ),
        ],
      ),
    );
  }
}

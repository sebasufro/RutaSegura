import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/volunteer_marker_widget.dart';
import '/modules/supervisor/widgets/map_info_card.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late MapController _mapController;
  LatLng? _userLocation;
  bool _loading = true;

  // Fake volunteer locations (hardcoded around Valdivia, Chile)
  static const List<Map<String, dynamic>> _volunteers = [
    {
      'id': '1',
      'name': 'Voluntario 1',
      'initials': 'MJ',
      'color': VolunteerColor.orange,
      'location': LatLng(-38.7580, -72.5850),
      'lastUpdate': '20s',
      'battery': 92,
    },
    {
      'id': '2',
      'name': 'Voluntario 2',
      'initials': 'SK',
      'color': VolunteerColor.indigo,
      'location': LatLng(-38.7650, -72.5900),
      'lastUpdate': '35s',
      'battery': 65,
    },
    {
      'id': '3',
      'name': 'Voluntario 3',
      'initials': 'RL',
      'color': VolunteerColor.green,
      'location': LatLng(-38.7720, -72.5950),
      'lastUpdate': '15s',
      'battery': 28,
    },
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        setState(() {
          _userLocation = const LatLng(-38.769, -72.597);
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, habilita los servicios de ubicación'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          setState(() {
            _userLocation = const LatLng(-38.769, -72.597);
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes habilitar los permisos de ubicación en los ajustes'),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          _userLocation = const LatLng(-38.769, -72.597);
          _loading = false;
        });
        return;
      }

      // Get the current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('Location obtained: ${position.latitude}, ${position.longitude}');

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
      });

      // Move map to user location after widget is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          14.0,
        );
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Use default location
      setState(() {
        _userLocation = const LatLng(-38.769, -72.597);
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error obteniendo ubicación: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showVolunteerInfo(Map<String, dynamic> volunteer) {
    showDialog(
      context: context,
      builder: (context) => VolunteerInfoDialog(volunteer: volunteer),
    );
  }

  void _recenterMap() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 14.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFF8FAFC),
          child: Stack(
            children: [
              // Main Content
              Column(
                children: [
                  // Topbar
                  const SupTopbar(),

                  // Map Content
                  Expanded(
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _userLocation != null
                              ? Stack(
                                  children: [
                                    // Flutter Map
                                    FlutterMap(
                                      mapController: _mapController,
                                      options: MapOptions(
                                        initialCenter: _userLocation!,
                                        initialZoom: 14.0,
                                        maxZoom: 18.0,
                                        minZoom: 3.0,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          userAgentPackageName:
                                              'com.example.ruta_segura',
                                        ),
                                        // User location marker
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: _userLocation!,
                                              width: 60,
                                              height: 60,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Outer light blue ring (Google Maps style)
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(
                                                                0xFF4285F4)
                                                            .withOpacity(0.15),
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: const Color(
                                                                0xFF4285F4),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .white,
                                                              width: 3,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: const Color(
                                                                        0xFF4285F4)
                                                                    .withOpacity(
                                                                        0.5),
                                                                blurRadius: 8,
                                                                spreadRadius: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Volunteer markers
                                            ..._volunteers.map((volunteer) {
                                              return Marker(
                                                point: volunteer['location'],
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      _showVolunteerInfo(
                                                          volunteer),
                                                  child: VolunteerMarkerWidget(
                                                    initials: volunteer[
                                                        'initials'],
                                                    color: volunteer['color'],
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),

                                    // Info Card
                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                      child: MapInfoCard(
                                        nearbyVolunteers:
                                            _volunteers.take(2).toList(),
                                        onVolunteerTap: _showVolunteerInfo,
                                      ),
                                    ),

                                    // Recenter button (Google Maps style)
                                    Positioned(
                                      bottom: 190,
                                      right: 20,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _recenterMap,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.my_location,
                                                color: const Color(0xFF4285F4),
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text('Error loading location'),
                                ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    @override
    void dispose() {
      _mapController.dispose();
      super.dispose();
    }
}

// Volunteer Info Dialog
class VolunteerInfoDialog extends StatelessWidget {
  final Map<String, dynamic> volunteer;

  const VolunteerInfoDialog({
    super.key,
    required this.volunteer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 306,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            // Header
            Row(
              spacing: 12,
              children: [
                VolunteerMarkerWidget(
                  initials: volunteer['initials'],
                  color: volunteer['color'],
                  size: 56,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        volunteer['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF002045),
                        ),
                      ),
                      Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Details
            Column(
              spacing: 12,
              children: [
                _DetailItem(
                  icon: Icons.schedule,
                  label: 'Última actualización',
                  value: volunteer['lastUpdate'],
                ),
                _DetailItem(
                  icon: Icons.battery_full,
                  label: 'Batería',
                  value: '${volunteer['battery']}%',
                ),
              ],
            ),

            // Action Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF002045),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Ver Voluntarios Activos',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE7ECFB),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE7ECFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              icon,
              color: const Color(0xFF002045),
              size: 20,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF002045),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '/modules/supervisor/screens/list_volunteers_screen.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/volunteer_marker_widget.dart';
import '/modules/supervisor/widgets/map_info_card.dart';
import '/modules/supervisor/services/enrolled_volunteers_service.dart';

class MapViewScreen extends StatefulWidget {
  final List<LatLng>? routePoints;
  final String routeId;
  final String routeTitle;

  const MapViewScreen({
    super.key,
    this.routePoints,
    required this.routeId,
    required this.routeTitle,
  });

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late MapController _mapController;
  LatLng? _userLocation;
  bool _loading = true;
  List<Map<String, dynamic>> _volunteers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
    _fetchVolunteers();
  }

  Future<void> _fetchVolunteers() async {
    try {
      final data =
          await EnrolledVolunteersService.findAll(widget.routeId);
      if (mounted) {
        setState(() => _volunteers = data);
      }
    } catch (e) {
      debugPrint('Error fetching enrolled volunteers: $e');
    }
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  Future<void> _getUserLocation() async {
    try {
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

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('Location obtained: ${position.latitude}, ${position.longitude}');

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(position.latitude, position.longitude),
          14.0,
        );
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
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

  Future<void> _showVolunteerInfo(Map<String, dynamic> enrollment) async {
    final volunteerId = enrollment['id_volunteer'] as String;
    try {
      final detail =
          await EnrolledVolunteersService.findOne(widget.routeId, volunteerId);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => VolunteerInfoDialog(
            detail: detail,
            routeId: widget.routeId,
            routeTitle: widget.routeTitle,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar detalles: $e')),
        );
      }
    }
  }

  void _recenterMap() {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 14.0);
    }
  }

  List<Map<String, dynamic>> _buildNearbyVolunteers() {
    final colors = [
      VolunteerColor.orange,
      VolunteerColor.indigo,
      VolunteerColor.green,
    ];
    return _volunteers.take(2).toList().asMap().entries.map((entry) {
      final index = entry.key;
      final v = entry.value;
      final users = v['users'] as Map<String, dynamic>? ?? {};
      final fullName = users['full_name'] as String? ?? '?';
      return {
        'initials': _getInitials(fullName),
        'color': colors[index % colors.length],
        'id_volunteer': v['id_volunteer'],
      };
    }).toList();
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
              Column(
                children: [
                  const SupTopbar(),
                  Expanded(
                      child: _loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : _userLocation != null
                              ? Stack(
                                  children: [
                                    FlutterMap(
                                      mapController: _mapController,
                                      options: MapOptions(
                                        initialCenter: widget.routePoints?.isNotEmpty == true
                                            ? widget.routePoints!.first
                                            : _userLocation!,
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
                                        if (widget.routePoints != null && widget.routePoints!.length >= 2)
                                          PolylineLayer(
                                            polylines: [
                                              Polyline(
                                                points: widget.routePoints!,
                                                color: Colors.blueAccent,
                                                strokeWidth: 5.0,
                                              ),
                                            ],
                                          ),
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
                                          ],
                                        ),
                                      ],
                                    ),

                                    Positioned(
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                      child: MapInfoCard(
                                        nearbyVolunteers:
                                            _buildNearbyVolunteers(),
                                        onVolunteerTap: _showVolunteerInfo,
                                      ),
                                    ),

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

class VolunteerInfoDialog extends StatelessWidget {
  final Map<String, dynamic> detail;
  final String routeId;
  final String routeTitle;

  const VolunteerInfoDialog({
    super.key,
    required this.detail,
    required this.routeId,
    required this.routeTitle,
  });

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  Color _getColor(String name) {
    const colors = [
      Color(0xFFF59E0B),
      Color(0xFF6366F1),
      Color(0xFF10B981),
      Color(0xFFEF4444),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFF14B8A6),
      Color(0xFFF97316),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) {
        return 'hace ${diff.inMinutes} min';
      } else if (diff.inHours < 24) {
        return 'hace ${diff.inHours} h';
      } else {
        return 'hace ${diff.inDays} d';
      }
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = detail['users'] as Map<String, dynamic>? ?? {};
    final fullName = users['full_name'] as String? ?? 'Sin nombre';
    final rut = users['rut'] as String?;
    final phone = users['phone_number'] as String?;
    final email = users['email'] as String?;
    final emergencyContacts =
        users['emergency_contacts'] as List<dynamic>? ?? [];
    final addresses = users['user_addresses'] as List<dynamic>? ?? [];
    final enrollmentDate = detail['enrollment_date'] as String?;

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
          spacing: 20,
          children: [
            Row(
              spacing: 12,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getColor(fullName),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(fullName),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF002045),
                        ),
                      ),
                      Text(
                        'Voluntario',
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

            Column(
              spacing: 12,
              children: [
                if (rut != null)
                  _DetailItem(icon: Icons.badge, label: 'RUT', value: rut),
                if (phone != null)
                  _DetailItem(
                      icon: Icons.phone, label: 'Teléfono', value: phone),
                if (email != null)
                  _DetailItem(
                      icon: Icons.email, label: 'Email', value: email),
                if (enrollmentDate != null)
                  _DetailItem(
                    icon: Icons.schedule,
                    label: 'Inscrito',
                    value: _formatDate(enrollmentDate),
                  ),
                if (emergencyContacts.isNotEmpty)
                  _DetailItem(
                    icon: Icons.emergency,
                    label: 'Contacto emergencia',
                    value:
                        '${emergencyContacts.first['contact_name']} - ${emergencyContacts.first['contact_number']}',
                  ),
                if (addresses.isNotEmpty)
                  _DetailItem(
                    icon: Icons.location_on,
                    label: 'Dirección',
                    value:
                        '${addresses.first['alias'] ?? ''}: ${addresses.first['full_address'] ?? ''}',
                  ),
              ],
            ),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListVolunteersScreen(
                      routeId: routeId,
                      routeTitle: routeTitle,
                    ),
                  ),
                );
              },
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

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteMapSection extends StatelessWidget {
  final VoidCallback onTrackingMapPressed;
  final VoidCallback onControlPointPressed;
  final List<LatLng>? routePoints;

  const RouteMapSection({
    super.key,
    required this.onTrackingMapPressed,
    required this.onControlPointPressed,
    this.routePoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      width: double.infinity,
      height: 380,
      child: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: routePoints?.isNotEmpty == true
                  ? routePoints!.first
                  : const LatLng(-38.769, -72.597),
              initialZoom: 14.0,
              maxZoom: 18.0,
              minZoom: 3.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ruta_segura',
              ),
              if (routePoints != null && routePoints!.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints!,
                      color: Colors.blueAccent,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
            ],
          ),

          // Control Point Info (Bottom Left)
          Positioned(
            bottom: 24,
            left: 24,
            right: 80,
            child: GestureDetector(
              onTap: onControlPointPressed,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            'Próximo Punto de Control',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Text(
                            'Plaza Mayor - 400m',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tracking Map Button (Bottom Right)
          Positioned(
            bottom: 24,
            right: 24,
            child: GestureDetector(
              onTap: onTrackingMapPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.public,
                      color: Colors.black87,
                      size: 20,
                    ),
                    const Text(
                      'Mapa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


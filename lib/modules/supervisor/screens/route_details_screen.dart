import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '/modules/supervisor/models/route_model.dart';
import '/modules/supervisor/services/route_service.dart';
import '/modules/global/services/auth_store.dart';
import '/modules/supervisor/screens/map_view_screen.dart';
import '/modules/supervisor/screens/edit_routes_screen.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
import '/modules/supervisor/widgets/route_header_card.dart';
import '/modules/supervisor/widgets/route_map_section.dart';
import '/modules/supervisor/widgets/route_action_buttons.dart';
import '/modules/supervisor/widgets/end_route_modal.dart';

class RouteDetailsScreen extends StatefulWidget {
  final RouteModel route;

  const RouteDetailsScreen({super.key, required this.route});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  final RouteService _routeService = RouteService(token: AuthStore.token);
  bool _isFinishing = false;

  List<LatLng> get _routePoints {
    final points = widget.route.basePoints;
    if (points == null || points.isEmpty) return [];
    return points.map((p) {
      if (p is Map<String, dynamic>) {
        return LatLng(
          (p['lat'] as num).toDouble(),
          (p['lng'] as num).toDouble(),
        );
      }
      return null;
    }).whereType<LatLng>().toList();
  }

// Mapa tab

  Future<void> _finishRoute() async {
    setState(() => _isFinishing = true);
    try {
      await _routeService.finishRoute(widget.route.id);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SupNavbar()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al finalizar ruta: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isFinishing = false);
    }
  }

  Future<void> _deleteRoute() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar Ruta'),
        content: const Text('¿Estás seguro de que deseas borrar esta ruta? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _routeService.deleteRoute(widget.route.id);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SupNavbar()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al borrar ruta: $e')),
        );
      }
    } finally {
    }
  }

  void _showEndRouteModal() {
    showDialog(
      context: context,
      barrierDismissible: !_isFinishing,
      builder: (context) => EndRouteModal(
        onConfirm: () {
          Navigator.pop(context);
          _finishRoute();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
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

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: Column(
                            spacing: 20,
                            children: [
                              RouteHeaderCard(
                                routeId: 'RS-${widget.route.id}',
                                routeTitle: 'Supervisión de Ruta: ${widget.route.title}',
                                description:
                                    'Monitorización en tiempo real de la ruta segura asignada. Verifique el estado de los voluntarios y los puntos de control.',
                                status: 'RUTA ACTIVA',
                              ),

                              // Map Section
                              RouteMapSection(
                                routePoints: _routePoints,
                                onTrackingMapPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapViewScreen(
                                            routePoints: _routePoints,
                                            routeId: widget.route.id,
                                            routeTitle: widget.route.title,
                                          ),
                                    ),
                                  );
                                },
                                onControlPointPressed: () {
                                  //nada
                                },
                              ),

                              // Action Buttons
                              RouteActionButtons(
                                onEndRoute: _showEndRouteModal,
                                onEditRoute: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRouteScreen(route: widget.route),
                                    ),
                                  );
                                },
                                onDeleteRoute: _deleteRoute,
                              ),

                              // Extra spacing for FAB
                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom Navigation
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SupNavbar(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

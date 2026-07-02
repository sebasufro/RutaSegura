import 'package:flutter/material.dart';
import '/modules/supervisor/screens/map_view_screen.dart';
import '/modules/supervisor/screens/edit_routes_screen.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
import '/modules/supervisor/widgets/route_header_card.dart';
import '/modules/supervisor/widgets/route_map_section.dart';
import '/modules/supervisor/widgets/route_action_buttons.dart';
import '/modules/supervisor/widgets/end_route_modal.dart';

class RouteDetailsScreen extends StatefulWidget {
  const RouteDetailsScreen({super.key});

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
// Mapa tab

  void _showEndRouteModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => EndRouteModal(
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SupNavbar()),
          );
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
                              // Route Header Card
                              RouteHeaderCard(
                                routeId: 'RS-2024-08',
                                routeTitle: 'Supervisión de Ruta: Ruta Agrupación 1',
                                description:
                                    'Monitorización en tiempo real de la ruta segura asignada. Verifique el estado de los voluntarios y los puntos de control.',
                                status: 'RUTA ACTIVA',
                              ),

                              // Map Section
                              RouteMapSection(
                                onTrackingMapPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const MapViewScreen()),
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
                                    MaterialPageRoute(builder: (context) => const EditRouteScreen()),
                                  );
                                },
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

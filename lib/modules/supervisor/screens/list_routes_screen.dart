import 'package:flutter/material.dart';
import '/modules/supervisor/models/route_model.dart';
import '/modules/supervisor/screens/route_details_screen.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/routes_control_panel.dart';
import '/modules/supervisor/widgets/route_card.dart';

class ListRoutesScreen extends StatefulWidget {
  const ListRoutesScreen({super.key});

  @override
  State<ListRoutesScreen> createState() => _ListRoutesScreenState();
}

class _ListRoutesScreenState extends State<ListRoutesScreen> {
  final List<RouteModel> allRoutes = List.generate(
    10,
    (index) => RouteModel(
      id: index + 1,
      title: 'Ruta Agrupación ${index + 1}',
      sector: 'SECTOR DESIGNADO',
      schedule: 'HORARIO DESIGNADO',
    ),
  );

  int _displayedRouteCount = 3;

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

                    // Content Wrapper
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          child: Column(
                            children: [
                              // Control Panel
                              RoutesControlPanel(
                                onQuantityChanged: (quantity) {
                                  setState(() => _displayedRouteCount = quantity);
                                },
                              ),

                              // Routes List
                              Column(
                                spacing: 16,
                                children: List.generate(
                                  _displayedRouteCount > allRoutes.length
                                      ? allRoutes.length
                                      : _displayedRouteCount,
                                  (index) {
                                    final route = allRoutes[index];
                                    return RouteCard(
                                      route: route,
                                      onViewPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const RouteDetailsScreen()),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 60), // Extra spacing for FAB
                            ],
                          ),
                        ),
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
  }

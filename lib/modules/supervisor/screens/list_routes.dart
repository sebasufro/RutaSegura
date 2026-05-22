import 'package:flutter/material.dart';
import '/modules/supervisor/models/route_model.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/routes_control_panel.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
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
      activeVolunteers: 7 + index,
      volunteerEmojis: ['👩', '👨'],
    ),
  );

  int _displayedRouteCount = 3;
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 412,
            height: 917,
            color: const Color(0xFFF8FAFC),
            child: Stack(
              children: [
                // Main Content
                Column(
                  children: [
                    // Topbar
                    const ListRoutesTopbar(),

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
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Ver ruta ${route.id}')),
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

                // Floating Action Button
                Positioned(
                  bottom: 120,
                  right: 24,
                  child: FloatingActionButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Crear nueva ruta')),
                      );
                    },
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xFF9ca3af),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 28, color: Colors.white),
                        const SizedBox(height: 4),
                        const Text(
                          'AGREGAR',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ListRoutesBottomNav(
                    currentIndex: _currentNavIndex,
                    onNavigate: (index) {
                      setState(() => _currentNavIndex = index);
                      final sections = ['rutas', 'mapa', 'perfil'];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ir a ${sections[index]}')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

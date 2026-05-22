import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/volunteers_list_header.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
import '/modules/supervisor/widgets/volunteer_card.dart';

class Volunteer {
  final String initials;
  final Color avatarColor;
  final String name;
  final String description;
  final String lastUpdate;
  final String batteryStatus;

  Volunteer({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.description,
    required this.lastUpdate,
    required this.batteryStatus,
  });
}

class ListVolunteersScreen extends StatefulWidget {
  const ListVolunteersScreen({super.key});

  @override
  State<ListVolunteersScreen> createState() => _ListVolunteersScreenState();
}

class _ListVolunteersScreenState extends State<ListVolunteersScreen> {
  int _currentNavIndex = 0;

  // Sample volunteer data
  final List<Volunteer> volunteers = [
    Volunteer(
      initials: 'MJ',
      avatarColor: const Color(0xFFF59E0B),
      name: 'María Johnson',
      description: 'Coordinadora de Zona',
      lastUpdate: 'hace 2 min',
      batteryStatus: '85%',
    ),
    Volunteer(
      initials: 'SK',
      avatarColor: const Color(0xFF6366F1),
      name: 'Santiago Keller',
      description: 'Voluntario Activo',
      lastUpdate: 'hace 5 min',
      batteryStatus: '62%',
    ),
    Volunteer(
      initials: 'RL',
      avatarColor: const Color(0xFF10B981),
      name: 'Rosa López',
      description: 'Supervisora de Ruta',
      lastUpdate: 'hace 1 min',
      batteryStatus: '91%',
    ),
    Volunteer(
      initials: 'AV',
      avatarColor: const Color(0xFFEF4444),
      name: 'Andrés Vega',
      description: 'Voluntario Activo',
      lastUpdate: 'hace 3 min',
      batteryStatus: '45%',
    ),
    Volunteer(
      initials: 'CB',
      avatarColor: const Color(0xFF8B5CF6),
      name: 'Camila Benítez',
      description: 'Coordinadora de Zona',
      lastUpdate: 'hace 4 min',
      batteryStatus: '78%',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: 412,
            height: 917,
            color: const Color(0xFFF5F7FA),
            child: Stack(
              children: [
                // Main Content
                Column(
                  children: [
                    // Header with back button
                    VolunteersListHeader(
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    // Route Title
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      color: Colors.white,
                      child: const Text(
                        'Ruta Agrupación 1\nVoluntarios',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                      ),
                    ),

                    // Volunteers List
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            spacing: 16,
                            children: List.generate(
                              volunteers.length,
                              (index) {
                                final volunteer = volunteers[index];
                                return VolunteerCard(
                                  initials: volunteer.initials,
                                  avatarColor: volunteer.avatarColor,
                                  name: volunteer.name,
                                  description: volunteer.description,
                                  lastUpdate: volunteer.lastUpdate,
                                  batteryStatus: volunteer.batteryStatus,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Seleccionado: ${volunteer.name}',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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

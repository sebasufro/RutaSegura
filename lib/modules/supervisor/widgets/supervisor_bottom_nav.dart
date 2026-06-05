import 'package:flutter/material.dart';
import '../screens/list_routes_screen.dart';
import '../screens/create_route_screen.dart';
import '../screens/profile_supervisor_screen.dart';

// Contenedor principal de la interfaz del voluntario.
// Implementa una barra de navegación inferior (BottomNavigationBar)
// que permite alternar entre las vistas de Explorar, Mis Rutas y Perfil
// manteniendo el estado de cada una mediante un IndexedStack.

class SupNavbar extends StatefulWidget {
  const SupNavbar({super.key});

  @override
  State<SupNavbar> createState() => _NavbarContainerState();
}

class _NavbarContainerState extends State<SupNavbar> {
  // Índice de la pestañas.
  // (0 = EXPLORAR, 1 = MIS RUTAS, 2 = PERFIL)
  int _indiceActivo = 0;

  // Lista de pantallas.
  final List<Widget> _pantallas = [
    const ListRoutesScreen(),
    const CreateRouteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = Theme.of(context).primaryColor;

    return Scaffold(
      body: IndexedStack(
        index: _indiceActivo,
        children: _pantallas,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceActivo,
          onTap: (int nuevoIndice) {
            setState(() {
              _indiceActivo = nuevoIndice;
            });
          },
          selectedItemColor: colorPrincipal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed, 
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'EXPLORAR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.route), 
              label: 'MIS RUTAS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'PERFIL',
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/modules/supervisor/screens/list_routes_screen.dart';
import '/modules/supervisor/screens/create_route_screen.dart';
import '/modules/supervisor/screens/supervisor_profile_screen.dart';

class SupNavbar extends StatefulWidget {
  const SupNavbar({super.key});

  @override
  State<SupNavbar> createState() => _NavbarContainerState();
}

class _NavbarContainerState extends State<SupNavbar> {
  // Índice de la pestañas.
  // (0 = MIS RUTAS, 1 = NUEVA RUTA, 2 = PERFIL)
  int _indiceActivo = 0;

  // Lista de pantallas.
  final List<Widget> _pantallas = [
    const ListRoutesScreen(),
    const CreateRouteScreen(),
    const SupervisorProfileScreen(),
  ];

  void _showCloseAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar aplicación'),
        content: const Text('¿Quieres salir de la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Sí'),
          ),
        ],
      ),
    );
  }

  void _showCreateRouteExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandonar formulario'),
        content: const Text('¿Deseas abandonar el formulario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _indiceActivo = 0);
            },
            child: const Text('Sí, abandonar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = Theme.of(context).primaryColor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_indiceActivo == 1) {
          _showCreateRouteExitDialog(context);
        } else {
          _showCloseAppDialog(context);
        }
      },
      child: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _indiceActivo,
              children: _pantallas,
            ),
          ),
          if (_indiceActivo != 1)
            Container(
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
                    icon: Icon(Icons.route),
                    label: 'MIS RUTAS',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'CREAR RUTA',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'PERFIL',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
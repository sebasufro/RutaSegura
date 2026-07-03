import 'package:flutter/material.dart';
import '/modules/supervisor/models/route_model.dart';
import '/modules/supervisor/services/route_service.dart';
import '/modules/global/services/auth_store.dart';
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
  final RouteService _routeService = RouteService(token: AuthStore.token);

  List<RouteModel> _routes = [];
  bool _isLoading = true;
  String? _error;
  int _displayedRouteCount = 3;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final routes = await _routeService.fetchRoutes();
      setState(() {
        _routes = routes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
          child: Column(
            children: [
              const SupTopbar(),

              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRoutes,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_routes.isEmpty) {
      return const Center(
        child: Text('No hay rutas disponibles'),
      );
    }

    final displayCount = _displayedRouteCount > _routes.length
        ? _routes.length
        : _displayedRouteCount;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            RoutesControlPanel(
              onQuantityChanged: (quantity) {
                setState(() => _displayedRouteCount = quantity);
              },
            ),

            Column(
              spacing: 16,
              children: List.generate(
                displayCount,
                (index) {
                  final route = _routes[index];
                  return RouteCard(
                    route: route,
                    onViewPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailsScreen(route: route),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

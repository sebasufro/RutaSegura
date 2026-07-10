import 'package:flutter/material.dart';
import '/modules/supervisor/models/route_model.dart';
import '../services/routes_service.dart';
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
  final RouteService _routeService = RouteService();

  List<RouteModel> _routes = [];
  bool _isLoading = true;
  String? _error;
  int _displayedRouteCount = 3;
  int _currentPage = 0;

  int get _perPage => _displayedRouteCount >= _routes.length ? _routes.length : _displayedRouteCount;

  int get _totalPages => _perPage == 0 ? 1 : (_routes.length / _perPage).ceil();

  int get _startIndex => _currentPage * _perPage;

  int get _endIndex => (_startIndex + _perPage > _routes.length) ? _routes.length : _startIndex + _perPage;

  List<RouteModel> get _visibleRoutes => _routes.sublist(_startIndex, _endIndex);

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
        _currentPage = 0;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _setQuantity(int quantity) {
    setState(() {
      _displayedRouteCount = quantity;
      _currentPage = 0;
    });
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            RoutesControlPanel(
              onQuantityChanged: _setQuantity,
            ),

            Column(
              spacing: 16,
              children: _visibleRoutes.map((route) {
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
              }).toList(),
            ),

            if (_totalPages > 1) ...[
              const SizedBox(height: 16),
              _buildPaginationBar(),
            ],

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 0
              ? () => setState(() => _currentPage--)
              : null,
          style: IconButton.styleFrom(
            foregroundColor: _currentPage > 0 ? const Color(0xFF1e40af) : Colors.grey,
          ),
        ),

        ...List.generate(_totalPages, (i) {
          final isActive = i == _currentPage;
          return GestureDetector(
            onTap: () => setState(() => _currentPage = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1e40af) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF43474E),
                ),
              ),
            ),
          );
        }),

        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < _totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
          style: IconButton.styleFrom(
            foregroundColor: _currentPage < _totalPages - 1 ? const Color(0xFF1e40af) : Colors.grey,
          ),
        ),
      ],
    );
  }
}

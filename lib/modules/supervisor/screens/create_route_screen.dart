import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '/modules/supervisor/models/route_model.dart';
import '../services/route_service.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
import '/modules/supervisor/widgets/create_route_page1.dart';
import '/modules/supervisor/widgets/create_route_page2.dart';
import '/modules/supervisor/widgets/create_route_page3.dart';
import '/modules/supervisor/widgets/create_route_page4.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen>
    with SingleTickerProviderStateMixin {
  final RouteService _routeService = RouteService();
  int _currentPage = 0;
  bool _isSaving = false;

  final Map<String, dynamic> _formData = {
    'nombreRuta': '',
    'fecha': '',
    'horarioInicio': '',
    'horarioTermino': '',
    'voluntariosMin': 0,
    'voluntariosMax': 0,
    'direccionInicio': '',
    'direccionFinal': '',
    'transporteIda': '',
    'descripcion': '',
  };

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _goToPage(_currentPage + 1);
    } else if (_currentPage == 2) {
      _publishRoute();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _goToPage(_currentPage - 1);
    } else {
      _showExitDialog();
    }
  }

  void _showExitDialog() {
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SupNavbar()),
                (route) => false,
              );
            },
            child: const Text('Sí, abandonar'),
          ),
        ],
      ),
    );
  }

  List<Map<String, double>> _latLngToBasePoints(List<LatLng> points) {
    return points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList();
  }

  DateTime? _parseStartDateTime() {
    try {
      final date = _formData['fecha'] as String;
      final time = _formData['horarioInicio'] as String;
      final dateParts = date.split('-');
      final timeParts = time.split(':');
      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseEndDateTime() {
    try {
      final date = _formData['fecha'] as String;
      final time = _formData['horarioTermino'] as String;
      final dateParts = date.split('-');
      final timeParts = time.split(':');
      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _publishRoute() async {
    setState(() => _isSaving = true);

    final rutaPoints = _formData['rutaPoints'] as List<LatLng>? ?? [];
    final startingPoint = rutaPoints.isNotEmpty ? rutaPoints.first : null;
    final endingPoint = rutaPoints.isNotEmpty ? rutaPoints.last : null;

    final routeName = _formData['nombreRuta'] as String?;
    final newRoute = RouteModel(
      id: '',
      routeName: (routeName != null && routeName.isNotEmpty) ? routeName : 'Ruta ${_formData['fecha']}',
      description: _formData['descripcion'] as String?,
      startingDatetime: _parseStartDateTime(),
      endingDatetime: _parseEndDateTime(),
      minVolunteers: _formData['voluntariosMin'] as int?,
      maxCapacity: _formData['voluntariosMax'] as int?,
      startingLatitude: startingPoint?.latitude,
      startingLongitude: startingPoint?.longitude,
      endingLatitude: endingPoint?.latitude,
      endingLongitude: endingPoint?.longitude,
      transportType: _formData['transporteIda'] as String?,
      basePoints: _latLngToBasePoints(rutaPoints),
      status: 'PUBLISHED',
    );

    try {
      await _routeService.createRoute(newRoute);
      if (mounted) {
        _goToPage(3);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear ruta: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _finishForm() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SupNavbar()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentPage > 0) {
          _previousPage();
        } else {
          _showExitDialog();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFF8FAFC),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SupTopbar(),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() => _currentPage = page);
                        },
                        children: [
                          CreateRoutePage1(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),
                          CreateRoutePage2(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),
                          CreateRoutePage3(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),
                          CreateRoutePage4(
                            onFinish: _finishForm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_isSaving)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

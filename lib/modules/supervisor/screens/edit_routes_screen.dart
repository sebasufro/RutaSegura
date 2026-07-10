import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '/modules/supervisor/models/route_model.dart';
import '../services/routes_service.dart';
import '/modules/supervisor/screens/list_routes_screen.dart';
import '/modules/supervisor/screens/route_details_screen.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/edit_route_page1.dart';
import '/modules/supervisor/widgets/edit_route_page2.dart';
import '/modules/supervisor/widgets/edit_route_page3.dart';
import '/modules/supervisor/widgets/edit_route_page4.dart';

class EditRouteScreen extends StatefulWidget {
  final RouteModel? route;

  const EditRouteScreen({super.key, this.route});

  @override
  State<EditRouteScreen> createState() => _EditRouteScreenState();
}

class _EditRouteScreenState extends State<EditRouteScreen>
    with SingleTickerProviderStateMixin {
  final RouteService _routeService = RouteService();
  int _currentPage = 0;
  bool _isSaving = false;
  RouteModel? _savedRoute;

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
    _initFormData();
  }

  void _initFormData() {
    final r = widget.route;
    if (r == null) return;

    _formData['nombreRuta'] = r.routeName;
    _formData['fecha'] = r.startingDatetime != null
        ? '${r.startingDatetime!.day.toString().padLeft(2, '0')}-${r.startingDatetime!.month.toString().padLeft(2, '0')}-${r.startingDatetime!.year}'
        : '';
    _formData['horarioInicio'] = r.startingDatetime != null
        ? '${r.startingDatetime!.hour.toString().padLeft(2, '0')}:${r.startingDatetime!.minute.toString().padLeft(2, '0')}'
        : '';
    _formData['horarioTermino'] = r.endingDatetime != null
        ? '${r.endingDatetime!.hour.toString().padLeft(2, '0')}:${r.endingDatetime!.minute.toString().padLeft(2, '0')}'
        : '';
    _formData['voluntariosMin'] = r.minVolunteers ?? 0;
    _formData['voluntariosMax'] = r.maxCapacity ?? 0;
    _formData['direccionInicio'] = r.startingLatitude != null
        ? '${r.startingLatitude}, ${r.startingLongitude}'
        : '';
    _formData['direccionFinal'] = r.endingLatitude != null
        ? '${r.endingLatitude}, ${r.endingLongitude}'
        : '';
    _formData['transporteIda'] = r.transportType ?? '';
    _formData['descripcion'] = r.description ?? '';
    _formData['rutaPoints'] = _basePointsToLatLng(r.basePoints);
  }

  List<LatLng> _basePointsToLatLng(List<dynamic>? points) {
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

  List<Map<String, double>> _latLngToBasePoints(List<LatLng> points) {
    return points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList();
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
      _saveRoute();
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
        content: const Text('¿Deseas abandonar la edición?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ListRoutesScreen()),
                (route) => false,
              );
            },
            child: const Text('Sí, abandonar'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveRoute() async {
    setState(() => _isSaving = true);

    final r = widget.route;
    final rutaPoints = _formData['rutaPoints'] as List<LatLng>? ?? [];
    final startingPoint = rutaPoints.isNotEmpty ? rutaPoints.first : null;
    final endingPoint = rutaPoints.isNotEmpty ? rutaPoints.last : null;
    final routeName = _formData['nombreRuta'] as String?;

    final updatedRoute = RouteModel(
      id: r?.id ?? '',
      routeName: (routeName != null && routeName.isNotEmpty) ? routeName : (r?.routeName ?? ''),
      description: _formData['descripcion'] as String?,
      startingDatetime: _formData['fecha'] != null && _formData['horarioInicio'] != null
          ? _parseDateTime(
              _formData['fecha'] as String,
              _formData['horarioInicio'] as String,
            )
          : r?.startingDatetime,
      endingDatetime: _formData['fecha'] != null && _formData['horarioTermino'] != null
          ? _parseDateTime(
              _formData['fecha'] as String,
              _formData['horarioTermino'] as String,
            )
          : r?.endingDatetime,
      minVolunteers: _formData['voluntariosMin'] as int?,
      maxCapacity: _formData['voluntariosMax'] as int?,
      startingLatitude: startingPoint?.latitude ?? r?.startingLatitude,
      startingLongitude: startingPoint?.longitude ?? r?.startingLongitude,
      endingLatitude: endingPoint?.latitude ?? r?.endingLatitude,
      endingLongitude: endingPoint?.longitude ?? r?.endingLongitude,
      transportType: _formData['transporteIda'] as String?,
      sector: r?.sector,
      schedule: r?.schedule,
      status: r?.status,
      basePoints: _latLngToBasePoints(rutaPoints),
    );

    try {
      await _routeService.updateRoute(updatedRoute);
      if (mounted) {
        setState(() => _savedRoute = updatedRoute);
        _goToPage(3);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _finishForm() {
    final route = _savedRoute ?? widget.route!;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(route: route),
      ),
      (path) => false,
    );
  }

  DateTime? _parseDateTime(String date, String time) {
    try {
      final parts = date.split('-');
      final timeParts = time.split(':');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return null;
    }
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
                          EditRoutePage1(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),
                          EditRoutePage2(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),
                          EditRoutePage3(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),
                          EditRoutePage4(
                            onFinish: _isSaving ? () {} : _finishForm,
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

import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/supervisor_topbar.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
import '/modules/supervisor/widgets/edit_route_page1.dart';
import '/modules/supervisor/widgets/edit_route_page2.dart';
import '/modules/supervisor/widgets/edit_route_page3.dart';
import '/modules/supervisor/widgets/edit_route_page4.dart';

class EditRouteScreen extends StatefulWidget {
  const EditRouteScreen({super.key});

  @override
  State<EditRouteScreen> createState() => _EditRouteScreenState();
}

class _EditRouteScreenState extends State<EditRouteScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  int _currentNavIndex = 0;

  // Form data storage
  final Map<String, dynamic> _formData = {
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
    if (_currentPage < 3) {
      _goToPage(_currentPage + 1);
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Sí, abandonar'),
          ),
        ],
      ),
    );
  }

  void _finishForm() {
    // Clear the form data
    _formData.clear();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ruta editada exitosamente')),
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
                    const ListRoutesTopbar(),

                    // Page Content
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() => _currentPage = page);
                        },
                        children: [
                          // Page 1
                          EditRoutePage1(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),

                          // Page 2
                          EditRoutePage2(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),

                          // Page 3
                          EditRoutePage3(
                            formData: _formData,
                            onNext: _nextPage,
                            onBack: _previousPage,
                          ),

                          // Page 4
                          EditRoutePage4(
                            onFinish: _finishForm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom Navigation (only show if not on success page)
                if (_currentPage < 3)
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

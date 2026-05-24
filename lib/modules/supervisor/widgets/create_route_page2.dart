import 'package:flutter/material.dart';

class CreateRoutePage2 extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CreateRoutePage2({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<CreateRoutePage2> createState() => _CreateRoutePage2State();
}

class _CreateRoutePage2State extends State<CreateRoutePage2> {
  late TextEditingController _direccionInicioController;
  late TextEditingController _direccionFinalController;

  @override
  void initState() {
    super.initState();
    _direccionInicioController =
        TextEditingController(text: widget.formData['direccionInicio'] ?? '');
    _direccionFinalController =
        TextEditingController(text: widget.formData['direccionFinal'] ?? '');
  }

  @override
  void dispose() {
    _direccionInicioController.dispose();
    _direccionFinalController.dispose();
    super.dispose();
  }

  void _saveData() {
    widget.formData['direccionInicio'] = _direccionInicioController.text;
    widget.formData['direccionFinal'] = _direccionFinalController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Page Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: const Text(
            'Crear Ruta Social',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF002045),
            ),
          ),
        ),

        // Step Indicator
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            'Paso 2 de 3',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E3A8A),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        // Card Section
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 32,
                children: [
                  // Section Title
                  const Text(
                    'Ingresa Recorrido',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF43474E),
                    ),
                  ),

                  // Map Container (Blank Rectangle)
                  Container(
                    width: double.infinity,
                    height: 252,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFE7ECFB),
                          Color(0xFFDBEAFE),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Map placeholder text
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 10,
                            children: [
                              const Text(
                                'Mapa interactivo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              Text(
                                'Se integrará con tu proveedor de mapas',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Map Controls
                        Positioned(
                          bottom: 24,
                          right: 24,
                          child: Column(
                            spacing: 8,
                            children: [
                              // Zoom In
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Zoom In')),
                                  );
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Zoom Out
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Zoom Out')),
                                  );
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '−',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Center Location
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Center Location')),
                                  );
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF002045),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Address Fields
                  Column(
                    spacing: 12,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'INICIO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          TextField(
                            controller: _direccionInicioController,
                            decoration: InputDecoration(
                              hintText: 'Dirección',
                              filled: true,
                              fillColor: const Color(0xFFF2F4F6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'FINAL',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          TextField(
                            controller: _direccionFinalController,
                            decoration: InputDecoration(
                              hintText: 'Dirección',
                              filled: true,
                              fillColor: const Color(0xFFF2F4F6),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Buttons
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 110, left: 20, right: 20),
          child: Column(
            spacing: 15,
            children: [
              GestureDetector(
                onTap: () {
                  _saveData();
                  widget.onNext();
                },
                child: Container(
                  width: 306,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF002045),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF003B7E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: const [
                      Text(
                        'Siguiente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE7ECFB),
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Color(0xFFE7ECFB)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: const [
                      Icon(Icons.arrow_back, color: Color(0xFFE7ECFB), size: 24),
                      Text(
                        'Volver',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE7ECFB),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class EditRoutePage1 extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EditRoutePage1({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<EditRoutePage1> createState() => _EditRoutePage1State();
}

class _EditRoutePage1State extends State<EditRoutePage1> {
  final _nombreRutaController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horarioInicioController = TextEditingController();
  final _horarioTerminoController = TextEditingController();
  final _fechaTerminoController = TextEditingController();
  final _voluntariosMinController = TextEditingController();
  final _voluntariosMaxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreRutaController.text = widget.formData['nombreRuta'] ?? '';
    _fechaController.text = widget.formData['fecha'] ?? '';
    _horarioInicioController.text = widget.formData['horarioInicio'] ?? '';
    _horarioTerminoController.text = widget.formData['horarioTermino'] ?? '';
    _fechaTerminoController.text = widget.formData['fechaTermino'] ?? '';
    _voluntariosMinController.text = widget.formData['voluntariosMin']?.toString() ?? '0';
    _voluntariosMaxController.text = widget.formData['voluntariosMax']?.toString() ?? '0';
  }

  @override
  void dispose() {
    _nombreRutaController.dispose();
    _fechaController.dispose();
    _horarioInicioController.dispose();
    _horarioTerminoController.dispose();
    _fechaTerminoController.dispose();
    _voluntariosMinController.dispose();
    _voluntariosMaxController.dispose();
    super.dispose();
  }

  void _saveData() {
    widget.formData['nombreRuta'] = _nombreRutaController.text;
    widget.formData['fecha'] = _fechaController.text;
    widget.formData['fechaTermino'] = _fechaTerminoController.text;
    widget.formData['horarioInicio'] = _horarioInicioController.text;
    widget.formData['horarioTermino'] = _horarioTerminoController.text;
    widget.formData['voluntariosMin'] = int.tryParse(_voluntariosMinController.text) ?? 0;
    widget.formData['voluntariosMax'] = int.tryParse(_voluntariosMaxController.text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Column(
          children: [
            // Page Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Editar Ruta Social',
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
                'Paso 1 de 3',
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
                        'Información general de la ruta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF43474E),
                        ),
                      ),

                      // Nombre de la ruta
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'NOMBRE DE LA RUTA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          TextField(
                            controller: _nombreRutaController,
                            decoration: InputDecoration(
                              hintText: 'Ej: Ruta Centro - Norte',
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

                      // Fecha
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'FECHA INICIO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          TextField(
                            controller: _fechaController,
                            decoration: InputDecoration(
                              hintText: 'DD-MM-AAAA',
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

                      // Fecha Termino
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'FECHA TÉRMINO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          TextField(
                            controller: _fechaTerminoController,
                            decoration: InputDecoration(
                              hintText: 'DD-MM-AAAA',
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

                      // Horario Inicio and Termino
                      Column(
                        spacing: 16,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    const Text(
                                      'HORARIO INICIO',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF74777F),
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    TextField(
                                      controller: _horarioInicioController,
                                      decoration: InputDecoration(
                                        hintText: 'HH:MM',
                                        filled: true,
                                        fillColor: const Color(0xFFF2F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    const Text(
                                      'HORARIO TERMINO',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF74777F),
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    TextField(
                                      controller: _horarioTerminoController,
                                      decoration: InputDecoration(
                                        hintText: 'HH:MM',
                                        filled: true,
                                        fillColor: const Color(0xFFF2F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
    
                      // Voluntarios
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          const Text(
                            'CANTIDAD DE VOLUNTARIOS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    const Text(
                                      'MÍNIMO',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF74777F),
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    TextField(
                                      controller: _voluntariosMinController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        filled: true,
                                        fillColor: const Color(0xFFF2F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    const Text(
                                      'MÁXIMO',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF74777F),
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    TextField(
                                      controller: _voluntariosMaxController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        filled: true,
                                        fillColor: const Color(0xFFF2F4F6),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),
                                      ),
                                    ),
                                  ],
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
          padding: const EdgeInsets.only(top: 20, bottom: 45, left: 20, right: 20),
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
        )
      ]
    );
  }
}

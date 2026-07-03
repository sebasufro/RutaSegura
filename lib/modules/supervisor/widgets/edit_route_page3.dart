import 'package:flutter/material.dart';

class EditRoutePage3 extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EditRoutePage3({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<EditRoutePage3> createState() => _EditRoutePage3State();
}

class _EditRoutePage3State extends State<EditRoutePage3> {
  late TextEditingController _transporteIdaController;
  late TextEditingController _descripcionController;
  String? _selectedTransporte;

  final List<String> _transportOptions = ['Bus', 'Van', 'Auto', 'Caminata', 'Otro'];

  @override
  void initState() {
    super.initState();
    _transporteIdaController =
        TextEditingController(text: widget.formData['transporteIda'] ?? '');
    _descripcionController =
        TextEditingController(text: widget.formData['descripcion'] ?? '');
    final transporte = widget.formData['transporteIda'];
    _selectedTransporte = (transporte != null && transporte.isNotEmpty) ? transporte : null;
  }

  @override
  void dispose() {
    _transporteIdaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _saveData() {
    widget.formData['transporteIda'] = _selectedTransporte ?? '';
    widget.formData['descripcion'] = _descripcionController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Page Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
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
                'Paso 3 de 3',
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
                        'Información Adicional',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF43474E),
                        ),
                      ),
    
                      // Transport Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'TRANSPORTE DE IDA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedTransporte,
                              isExpanded: true,
                              isDense: false,
                              underline: const SizedBox(),
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Text(
                                      'Seleccionar transporte...',
                                      style: TextStyle(color: Colors.grey[500]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                ..._transportOptions.map(
                                  (option) => DropdownMenuItem(
                                    value: option,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Text(
                                        option,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedTransporte = value);
                              },
                            ),
                          ),
                        ],
                      ),
    
                      // Description Textarea
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Text(
                            'DESCRIPCIÓN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF74777F),
                              letterSpacing: 0.6,
                            ),
                          ),
                          TextField(
                            controller: _descripcionController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText: 'Qué actividades se realizarán...',
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
                            'Guardar',
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

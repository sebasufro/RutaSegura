import 'package:flutter/material.dart';

// Popup para agregar un nuevo contacto de emergencia.
// Llama a [onGuardar] con nombre y teléfono al confirmar.
void mostrarPopupAgregarContacto(
  BuildContext context, {
  required void Function(String nombre, String telefono) onGuardar,
}) {
  showDialog(
    context: context,
    builder: (_) => _ContactoFormDialog(
      titulo: 'Nuevo Contacto',
      labelBoton: 'Agregar',
      onGuardar: onGuardar,
    ),
  );
}

// Popup para editar un contacto existente.
// Recibe los valores actuales y llama a [onGuardar] con los nuevos.
void mostrarPopupEditarContacto(
  BuildContext context, {
  required String nombreActual,
  required String telefonoActual,
  required void Function(String nombre, String telefono) onGuardar,
}) {
  showDialog(
    context: context,
    builder: (_) => _ContactoFormDialog(
      titulo: 'Editar Contacto',
      labelBoton: 'Guardar',
      nombreInicial: nombreActual,
      telefonoInicial: telefonoActual,
      onGuardar: onGuardar,
    ),
  );
}

// Popup de confirmación para eliminar un contacto.
// Llama a [onConfirmar] si el usuario acepta.
void mostrarPopupEliminarContacto(
  BuildContext context, {
  required String nombre,
  required VoidCallback onConfirmar,
}) {
  showDialog(
    context: context,
    builder: (_) => _EliminarContactoDialog(
      nombre: nombre,
      onConfirmar: onConfirmar,
    ),
  );
}

// Edición de contacto
// Se configura mediante [titulo], [labelBoton] y valores iniciales opcionales.
class _ContactoFormDialog extends StatefulWidget {
  final String titulo;
  final String labelBoton;
  final String nombreInicial;
  final String telefonoInicial;
  final void Function(String nombre, String telefono) onGuardar;

  const _ContactoFormDialog({
    required this.titulo,
    required this.labelBoton,
    required this.onGuardar,
    this.nombreInicial = '',
    this.telefonoInicial = '+56 9 ',
  });

  @override
  State<_ContactoFormDialog> createState() => _ContactoFormDialogState();
}

class _ContactoFormDialogState extends State<_ContactoFormDialog> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _telefonoCtrl;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.nombreInicial);
    _telefonoCtrl = TextEditingController(text: widget.telefonoInicial);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  void _confirmar() {
    final nombre = _nombreCtrl.text.trim();
    final telefono = _telefonoCtrl.text.trim();
    if (nombre.isEmpty || telefono.isEmpty) return;
    Navigator.pop(context);
    widget.onGuardar(nombre, telefono);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                widget.titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 24),
  
              // Campo nombre
              const Text(
                'NOMBRE CONTACTO DE EMERGENCIA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              _CampoTexto(
                controller: _nombreCtrl,
                hintText: 'Nombre contacto',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),
  
              // Campo teléfono
              const Text(
                'NÚMERO DE CONTACTO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              _CampoTexto(
                controller: _telefonoCtrl,
                hintText: '+56 9 XXXX XXXX',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 28),
  
              // Botones
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirmar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.labelBoton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Diálogo de confirmación para eliminar un contacto.
class _EliminarContactoDialog extends StatelessWidget {
  final String nombre;
  final VoidCallback onConfirmar;

  const _EliminarContactoDialog({
    required this.nombre,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícono + título
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Eliminar Contacto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
  
              // Mensaje
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: '¿Estás seguro que deseas eliminar a '),
                    TextSpan(
                      text: nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const TextSpan(text: ' de tus contactos de emergencia?'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
  
              // Botones
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirmar();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampoTexto extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  const _CampoTexto({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
      ),
    );
  }
}
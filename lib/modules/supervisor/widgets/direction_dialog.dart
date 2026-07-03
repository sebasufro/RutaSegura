import 'package:flutter/material.dart';

// Muestra el popup para agregar una nueva dirección.
void mostrarPopupAgregarDireccion(
  BuildContext context, {
  required void Function(String alias, String direccion) onGuardar,
}) {
  showDialog(
    context: context,
    builder: (_) => _DireccionFormDialog(
      titulo: 'Nueva Dirección',
      labelBoton: 'Agregar',
      onGuardar: onGuardar,
    ),
  );
}

// Muestra el popup para editar una dirección existente.
void mostrarPopupEditarDireccion(
  BuildContext context, {
  required String aliasActual,
  required String direccionActual,
  required void Function(String alias, String direccion) onGuardar,
}) {
  showDialog(
    context: context,
    builder: (_) => _DireccionFormDialog(
      titulo: 'Editar Dirección',
      labelBoton: 'Guardar',
      aliasInicial: aliasActual,
      direccionInicial: direccionActual,
      onGuardar: onGuardar,
    ),
  );
}

/// Muestra el popup de confirmación para eliminar una dirección.
void mostrarPopupEliminarDireccion(
  BuildContext context, {
  required String alias,
  required VoidCallback onConfirmar,
}) {
  showDialog(
    context: context,
    builder: (_) => _EliminarDireccionDialog(
      alias: alias,
      onConfirmar: onConfirmar,
    ),
  );
}

// Diálogo reutilizable para crear y editar direcciones.
class _DireccionFormDialog extends StatefulWidget {
  final String titulo;
  final String labelBoton;
  final String aliasInicial;
  final String direccionInicial;
  final void Function(String alias, String direccion) onGuardar;

  const _DireccionFormDialog({
    required this.titulo,
    required this.labelBoton,
    required this.onGuardar,
    this.aliasInicial = '',
    this.direccionInicial = '',
  });

  @override
  State<_DireccionFormDialog> createState() => _DireccionFormDialogState();
}

class _DireccionFormDialogState extends State<_DireccionFormDialog> {
  late final TextEditingController _aliasCtrl;
  late final TextEditingController _direccionCtrl;

  @override
  void initState() {
    super.initState();
    _aliasCtrl = TextEditingController(text: widget.aliasInicial);
    _direccionCtrl = TextEditingController(text: widget.direccionInicial);
  }

  @override
  void dispose() {
    _aliasCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  void _confirmar() {
    final alias = _aliasCtrl.text.trim();
    final direccion = _direccionCtrl.text.trim();
    if (alias.isEmpty || direccion.isEmpty) return;
    Navigator.pop(context);
    widget.onGuardar(alias, direccion);
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
              Text(
                widget.titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 24),
  
              // Campo alias (ej: Hogar, Trabajo)
              const Text(
                'NOMBRE DE LA DIRECCIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              _CampoTexto(
                controller: _aliasCtrl,
                hintText: 'Ej: Hogar, Trabajo...',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
  
              // Campo dirección completa
              const Text(
                'DIRECCIÓN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              _CampoTexto(
                controller: _direccionCtrl,
                hintText: 'Ej: Avenida Alemania 0671, Temuco',
                keyboardType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 28),
  
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

// Popup confirmación para eliminar una dirección.
class _EliminarDireccionDialog extends StatelessWidget {
  final String alias;
  final VoidCallback onConfirmar;

  const _EliminarDireccionDialog({
    required this.alias,
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
                    'Eliminar Dirección',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: '¿Estás seguro que deseas eliminar la dirección '),
                    TextSpan(
                      text: alias,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
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

// Campo de texto reutilizable para los popups de dirección.
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
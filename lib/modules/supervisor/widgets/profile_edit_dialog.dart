import 'package:flutter/material.dart';

// Muestra el popup para editar un campo del perfil.
void mostrarPopupEditarPerfil(
  BuildContext context, {
  required String titulo,
  required String labelCampo,
  required String valorInicial,
  required String hintText,
  required TextInputType keyboardType,
  required void Function(String nuevoValor) onGuardar,
}) {
  showDialog(
    context: context,
    builder: (_) => _EditarPerfilDialog(
      titulo: titulo,
      labelCampo: labelCampo,
      valorInicial: valorInicial,
      hintText: hintText,
      keyboardType: keyboardType,
      onGuardar: onGuardar,
    ),
  );
}

// Diálogo reutilizable y estilizado para editar campos del perfil
class _EditarPerfilDialog extends StatefulWidget {
  final String titulo;
  final String labelCampo;
  final String valorInicial;
  final String hintText;
  final TextInputType keyboardType;
  final void Function(String) onGuardar;

  const _EditarPerfilDialog({
    required this.titulo,
    required this.labelCampo,
    required this.valorInicial,
    required this.hintText,
    required this.keyboardType,
    required this.onGuardar,
  });

  @override
  State<_EditarPerfilDialog> createState() => _EditarPerfilDialogState();
}

class _EditarPerfilDialogState extends State<_EditarPerfilDialog> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.valorInicial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _confirmar() {
    final valor = _ctrl.text.trim();
    if (valor.isEmpty) return;
    Navigator.pop(context);
    widget.onGuardar(valor);
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
              
              Text(
                widget.labelCampo,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ctrl,
                keyboardType: widget.keyboardType,
                style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2)),
                ),
              ),
              const SizedBox(height: 28),
              
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context), style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)), child: const Text('Cancelar', style: TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.w600)))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: _confirmar, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0), child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
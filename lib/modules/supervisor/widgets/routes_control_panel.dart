import 'package:flutter/material.dart';

class RoutesControlPanel extends StatefulWidget {
  final Function(int) onQuantityChanged;

  const RoutesControlPanel({
    super.key,
    required this.onQuantityChanged,
  });

  @override
  State<RoutesControlPanel> createState() => _RoutesControlPanelState();
}

class _RoutesControlPanelState extends State<RoutesControlPanel> {
  String _selectedValue = '3';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Mostrar rutas:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF667080),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFb3b8c2),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: _selectedValue,
                  isExpanded: true,
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(value: '3', child: Text('3 rutas')),
                    DropdownMenuItem(value: '5', child: Text('5 rutas')),
                    DropdownMenuItem(value: '10', child: Text('10 rutas')),
                    DropdownMenuItem(value: 'all', child: Text('Todas')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedValue = value);
                      int quantity = value == 'all' ? 999 : int.parse(value);
                      widget.onQuantityChanged(quantity);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

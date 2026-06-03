import 'package:flutter/material.dart';
import '../vol_screens/test_routes.dart';
import '../vol_widgets/route_card.dart';
import '../vol_widgets/button_active_route.dart';

// Pantalla principal de exploración de rutas.
// Permite al voluntario visualizar las rutas disponibles, realizar búsquedas,
// filtrar por zonas y unirse a las rutas creadas en el sistema.
class VolSearchRoutesScreen extends StatefulWidget {
  const VolSearchRoutesScreen({super.key});

  @override
  State<VolSearchRoutesScreen> createState() => _VolSearchRoutesScreenState();
}

class _VolSearchRoutesScreenState extends State<VolSearchRoutesScreen> {

  // Simula la recarga de rutas al hacer "Pull to refresh" en la lista.
  Future<void> _recargarRutas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    final rutasGuardadas = MiniBaseDeDatos.obtenerTodasLasRutas();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
         backgroundColor: Colors.white,
         elevation: 0,
         title: Row(
          children: [
            Icon(Icons.hub_outlined, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text('RUTA SEGURA', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt, color: Colors.blueAccent),
            tooltip: 'Crear Ruta (Test)',
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const TestRoutes()));
              setState(() {}); 
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      
      body: RefreshIndicator(
        onRefresh: _recargarRutas,
        color: Theme.of(context).primaryColor,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          children: [
            Text('EXPLORAR\nRUTAS', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: 1.1, color: Theme.of(context).primaryColor)),
            const SizedBox(height: 10),
            const Text('Selecciona un trayecto monitoreado por nuestra comunidad de guardianes.', style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 25),

            // Sección de búsqueda y filtros (visible solo si hay rutas)
            if (rutasGuardadas.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey), 
                    hintText: 'Buscar por sector o calle...', 
                    border: InputBorder.none
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFiltroChip('Todas', Icons.grid_view, activo: true),
                    _buildFiltroChip('Zona Urbana', Icons.location_on_outlined),
                    _buildFiltroChip('Padre Las Casas', Icons.location_on_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],

            if (rutasGuardadas.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(15)),
                child: const Column(
                  children: [
                    Icon(Icons.map, size: 50, color: Colors.blueGrey),
                    SizedBox(height: 10),
                    Text('No hay rutas disponibles por el momento.\n¡Desliza hacia abajo para actualizar o usa el botón de arriba para crear una!', textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey)),
                  ],
                ),
              )
            else
              ...rutasGuardadas.map((ruta) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: TarjetaRuta(datosRuta: ruta), 
                );
              }),

            const SizedBox(height: 80), 
          ],
        ),
      ),
      floatingActionButton: const ButtonActiveRoute(),
    );
  }

  // Genera un botón tipo "Chip" para las opciones de filtrado.
  Widget _buildFiltroChip(String texto, IconData icono, {bool activo = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: activo ? Colors.grey[300] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icono, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(texto, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
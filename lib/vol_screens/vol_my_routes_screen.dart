import 'package:flutter/material.dart';
import '../vol_widgets/my_routes_card.dart';
import '../vol_widgets/vol_topbar.dart';

// Pantalla que muestra el listado de rutas a las que el usuario
// se ha inscrito. Permite revisar el estado actual de las rutas
// y proporciona la opción de desinscribirse si es necesario.

class VolMyRoutesScreen extends StatefulWidget {
  const VolMyRoutesScreen({super.key});

  @override
  State<VolMyRoutesScreen> createState() => _VolMyRoutesScreenState();
}

class _VolMyRoutesScreenState extends State<VolMyRoutesScreen> {

  // Lista simulada para pruebas de rutas en las que el usuario está inscrito.
  // TODO: Reemplazar con llamada a la API correspondiente.

  final List<Map<String, dynamic>> _misRutasActivas = [
    {
      'id': '1',
      'titulo': 'Ruta Calle Perímetro UFRO',
      'zona': 'SECTOR UNIVERSIDAD',
      'horario': 'NOCTURNO',
      'voluntariosActivos': 13,
      'imagenUrl': 'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=400&auto=format&fit=crop',
    },
    {
      'id': '2',
      'titulo': 'Ruta Plaza Aníbal Pinto',
      'zona': 'ZONA CENTRO',
      'horario': 'DIURNO',
      'voluntariosActivos': 8,
      'imagenUrl': 'https://images.unsplash.com/photo-1519999482648-25049ddd37b1?q=80&w=400&auto=format&fit=crop',
    }
  ];

  // Elimina una ruta de la lista de rutas activas localmente.
  
  void _desinscribirDeRuta(String id) {
    setState(() {
      _misRutasActivas.removeWhere((ruta) => ruta['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = const Color(0xFF1E3A8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const VolTopbar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        children: [
          Text(
            'MIS RUTAS\nACTIVAS',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.1,
              color: colorPrincipal,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Trayectos en los que te has inscrito como voluntario.',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 25),

          if (_misRutasActivas.isEmpty)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
                ]
              ),
              child: Column(
                children: [
                  Icon(Icons.directions_run_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 15),
                  Text(
                    'Sin rutas inscritas', 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Actualmente no estás participando en ningún trayecto. ¡Ve a la pestaña de exploración y únete a alguna ruta!', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.4)
                  ),
                ],
              ),
            )
          else
            ..._misRutasActivas.map((ruta) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MyRoutesCard(
                  titulo: ruta['titulo'],
                  zona: ruta['zona'],
                  horario: ruta['horario'],
                  voluntariosActivos: ruta['voluntariosActivos'],
                  imagenUrl: ruta['imagenUrl'],
                  onDesinscribir: () => _desinscribirDeRuta(ruta['id']),
                ),
              );
            }),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
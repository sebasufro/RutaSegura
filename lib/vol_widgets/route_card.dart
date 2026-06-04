import 'package:flutter/material.dart';
import '../vol_screens/vol_route_details_screen.dart';

// Componente visual que representa una ruta disponible en la plataforma.
// Muestra información clave como el nombre, descripción, capacidad,
// distancia y permite navegar a los detalles de la ruta.
class TarjetaRuta extends StatelessWidget {
  final Map<String, dynamic> datosRuta;

  const TarjetaRuta({super.key, required this.datosRuta});

  @override
  Widget build(BuildContext context) {
    final titulo = datosRuta["route_name"] ?? "Ruta Desconocida";
    final descripcion = datosRuta["descripcion"] ??
        "Breve descripción del trayecto y puntos de control a lo largo del perímetro monitoreado.";
    const imagenUrl =
        'https://images.unsplash.com/photo-1513694203232-719a280e022f?q=80&w=800&auto=format&fit=crop';

    final double distanciaMetros =
        (datosRuta["distancia_metros"] ?? 0).toDouble();
    String textoDistancia = '0 M';
    if (distanciaMetros > 0) {
      textoDistancia = distanciaMetros > 1000
          ? '${(distanciaMetros / 1000).toStringAsFixed(1)} KM'
          : '${distanciaMetros.toInt()} M';
    }

    final int voluntariosActivos = (datosRuta["capacidad_maxima"] ?? 10) ~/ 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imagenUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildTag(Icons.location_on, 'ZONA CENTRO',
                        const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                    _buildTag(Icons.access_time, 'HORARIO NOCTURNO',
                        const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildStackedAvatars(voluntariosActivos),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Voluntarios inscritos: $voluntariosActivos',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  descripcion,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_walk,
                            color: Color(0xFF1E3A8A)),
                        const SizedBox(width: 5),
                        Text(
                          textoDistancia,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VolRouteDetailsScreen(rutaDatos: datosRuta),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Ingresar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_forward,
                              size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTag(
      IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStackedAvatars(int activos) {
    return SizedBox(
      width: 80,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/100?img=1'),
              backgroundColor: Colors.grey[200],
            ),
          ),
          Positioned(
            left: 20,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/100?img=33'),
              backgroundColor: Colors.grey[300],
            ),
          ),
          Positioned(
            left: 40,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey[300],
              child: Text(
                '+${activos > 2 ? activos - 2 : 0}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
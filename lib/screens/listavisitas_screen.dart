import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ListaVisitasScreen extends StatelessWidget {
  final List<ResultadoListaVisitas> articulos;

  ListaVisitasScreen({required this.articulos});

  @override
  Widget build(BuildContext context) {
    String _obtenerNombreTitulo(List<ResultadoListaVisitas> articulos) {
      // si todos tienen el mismo nombre y no está vacío, usa ese
      final nombres = articulos.map((e) => e.nombre).toSet();

      if (nombres.length == 1) {
        return nombres.first;
      }

      // si vienen de consultarListaVisitaB, sabemos que son todos y diferentes
      return 'TODOS';
    }
    String _traducirTipo(String tipo) {
      switch (tipo.trim().toUpperCase()) {
        case 'MAQ':
          return 'Maquinaria';
        case 'REP':
          return 'Repuesto';
        case 'SER':
          return 'Servicio';
        default:
          return tipo; // o poné 'Desconocido'
      }
    }
    String _traducirEstado(String estado) {
      switch (estado.trim().toUpperCase()) {
        case 'F':
          return 'Frío';
        case 'T':
          return 'Tibio';
        case 'C':
          return 'Caliente';
        case 'MC':
          return 'Muy Caliente';
        default:
          return estado; // o poné 'Desconocido' si querés
      }
    }
    String _formatearFecha(String fecha) {
      try {
        final DateTime date = DateTime.parse(fecha);
        return DateFormat('dd-MM-yyyy').format(date);
      } catch (e) {
        return fecha;
      }
    }
    final List<ResultadoListaVisitas> articulosOrdenados = List.from(articulos)
       ..sort((a, b) {
         DateTime fechaA = DateTime.tryParse(a.fecha) ?? DateTime(1900);
          DateTime fechaB = DateTime.tryParse(b.fecha) ?? DateTime(1900);
          return fechaB.compareTo(fechaA); // Más recientes primero
        });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 199, 125),
        title: const Text('Volver',),
      ),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          if (articulosOrdenados.isNotEmpty)
           Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Visitas Registradas de: ${_obtenerNombreTitulo(articulosOrdenados)}',
               style: const TextStyle(
                 fontSize: 20,
                  fontWeight: FontWeight.bold,
                 color: Colors.black87,
               ),
              ),
           ),
         Expanded(
            child: ListView.builder(
             itemCount: articulosOrdenados.length,
              itemBuilder: (context, index) {
               final articulo = articulosOrdenados[index];
               Color backgroundColor;
               switch (articulo.estado?.toUpperCase()) {
                 case 'F': // Frío
                   backgroundColor = const Color(0xFFB3E5FC); // celeste suave
                   break;
                 case 'T': // Tibio
                   backgroundColor = Color.fromARGB(255, 252, 220, 152); // amarillo claro
                   break;
                 case 'C': // Caliente
                   backgroundColor = Color.fromARGB(255, 250, 174, 60); // naranja medio
                   break;
                 case 'MC': // Muy Caliente
                   backgroundColor = const Color(0xFFF57C00); // naranja intenso
                   break;
                 default:
                   backgroundColor = Colors.grey.shade300; // por defecto
               }
               return Column(
                  children: [
                   Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                     child: InkWell(
                        onTap: () {
                          _onArticuloTap(context, articulo.code, articulo.fecha);
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                           color: backgroundColor,
                           borderRadius: BorderRadius.circular(15),
                         ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                             Expanded(
                               child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                                  children: [
                                    Text(
                                      '${articulo.nombre}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${_traducirTipo(articulo.tipo)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Estado: ${_traducirEstado(articulo.estado ?? '')}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                     _formatearFecha(articulo.fecha) ?? '', // Acá va tu texto nuevo
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                     // Espacio entre las dos líneas
                                    Text(
                                     articulo.comment ?? '', // Acá va tu texto nuevo
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                   ),
                   Divider(thickness: 1, color: Colors.grey[300]),
                 ],
               );
             },
            ),
          ),
        ],
      ),
    );
  }

  void _onArticuloTap(BuildContext context, String code, String fecha) {
    final dbProvider = Provider.of<DBProvider>(context, listen: false);
    dbProvider.consultarVisita(context, code, fecha);
  }
}
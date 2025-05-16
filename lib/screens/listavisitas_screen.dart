import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:provider/provider.dart';

class ListaVisitasScreen extends StatelessWidget {
  final List<ResultadoListaVisitas> articulos;

  ListaVisitasScreen({required this.articulos});

  @override
  Widget build(BuildContext context) {
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
        title: Text('Volver',),
      ),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          if (articulosOrdenados.isNotEmpty)
           Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Visitas Registradas de: ${articulos.first.nombre}',
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
                 switch (articulo.estado) {
                   case 'A':
                     backgroundColor = Color.fromARGB(255, 255, 177, 93);
                      break;
                   case 'B':
                      backgroundColor = const Color.fromARGB(255, 255, 102, 91);
                     break;
                   case 'C':
                     backgroundColor = const Color.fromARGB(255, 88, 201, 92);
                     break;
                   default:
                     backgroundColor = Color.fromARGB(255, 255, 177, 93);
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
                              SizedBox(width: 10),
                              Expanded(
                               child: Text(
                                 '${articulo.fecha}    Vendedor: ${articulo.vendedor}   Tipo: ${articulo.tipo}',
                                 style: const TextStyle(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black87,
                                 ),
                               ),
                             ),
                             Icon(Icons.arrow_forward_ios, color: Colors.black),
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
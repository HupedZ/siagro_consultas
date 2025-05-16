import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/screens/imagencasa_screen.dart';
import 'package:fz_consultas/widgets/cardreg_container.dart';
import 'package:fz_consultas/widgets/consulta_background.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class RespuestaVisitasScreen extends StatelessWidget {
  final List<ResultadoVisitas> resultados;

  const RespuestaVisitasScreen({super.key, required this.resultados});

  @override
  Widget build(BuildContext context) {
    return _RespuestaVisitasScreenContent();
  }
}
class _RespuestaVisitasScreenContent extends StatefulWidget {
  const _RespuestaVisitasScreenContent({super.key});

  @override
  State<_RespuestaVisitasScreenContent> createState() => _RespuestaVisitasScreenContentState();
}

class _RespuestaVisitasScreenContentState extends State<_RespuestaVisitasScreenContent> {
  int _indexActual = 0;
  late List<ResultadoVisitas> _resultados;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argumentos = ModalRoute.of(context)!.settings.arguments;
    _resultados = argumentos is List<ResultadoVisitas> ? argumentos : [];
  }

  void _mostrarAnterior() {
    if (_indexActual > 0) {
      setState(() {
        _indexActual--;
      });
    }
  }

  void _mostrarSiguiente() {
    if (_indexActual < _resultados.length - 1) {
      setState(() {
        _indexActual++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visita = _resultados[_indexActual];
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 199, 125),
        title: const Text('Volver'),
      ),
      body: ConsultaBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 32),
            child: Column(
              children: [
                CardRegContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visita ${_indexActual + 1} de ${_resultados.length} realizada en la misma fecha',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Cliente: ${visita.nombre}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Fecha: ${visita.fecha}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Vendedor: ${visita.vendedor}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Comentario: ${visita.coment}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Tipo: ${visita.tipo}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Estado: ${visita.estado ?? 'No tiene registrado ningun estado'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      ListTile(
                        title: Text(
                          'Próxima Fecha: ${visita.proxfecha}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(height: 4,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(visita.imgurl.isNotEmpty)
                          IconButton(
                           onPressed: () {
                            try{
                            Navigator.push(
                                context,
                               MaterialPageRoute(
                                 builder: (context) => FullScreenImageCasa(
                                    code: visita.nombre,
                                    imageCasa1: visita.imgurl,
                                    visid: visita.visid,
                                    fecha: visita.fecha
                                    ),
                               ),
                             );
                            }catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Hay un error al ver la imagen o no tiene imagen guardada: $e'),
                                   backgroundColor: Colors.red,
                                    ),
                
                                 );
                            }
                           },
                           icon: const Icon(Icons.image, color: Colors.orange, size: 45,)),
                           if(visita.latitud.isNotEmpty)
                             MaterialButton(
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                             color: Colors.blue,
                             onPressed: () async {
                                try {
                                 // Llamamos a la función que maneja la apertura de Google Maps
                                 await openGoogleMaps(context, double.parse(visita.latitud), double.parse(visita.longitud));
                               } catch (e) {
                                 
                               }
                             },
                             child: const Text(
                                'Abrir ubicacion',
                               style: TextStyle(color: Colors.white),
                             ),
                           )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed:  _mostrarAnterior,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white
                            ),
                            child: const Text('Anterior'),
                          ),
                          IconButton(onPressed: ()async{
                            final bool confirmacion = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('¿Estás seguro de eliminar esta imagen?', style: TextStyle(fontSize: 16) ),
                                        content: const Text('Esta acción no se puede deshacer.'),
                                        actions: [
                                TextButton(
                                  onPressed: () {
                                    // Si el usuario confirma, cerrar el cuadro de diálogo y devolver true
                                    Navigator.pop(context, true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                    content: Text('¡Imagen Eliminada!'),
                                    backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                                    ),
                                  );
                                 },
                                  child: const Text('Si, quiero eliminar', style: TextStyle(fontSize: 16)),
                                ),
                                const SizedBox(width: 30,),
                                TextButton(
                                  onPressed: () {
                                    // Si el usuario cancela, cerrar el cuadro de diálogo y devolver false
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          );
                            if (confirmacion == true) {
                            await DBProvider().eliminarvisita(visita.visid);
                            Navigator.pop(context);
                          }
                          }, 
                          icon: const Icon(Icons.delete, color: Colors.red, size: 30,)),
                          ElevatedButton(
                            onPressed: _mostrarSiguiente,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white
                            ),
                            child: const Text('Siguiente'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> openGoogleMaps(BuildContext context, double latitude, double longitude) async {
  final Uri geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
  final Uri fallbackUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

  print("Intentando abrir geo URI: $geoUri");

  try {
    if (await canLaunchUrl(geoUri)) {
      print("Lanzando geo URI...");
      await launchUrl(geoUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(fallbackUrl)) {
      print("geo URI falló, lanzando fallback HTTP...");
      await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se puede lanzar ni geo ni fallback';
    }
  } catch (e) {
    print("Error: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir Google Maps: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
}
class _RespuestaVisitasForm extends StatefulWidget {
  const _RespuestaVisitasForm({super.key});

  @override
  State<_RespuestaVisitasForm> createState() => _RespuestaVisitasFormState();
}

class _RespuestaVisitasFormState extends State<_RespuestaVisitasForm> {
  final TextEditingController comentarioController = TextEditingController();
  final ValueNotifier<DateTime?> proximaFechaSeleccionada = ValueNotifier<DateTime?>(null);

  String? clienteCodigo;

  @override
  void dispose() {
    comentarioController.dispose();
    proximaFechaSeleccionada.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      proximaFechaSeleccionada.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DBProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
        ],
      ),
    );
  }
}
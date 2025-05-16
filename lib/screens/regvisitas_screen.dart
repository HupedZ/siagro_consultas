import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/screens/listaclientes__screen.dart';
import 'package:fz_consultas/widgets/cardreg_container.dart';
import 'package:fz_consultas/widgets/consulta_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class RegistrarVisitasScreen extends StatelessWidget {
  final List<ResultadoCliente> resultados;

  const RegistrarVisitasScreen({super.key, required this.resultados});

  @override
  Widget build(BuildContext context) {
    return _RegistrarVisitasScreenContent();
  }
}
class _RegistrarVisitasScreenContent extends StatelessWidget {
  _RegistrarVisitasScreenContent({super.key});

  final GlobalKey<_RegistrarVisitasFormState> _formKey = GlobalKey<_RegistrarVisitasFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 199, 125),
        title: const Text('Volver'),
      ),
      body: ConsultaBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              CardRegContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Registrar Visita', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    _RegistrarVisitasForm(key: _formKey), // <- Usamos el GlobalKey aquí
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _RegistrarVisitasForm extends StatefulWidget {
  const _RegistrarVisitasForm({super.key});

  @override
  State<_RegistrarVisitasForm> createState() => _RegistrarVisitasFormState();
}

class _RegistrarVisitasFormState extends State<_RegistrarVisitasForm> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController comentarioController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final ValueNotifier<String> tipoSeleccionado = ValueNotifier<String>('Maquinaria');
  final ValueNotifier<DateTime?> proximaFechaSeleccionada = ValueNotifier<DateTime?>(null);

  String? clienteCodigo;
  String? _imagenUrl;
  String? _latitud;
  String? _longitud;

  @override
  void dispose() {
    codigoController.dispose();
    comentarioController.dispose();
    clientController.dispose();
    tipoSeleccionado.dispose();
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
    final loginForm = Provider.of<LoginFormProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 2,
                  controller: clientController,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final texto = clientController.text.trim().toUpperCase();
                  final resultados = await dbProvider.consultarN(context, texto, texto);

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return ListaClientesWidget(
                        resultados: resultados,
                        onClienteSeleccionado: (nombre, codigo) {
                          setState(() {
                            clientController.text = nombre;
                            clienteCodigo = codigo;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                child: const Icon(Icons.search),
              ),
            ]),
          Text('Vendedor: ${loginForm.usuario}',
          style: const TextStyle(
                  fontSize: 20
                ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: tipoSeleccionado,
            builder: (context, value, _) => DropdownButtonFormField<String>(
              value: value,
              items: const [
                DropdownMenuItem(value: 'Maquinaria', child: Text('Maquinaria')),
                DropdownMenuItem(value: 'Repuestos', child: Text('Repuestos')),
                DropdownMenuItem(value: 'Servicios', child: Text('Servicios')),
              ],
              onChanged: (val) => tipoSeleccionado.value = val!,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
          ),
          TextFormField(
            controller: comentarioController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Comentario'),
            maxLength: 250,
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: proximaFechaSeleccionada,
            builder: (context, fecha, _) => Row(
              children: [
                Text(fecha == null
                    ? 'Próxima visita: No tiene'
                    : 'Próxima visita: ${DateFormat('dd-MM-yyyy').format(fecha)}'),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () => _seleccionarFecha(context),
                  child: const Text('Elegir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [  
          IconButton(
          onPressed: () async {
                    final result = await showDialog(
                       context: context,
                        builder: (context) => SimpleDialog(
                         title: const Text('Seleccionar imagen'),
                         children: [
                            SimpleDialogOption(
                             onPressed: () => Navigator.pop(context, ImageSource.gallery),
                             child: const Text('Galería'),
                           ),
                            SimpleDialogOption(
                              onPressed: () => Navigator.pop(context, ImageSource.camera),
                              child: const Text('Cámara'),
                            ),
                          ],
                        ),
                     );
                    if (result != null) {
                      try{
                    final picker = ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(source: result);
                    final imageUrl = await uploadImage(pickedFile);
                    if (imageUrl != null) {
                        setState(() {
                          _imagenUrl = imageUrl;
                        });
                        // Mostrar SnackBar o lo que desees
                      }
                    if (imageUrl != null) {
                      try{
                      // Llamar a la función para actualizar el registro en la base de datos
                    //await DBProvider().actualizarFCasa1(imageUrl, clienteCodigo!,);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                               content: Text('¡Imagen Almacenada correctamente!'),
                               backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                            ),
                          );
                    }catch(e){
                    // ignore: use_build_context_synchronously
                      }
                    }
                    }catch(e){
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                               content: Text('¡Ninguna imagen fue seleccionada! $e'),
                               backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                            ),
                          ); 
                    }
                  }
                  },      
           icon: const Icon(Icons.camera_alt_outlined, size: 45,),
           color: Colors.orange,
           ),
           const SizedBox(width: 40,),
           IconButton(
           onPressed: ()async {
                 try {
                   final position = await _getCurrentLocation();
                    if (position != null) {
                      setState(() {
                       _latitud = position.latitude.toString();
                       _longitud = position.longitude.toString();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                         content: Text('Ubicación almacenada con exito'),
                         backgroundColor: Colors.green,
                       ),
                     );
                   } else {
                     throw 'No se pudo obtener la ubicación';
                   }
                 } catch (e) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al obtener la ubicación: $e'),
                        backgroundColor: Colors.red,
                      ),
                   );
                  }
                },
           icon: const Icon(Icons.location_on, size: 45,),
           color: Colors.orange,
           ),
          ]),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final proxima = proximaFechaSeleccionada.value;

                  if (proxima == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Debe seleccionar la próxima fecha')),
                    );
                    return;
                  }

                  await dbProvider.registrarvisita(
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    codigoController.text,
                    tipoSeleccionado.value.substring(0, 3),
                    comentarioController.text,
                    DateFormat('yyyy-MM-dd').format(proxima),
                    clienteCodigo ?? '',
                    _imagenUrl,
                    _latitud,
                    _longitud,
                  );
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visita registrada'),
                    backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Registrar Visita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
Future<String?> uploadImage(XFile? pickedFile) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwbayvepu/image/upload?upload_preset=raz9skgp');

    final imageUploadRequest = http.MultipartRequest('POST', url );

    final file = await http.MultipartFile.fromPath('file', pickedFile!.path );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      // ignore: avoid_print
      print('algo salio mal');
      // ignore: avoid_print
      print( resp.body );
      return null;
    }

    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];

  }
  Future<Position?> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'El servicio de ubicación está deshabilitado.';
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'El permiso de ubicación fue denegado.';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'El permiso de ubicación está denegado permanentemente.';
  }

  return await Geolocator.getCurrentPosition();
}
}
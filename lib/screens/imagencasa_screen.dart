import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FullScreenImageCasa extends StatelessWidget {
  final String? imageCasa1;
  final String? code;
  final String? visid;
  final String? fecha;

  const FullScreenImageCasa({
    super.key,
    required this.imageCasa1,
    required this.code,
    required this.visid,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        //ChangeNotifierProvider(create: (_) => ConsultaFormProvider(),),
        ChangeNotifierProvider(create: (_) => DBProvider(),)
        
        ],
         // ignore: avoid_types_as_parameter_names              
                    
    child:  Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 199, 125),
        title: const Text('Volver', style: TextStyle(fontSize: 20),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Imagen Registrada en la visita realizada a $code en la fecha $fecha',
               style: const TextStyle(
                 fontSize: 20,
                  fontWeight: FontWeight.bold,
                 color: Colors.black87,
               ),
              ),
           ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: imageCasa1 != null && imageCasa1!.isNotEmpty
                  ? Column(
                    children: [
                    InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 5.0,
                      child: Image.network(imageCasa1!, fit: BoxFit.contain),
                    ),
                    IconButton(
                        onPressed: ()async{
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
    
                          // Si el usuario confirmó, eliminar la imagen
                          if (confirmacion == true) {
                            await DBProvider().eliminarImagenCasa1(visid!);
                          }
                        },
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    )
                    ]
                    )
                  : IconButton(
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
                      try{
                      // Llamar a la función para actualizar el registro en la base de datos
                   // await DBProvider().actualizarFCasa1(imageUrl, code!);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                               content: Text('¡Imagen subida correctamente!'),
                               backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                            ),
                          );
                    }catch(e){
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                               content: Text('¡Error al subir la imagen! $e'),
                               backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                            ),
                          );
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
                  icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.redAccent ),
                ),
            ),
          ],
        ),
      ),
    ),
    );
  }
  Future<String?> uploadImage(XFile? pickedFile) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dxtncec6a/image/upload?upload_preset=pgqwkshy');

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
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fz_consultas/screens/imagen.dart';
import 'package:fz_consultas/ui/inputc_decorations.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/widgets/cardrespuesta_container.dart';
import 'package:fz_consultas/widgets/respuesta_background.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';


class RespuestaForm extends StatefulWidget {
  final List<ResultadoBusqueda> resultados;
  final String busquedaText;
  
  const RespuestaForm({super.key, required this.resultados, required int currentIndex, required this.busquedaText});

  
  @override
  
  // ignore: library_private_types_in_public_api
  _RespuestaFormState createState() => _RespuestaFormState();
}

class _RespuestaFormState extends State<RespuestaForm> {
  int currentIndex = 0;
  String nuevoCodigoBarra = '';
  
  @override
  Widget build(BuildContext context) {
    final consultaForm = Provider.of<ConsultaFormProvider>(context);
    
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 251, 215, 168),
        title: const Text('Realizar otra consulta'),
      ),
      body: RespuestaBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),
              CardRContainer(
                child: Column(
                  children: [
                      MultiProvider(
                        providers: [
                        ChangeNotifierProvider(create: (_) => ConsultaFormProvider(),),
                        ChangeNotifierProvider(create: (_) => DBProvider(),)
                        
                        ],
                        // ignore: avoid_types_as_parameter_names
                        child: _RespuestaForm(resultados: const [], onIndexChanged: ( int) {  }, currentIndex: 0, onCodigoBUpdated: (String ) {  }),
                  
                    
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                           //Text('Busqueda:${widget.busquedaText}', style: TextStyle(fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [

                     Text('Busqueda:${widget.busquedaText}', style: const TextStyle(fontSize: 20),),
                     const SizedBox(width: 20),
                     CupertinoSwitch(
                    value: consultaForm.switchValuer,
                    activeColor: const Color.fromARGB(255, 3, 213, 35),
                     onChanged: (bool? value2) {
                     consultaForm.setSwitchValuer(value2 ?? false);
                     },
                     ),
                      ]
                    ),
                      ]
                    ),
                    const SizedBox(height: 10,),
                    _RespuestaForm(resultados: widget.resultados, currentIndex: currentIndex, onIndexChanged: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                      });
                    },
                    onCodigoBUpdated: (newCodigoB) {
                       // Actualiza el código de barras en el resultado actual
                        setState(() {
                          widget.resultados[currentIndex].codigoB = newCodigoB;
                        });
                      },
                      ),
                    const SizedBox(height: 10,),
                    Text(
                      '${currentIndex + 1}/${widget.resultados.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    
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

class _RespuestaForm extends StatelessWidget {
  final List<ResultadoBusqueda> resultados;
  final int currentIndex;
  final Function(int) onIndexChanged;
  final consultaForm = Provider.of<ConsultaFormProvider>;
  final Function(String) onCodigoBUpdated;

  

   _RespuestaForm({required this.resultados, required this.currentIndex, required this.onIndexChanged, required this.onCodigoBUpdated});
  
  @override
  Widget build(BuildContext context) {
    final consultaForm = Provider.of<ConsultaFormProvider>(context);
    final dbProvider = Provider.of<DBProvider>(context);
    String codigoBactualizado = '';
    String codigoNull = 'No tiene';
    
    return Column(
      children: [
      
     if (resultados.isNotEmpty) 
            CardRContainer(
            child: Column(
              children: [
                if(resultados[currentIndex].imgurl != null)
              Consumer<ConsultaFormProvider>(
                    builder: (context, imageProvider, _) {
                      return imageProvider.showImage
                           ? GestureDetector(
                              onTap: () {
                                // Navega a una nueva pantalla para mostrar la imagen en pantalla completa
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImage(imageUrl: resultados[currentIndex].imgurl, code: resultados[currentIndex].code),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                   Image.network(
                                      resultados[currentIndex].imgurl!,
                                      width: 300,
                                      height: 300,
                                    ),
                                  
                                IconButton(
                                  onPressed: () async {
                                    // Mostrar un cuadro de diálogo de confirmación
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
                            await DBProvider().eliminarImagen(resultados[currentIndex].code);
                          }
                        },
                        icon: const Icon(Icons.delete, size: 40, color: Colors.red),
                      ),
                            ]
                          ))
                          :   IconButton(
                              onPressed: () {
                                consultaForm.toggleImageVisibility();
                              },
                              icon: const Icon( Icons.remove_red_eye_outlined, size: 40, color: Colors.orange ),
                            );
                    },
                  ),
                if(resultados[currentIndex].imgurl == null)
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
                      try{
                      // Llamar a la función para actualizar el registro en la base de datos
                    await DBProvider().actualizarRegistro(imageUrl, resultados[currentIndex].code);
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
                  icon: const Icon( Icons.camera_alt_outlined, size: 40, color: Colors.orange ),
                ),
    
                const Divider(),
                ListTile(
                  title: Text(
                    'Codigo: ${resultados[currentIndex].code}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Referencia: ${resultados[currentIndex].refe}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(),
                Row(
                children: [
                const SizedBox(width: 16,),
                Text(
                    'C.Barra: ${resultados[currentIndex].codigoB ?? 'No tiene'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                SizedBox(
                  width: resultados[currentIndex].codigoB != null ? 11 : 130,
                  ),
                IconButton(
                  onPressed: () async {
                    await showModalBottomSheet(context: context,
                    backgroundColor: const Color.fromARGB(255, 240, 231, 220),
                    builder: (BuildContext context){
                      return SizedBox(
                        
                        height: 250,
                        child: Column(
                            children: [
                              
                              const Text('Actualizar Codigo de Barra', style: TextStyle(fontSize: 20),),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              IconButton(
                                onPressed: ()async{
                                  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                                                  '#ff6666', 
                                                                                  'Cancelar', 
                                                                                  true, 
                                                                                  ScanMode.BARCODE);
                                    if(barcodeScanRes == -1){
                                      Get.snackbar('Cancelado', 'Lectura Cancelada');
                                    }else{
                                      
                                       codigoBactualizado = processBarcode(barcodeScanRes);
                                       
                                      
                                      try{
                                        
                                     final bool confirmacion = await showDialog(
                                                    context: context,
                                                   builder: (context) => AlertDialog(
                                                     title: const Text('¿Estás seguro de actualizar el Codigo de Barra con el siguiente codigo?', style: TextStyle(fontSize: 16) ),
                                                     content: Text(codigoBactualizado),
                                                     actions: [
                                              TextButton(
                                               onPressed: () {
                                                  // Si el usuario confirma, cerrar el cuadro de diálogo y devolver true
                                                  Navigator.pop(context, true);      
                                              },
                                                child: const Text('Si, quiero actualizar', style: TextStyle(fontSize: 16)),
                                               ),
                                              const SizedBox(width: 5,),
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
                                          await dbProvider.actualizarCodigoB(codigoBactualizado, resultados[currentIndex].code);
                                          onCodigoBUpdated(codigoBactualizado);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                 content: Text('¡Codigo de Barra Actualizado!'),
                                                 backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                                                 ),
                                                 );
                                        }
                                      }catch(e){
                                       print(e);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text('No pude actualizar el codigo de barra: $e'),
                                     backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                                     ),
                                      );
                                      }
                                    }
      
                                }
                                , icon: const Icon(Icons.barcode_reader, color:Colors.orange)),
                                const SizedBox(width: 50,),
                                IconButton(
                                  onPressed: () async {
                                    try{
                                        
                                     final bool confirmacion = await showDialog(
                                                    context: context,
                                                   builder: (context) => AlertDialog(
                                                     title: const Text('¿Estás seguro de querer eliminar el codigo de barra?', style: TextStyle(fontSize: 16) ),
                                                     content: Text(codigoBactualizado),
                                                     actions: [
                                              TextButton(
                                               onPressed: () {
                                                  // Si el usuario confirma, cerrar el cuadro de diálogo y devolver true
                                                  Navigator.pop(context, true);      
                                              },
                                                child: const Text('Si, quiero eliminar', style: TextStyle(fontSize: 16)),
                                               ),
                                              const SizedBox(width: 5,),
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
                                          await dbProvider.eliminarCodigoB(resultados[currentIndex].code);
                                          onCodigoBUpdated(codigoBactualizado = codigoNull);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                 content: Text('¡Codigo de Barra Eliminado!'),
                                                 backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                                                 ),
                                                 );
                                        }
                                      }catch(e){
                                       print(e);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text('No pude eliminar el codigo de barra: $e'),
                                     backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                                     ),
                                      );
                                      }
                                  },
                                   icon: const Icon(Icons.delete, color:Colors.red))
                                ]
                              ),
                              Padding(
                              padding: const EdgeInsets.symmetric( horizontal: 80 ),
                              child:
                              TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                                decoration: InputcDecorations.consultaInputDecoration(
                                hintText: '',
                                labelText: 'Codigo de Barra',
                                prefixIcon: Icons.edit
                              ),
                              onChanged: ( value ) => consultaForm.nCodigoB = value,              
                              ),
                              ),
                              
                              const SizedBox(height: 20,),
                              ElevatedButton(
                                
                                onPressed: ()async{
                                  if(consultaForm.nCodigoB.isNotEmpty){
                                    try{
                                    onCodigoBUpdated(consultaForm.nCodigoB);
                                    await dbProvider.actualizarCodigoB(consultaForm.nCodigoB, resultados[currentIndex].code);
                                    Navigator.pop(context);
                                     ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('¡El Codigo de Barra fue actualizado correctamente!'),
                                          backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                                        ),
                                      ); 
                                    }catch(e){
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('¡No se pudo actualizar el Codigo de Barra! $e'),
                                          backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                                        ),
                                      ); 
                                    }
                                }
                                },
                                 style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent), // Cambia este color al que desees
                                ),
                                 child: const Text('Actualizar',)
                                )
                                
                            ],
                          ),
                        );
                      
                    }
                    );
                    
    
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange,)
                  ),
                ]
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    resultados[currentIndex].articulo,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Deposito ${resultados[currentIndex].stockd}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                const SizedBox(width: 16,),
                
                Text(
                    'Stock: ${resultados[currentIndex].stock}',
                    style: const TextStyle(fontSize: 16),
                  ),
                SizedBox(
                  width: resultados[currentIndex].stock < 99 ? 180 : 165,
                  ),
                IconButton(
                  onPressed: () async {
                    await showModalBottomSheet(context: context,
                    backgroundColor: const Color.fromARGB(255, 240, 231, 220),
                    builder: (BuildContext context){
                      return Container(
                      height: 250,
                      child:Form(
                        key: consultaForm.cformKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //height: 250,
                        child: Column(
                            children: [
                              
                              const Text('Levantamiento de Inventario', style: TextStyle(fontSize: 20),),
                              const SizedBox(height: 20,),
                              Text('Stock actual: ${resultados[currentIndex].stock}', style: const TextStyle(fontSize: 25),),
                              const SizedBox(height: 5,),
                              Padding(
                              padding: const EdgeInsets.symmetric( horizontal: 90 ),
                              child:
                              TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.number,
                                decoration: InputcDecorations.consultaInputDecoration(
                                hintText: '',
                                labelText: 'Conteo',
                                prefixIcon: Icons.edit
                              ),
                              onChanged: ( value ) => consultaForm.conteo = value,    
                              validator: ( value ) {
    
                               return ( value != null && value.isNotEmpty ) 
                                  ? null
                                  : 'Debes ingresar un valor';                                    
                  
                               },         
                              ),
                              ),
                              const SizedBox(height: 20,),
                              ElevatedButton(
                                
                                onPressed: ()async{
    
                                  if(!consultaForm.isValidForm()) return;
                                    try{
                                      final bool confirmacion = await showDialog(
                                                    context: context,
                                                   builder: (context) => AlertDialog(
                                                     title: const Text('¿Estas seguro de Levantar el inventario con el siguiente conteo?', style: TextStyle(fontSize: 16) ),
                                                     content: Text('                  ${consultaForm.conteo}', style: const TextStyle(fontSize: 24)),
                                                     actions: [
                                              TextButton(
                                               onPressed: () {
                                                  // Si el usuario confirma, cerrar el cuadro de diálogo y devolver true
                                                  Navigator.pop(context, true);
                                              },
                                                child: const Text('Si, quiero actualizar', style: TextStyle(fontSize: 16)),
                                               ),
                                              const SizedBox(width: 5,),
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
                                          await dbProvider.actualizarinventario(consultaForm.conteo, resultados[currentIndex].code, resultados[currentIndex].stockd, resultados[currentIndex].stock, consultaForm.time);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                 content: Text('¡Levantamiento realizado correctamente!'),
                                                 backgroundColor: Colors.green, // Puedes personalizar el color de fondo.
                                                 ),
                                                 );
                                        }
                                        
                                    }catch(e){
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('¡No pude realizar el levantamiento de inventario! $e'),
                                          backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
                                        ),
                                      ); 
                                    }
                                
                                },
                                 style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent), // Cambia este color al que desees
                                ),
                                 child: const Text('Actualizar',)
                                )
                              
                            ],
                          ),
                      
                      ));
                      
                    }
                    );
                    
    
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange,)
                  )
                  ]
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Ubicación: ${resultados[currentIndex].ubica}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(),
                Visibility(
                  visible: (consultaForm.switchValuer),
                  child:   
                  ListTile(
                    title:
                    
                     Text( 
                     'Precio de Costo: ${resultados[currentIndex].precioc}',
                      style: const TextStyle(fontSize: 16),
                      
                    ),
                    
                  ),
                  
                ),
                const Divider(),
                
                ListTile(
                  title: Text(
                    'Precio de Venta: ${resultados[currentIndex].precio}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 20),
    
        Visibility(
          visible: resultados.length > 1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final newIndex = (currentIndex - 1) % resultados.length;
                        onIndexChanged(newIndex < 0 ? resultados.length - 1 : newIndex);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orangeAccent,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onIndexChanged((currentIndex + 1) % resultados.length);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orangeAccent,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Siguiente'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        
      ],
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
  String processBarcode(String barcode) {
  if (barcode.startsWith(']C1')) {
    return barcode.substring(3);
  }
  return barcode;
}
}
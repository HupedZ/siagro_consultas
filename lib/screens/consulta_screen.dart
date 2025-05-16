import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/ui/inputc_decorations.dart';
import 'package:fz_consultas/widgets/cardconsulta_container.dart';
import 'package:fz_consultas/widgets/consulta_background.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ConsultaScreen extends StatelessWidget {
   
  const ConsultaScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 199, 125),
        title: Text('Volver'),
      ),
      body: ConsultaBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height:200),


              CardCContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text('Consulta', style: Theme.of(context).textTheme.headlineMedium,),
                    const SizedBox(height: 10,),

                    MultiProvider(
                        providers: [
                        ChangeNotifierProvider(create: (_) => DBProvider(),),
                        ChangeNotifierProvider(create: (_) => ConsultaFormProvider(),),
                        ChangeNotifierProvider(create: (_) => LoginFormProvider(), ),
                        ],
                        child: _ConsultaForm(),
                  
                    
                    )   
                                     
                  ]
                  
                )
              ),
            ],
          ),
        ),
        ),
    );
  }
}
// ignore: must_be_immutable
class _ConsultaForm extends StatelessWidget  {
  String? valorDelTextFormField;
  String? dropdownValue;
  
  
  _ConsultaForm() {
    Get.put(ConsultaFormProvider());
    opcionSeleccionada = 'Referencia';
  }
  String codigoBarra = '';

  late String opcionSeleccionada; // Inicialización de opcionSeleccionada
  
  @override
    Widget build(BuildContext context) {
    final consultaForm = Provider.of<ConsultaFormProvider>(context);
    final dbProvider = Provider.of<DBProvider>(context);
    dropdownValue ??= consultaForm.opcionSeleccionada;


    return Form(
      key: consultaForm.cformKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [ 
        IconButton (
               onPressed: () async{    
                  await escanearCodigosdeBarra(context);
                  
               },
                icon: Icon(Icons.barcode_reader, color:Colors.orange)
              
            ),
          // DropdownButton para seleccionar la opción
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputcDecorations.consultaInputDecoration(
              hintText: '',
              labelText: _getLabelText(consultaForm.opcionSeleccionada),
              prefixIcon: Icons.search
            ),
            onChanged: ( value ) {
              switch (consultaForm.opcionSeleccionada) {
               case 'Codigo':
                 consultaForm.codigo = value;
                 break;
               case 'Referencia':
                  consultaForm.referencia = value;
                 break;
                case 'Ubicacion':
                  consultaForm.ubicacion = value;
                  break;
                default:
                  // Si no hay ninguna opción seleccionada, no hacer nada
                 break;
             }
             valorDelTextFormField = value;
            },
            validator: ( value ) {
              return ( value != null && value.isNotEmpty ) 
                ? null
                : '';                                    
            },
          ),
          const SizedBox(height: 10,),
          const Text('Opciones de busqueda:'),
          DropdownButton<String>(
            
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.orange),
            onChanged: (String? newValue) {
              consultaForm.setOpcionSeleccionada(newValue!);
              dropdownValue = newValue;
            },
            items: <String>['Codigo', 'Referencia', 'Ubicacion',]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 10,),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.orangeAccent,
            onPressed: consultaForm.isLoading ? null : () async {
              if (!consultaForm.isValidForm()) return ;
              FocusScope.of(context).unfocus();

              // Verifica si se ha seleccionado una opción
              if (consultaForm.opcionSeleccionada.isNotEmpty) {
                // Verifica qué opción se ha seleccionado y ejecuta la función correspondiente
                switch (consultaForm.opcionSeleccionada) {
                  case 'Codigo':
                    try {
                      print(consultaForm.codigo);
                      print(valorDelTextFormField);
                      await dbProvider.consultarC(context, consultaForm.codigo, valorDelTextFormField!);
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡Hubo un error al consultar por código: $e!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    break;
                  case 'Referencia':
                    try {
                      await dbProvider.consultarR(context, consultaForm.referencia.toUpperCase(), valorDelTextFormField!);
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡Hubo un error al consultar por referencia: $e!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    break;
                  case 'Ubicacion':
                    try {
                      await dbProvider.consultarU(context, consultaForm.ubicacion, valorDelTextFormField!);
                    } catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('¡Hubo un error al consultar por ubicacion: $e!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    break;
                  default:
                    break;
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('¡Debe seleccionar una opción primero!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                consultaForm.isLoading ? 'Espere' : 'Buscar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String _getLabelText(String opcionSeleccionada) {
    switch (opcionSeleccionada) {
      case 'Codigo':
        return 'Buscar por Código';
      case 'Referencia':
        return 'Buscar por Referencia';
      case 'Ubicacion':
        return 'Buscar por Ubicación';
      default:
        return 'Buscar';
    }
  }
    Future<void> escanearCodigosdeBarra(BuildContext context)async{
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                    '#ff6666', 
                                                    'Cancelar', 
                                                    true, 
                                                    ScanMode.BARCODE);
      if(barcodeScanRes == -1){
        Get.snackbar('Cancelado', 'Lectura Cancelada');
      }else{
        codigoBarra = processBarcode(barcodeScanRes);
        try{
        DBProvider dbProvider = DBProvider();
        await dbProvider.consultarB(context, codigoBarra, codigoBarra); 
        }catch(e){
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text('No Pude consultar por codigo de barra: $e'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
        }
      }
      
  }
  String processBarcode(String barcode) {
  if (barcode.startsWith(']C1')) {
    return barcode.substring(3);
  }
  return barcode;
}
}


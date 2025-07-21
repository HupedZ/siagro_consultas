import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/screens/respuesta_screen.dart';
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
class _ConsultaForm extends StatefulWidget {
  const _ConsultaForm({super.key});

  @override
  State<_ConsultaForm> createState() => _ConsultaFormState();
}

class _ConsultaFormState extends State<_ConsultaForm> {
  String? valorDelTextFormField;
  String dropdownValue = 'Referencia';
  String codigoBarra = '';
  List<ResultadoBusqueda> sugerencias = [];
  bool isLoading = false;
  TextEditingController _controller = TextEditingController();
  int _queryCounter = 0;

  @override
  void initState() {
    super.initState();
    Get.put(ConsultaFormProvider());
  }
  void dispose() {
  _controller.dispose();
  super.dispose();
  }

  void _onReferenciaChanged(String value, DBProvider dbProvider) async {
  if (value.trim().isEmpty) return;

  setState(() {
    isLoading = true;
  });

  final currentQuery = ++_queryCounter;

  final resultados =
      await dbProvider.obtenerSugerenciasPorReferencia(value.toUpperCase());

  // Sólo si no hubo otra consulta después, actualiza la lista
  if (currentQuery == _queryCounter) {
    setState(() {
      sugerencias = resultados;
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final consultaForm = Provider.of<ConsultaFormProvider>(context);
    final dbProvider = Provider.of<DBProvider>(context);
    

    return Form(
      key: consultaForm.cformKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              await _escanearCodigosDeBarra(context);
            },
            icon: const Icon(Icons.barcode_reader, color: Colors.orange),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: _getLabelText(dropdownValue),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                   valorDelTextFormField = value;

                    if (value.trim().isEmpty) {
                      sugerencias.clear();
                      isLoading = false;
                    } else if (dropdownValue == 'Referencia') {
                      _onReferenciaChanged(value, dbProvider);
                    }

                    switch (dropdownValue) {
                      case 'Codigo':
                        consultaForm.codigo = value;
                        break;
                      case 'Ubicacion':
                        consultaForm.ubicacion = value;
                        break;
                    }
                  });
                },
                autovalidateMode: AutovalidateMode.disabled, // quita la validación inmediata
              ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (sugerencias.isNotEmpty && dropdownValue == 'Referencia')
                  Container(
                    margin: const EdgeInsets.only(top: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                      border: Border.all(color: Colors.orange, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: sugerencias.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        final item = sugerencias[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            item.articulo,
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.refe,
                                  style: const TextStyle(fontSize: 12)),
                              Text('D: ${item.stockd}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RespuestaForm(
                                  resultados: [item],
                                  currentIndex: 0,
                                  busquedaText: valorDelTextFormField ?? '',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('Opciones de búsqueda:'),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.orange),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                sugerencias.clear();
              });
              consultaForm.setOpcionSeleccionada(newValue!);
            },
            items: <String>[
              'Codigo',
              'Referencia',
              'Ubicacion',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.orangeAccent,
            onPressed: consultaForm.isLoading
                ? null
                : () async {
                  if ((_controller.text).trim().isEmpty) {
                    _showError(context, 'El campo no puede estar vacío');
                    return;
                  }
                    if (!consultaForm.isValidForm()) return;
                    FocusScope.of(context).unfocus();

                    switch (dropdownValue) {
                      case 'Codigo':
                        try {
                          await dbProvider.consultarC(
                              context,
                              consultaForm.codigo,
                              valorDelTextFormField ?? '');
                        } catch (e) {
                          _showError(
                              context, 'Hubo un error al consultar por código: $e');
                        }
                        break;
                      case 'Referencia':
                        try {
                          await dbProvider.consultarR(
                              context,
                              consultaForm.referencia.toUpperCase(),
                              valorDelTextFormField ?? '');
                        } catch (e) {
                          _showError(context,
                              'Hubo un error al consultar por referencia: $e');
                        }
                        break;
                      case 'Ubicacion':
                        try {
                          await dbProvider.consultarU(
                              context,
                              consultaForm.ubicacion,
                              valorDelTextFormField ?? '');
                        } catch (e) {
                          _showError(context,
                              'Hubo un error al consultar por ubicación: $e');
                        }
                        break;
                      default:
                        break;
                    }
                  },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
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

  Future<void> _escanearCodigosDeBarra(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancelar', true, ScanMode.BARCODE);

    if (barcodeScanRes == '-1') {
      Get.snackbar('Cancelado', 'Lectura Cancelada');
    } else {
      codigoBarra = _processBarcode(barcodeScanRes);
      try {
        DBProvider dbProvider = DBProvider();
        await dbProvider.consultarB(context, codigoBarra, codigoBarra);
      } catch (e) {
        _showError(context, 'No pude consultar por código de barra: $e');
      }
    }
  }

  String _processBarcode(String barcode) {
    if (barcode.startsWith(']C1')) {
      return barcode.substring(3);
    }
    return barcode;
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/screens/listaclientes__screen.dart';
import 'package:fz_consultas/screens/listavisitas_screen.dart';
import 'package:fz_consultas/widgets/cardreg_container.dart';
import 'package:fz_consultas/widgets/consulta_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class ConsultarVisitasScreen extends StatelessWidget {
  final List<ResultadoListaVisitas> resultados;
  

  const ConsultarVisitasScreen({super.key, required this.resultados});

  @override
  Widget build(BuildContext context) {
    return _ConsultarVisitasScreenContent();
  }
}
class _ConsultarVisitasScreenContent extends StatelessWidget {
  _ConsultarVisitasScreenContent({super.key});

  final GlobalKey<_RegistrarVisitasFormState> _formKey = GlobalKey<_RegistrarVisitasFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 199, 125),
        title: const Text('Volver'),
      ),
      body: ConsultaBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 200),
              CardRegContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Consultar Visita', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    _ConsultarVisitasForm(key: _formKey), // <- Usamos el GlobalKey aquí
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
class _ConsultarVisitasForm extends StatefulWidget {
  const _ConsultarVisitasForm({super.key});

  @override
  State<_ConsultarVisitasForm> createState() => _RegistrarVisitasFormState();
}

class _RegistrarVisitasFormState extends State<_ConsultarVisitasForm> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController clientController = TextEditingController();

  String? clienteCodigo;

  @override
  void dispose() {
    clientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DBProvider>(context);

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
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {

                  if (clienteCodigo == null) {
                    await dbProvider.consultarListaVisitaB(
                    context,
                    clienteCodigo ?? '',
                  );
                  }else{
                  await dbProvider.consultarListaVisita(
                    context,
                    clienteCodigo ?? '',
                  );
                  }
                },
                child: const Text('Consultar Visita'),
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
}
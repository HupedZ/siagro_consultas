import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/consulta_form_provider.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/widgets/cardconsulta_container.dart';
import 'package:fz_consultas/widgets/consulta_background.dart';
import 'package:provider/provider.dart';

class VisitasScreen extends StatelessWidget {
   
  const VisitasScreen({super.key});
  
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
                    Text('Elija una Opción', style: Theme.of(context).textTheme.headlineMedium,),
                    const SizedBox(height: 10,),

                    MultiProvider(
                        providers: [
                        ChangeNotifierProvider(create: (_) => DBProvider(),),
                        ChangeNotifierProvider(create: (_) => ConsultaFormProvider(),),
                        ChangeNotifierProvider(create: (_) => LoginFormProvider(), ),
                        ],
                        child: _VisitasForm(),
                  
                    
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
class _VisitasForm extends StatelessWidget {
  const _VisitasForm({super.key});

  @override
  Widget build(BuildContext context) {
    //final consultaForm = Provider.of<ConsultaFormProvider>(context);
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 20),
          MaterialButton(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           color: Colors.orangeAccent,
           onPressed: (){
            Navigator.pushNamed(context, 'regvisitas');
           },
           child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: const Text(
                'Registrar Visita',
                style: const TextStyle(color: Colors.white),
                ),
                
            )),
            const SizedBox(height: 30),
            MaterialButton(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
             color: Colors.orangeAccent,
             onPressed: (){
              Navigator.pushNamed(context, 'convisitas');
             },
             child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: const Text(
                  'Consultar',
                  style: const TextStyle(color: Colors.white),
                  ),
                
            ))
        ],
      )
    );
  }
}
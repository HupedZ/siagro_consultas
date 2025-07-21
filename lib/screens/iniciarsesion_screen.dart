import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';
//import 'package:fz_consultas/postgre/conection_database.dart';
import 'package:fz_consultas/providers/login_form_provider.dart';
import 'package:fz_consultas/screens/screens.dart';
import 'package:fz_consultas/ui/input_decorations.dart';
import 'package:fz_consultas/widgets/widgets.dart';
//import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';

class IniciarsesionScreen extends StatelessWidget {
  const IniciarsesionScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height:240),

              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text('Iniciar Sesión', style: Theme.of(context).textTheme.headlineMedium,),
                    const SizedBox(height: 30,),
                    _LoginForm()
                                        
                  ]
                  
                )
              ),
              

            ],
          ),
        ),
      )       
    );
    
  }
}

class _LoginForm extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    DBProvider dbProvider = Provider.of<DBProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            decoration: InputDecorations.authInputDecoration(
              hintText: '',
              labelText: 'Numero de Vendedor',
              prefixIcon: Icons.person
            ),
            onChanged: ( value ) => loginForm.usuario = value,
            validator: ( value ) {
    
                  return ( value != null && value.isNotEmpty ) 
                    ? null
                    : 'El numero de vendedor es obligatorio';                                    
                  
              },
    
          ),
    
          const SizedBox(height: 30,),
    
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecorations.authInputDecoration(
              hintText: '****',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock,
            ),
            onChanged: ( value ) => loginForm.password = value,
            validator: ( value ) {
    
                  return ( value != null && value.trim().length >= 2 ) 
                    ? null
                    : 'La contraseña es obligatoria';                                    
                  
              },
          ),
          
          const SizedBox(height: 30,),
    
          MaterialButton(             
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.orangeAccent,
            onPressed: loginForm.isLoading ? null : () async {
              if (!loginForm.isValidForm()) return ;
              loginForm.isLoading = false;       
              await dbProvider.iniciar(context, loginForm.usuario, loginForm.password);             
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading
                  ? 'Espere'
                  : 'Ingresar',
                style: const TextStyle(color: Colors.white),
                ),
                
            ) 
            )
      ],),
    );
    
  }
}

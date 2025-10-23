import 'package:flutter/material.dart';
import 'package:fz_consultas/widgets/seleccionar_background.dart';

class SeleccionarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 229, 199),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 199, 125),
        centerTitle: true,
        title: Text('Seleccione una Ruta'),
      ),
      body: AuthSBackground(
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Primer botón
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'consulta');
                },
                child: Container(
                  width: 400, // Ancho del botón
                  height: 200, // Alto del botón
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                          'assets/deposito2.jpg'), // Imagen de fondo
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black45
                            .withOpacity(0.3), // Aplica un filtro oscuro
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius:
                        BorderRadius.circular(10), // Bordes redondeados
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12, // Color de la sombra
                        offset: Offset(0, 6), // Desplazamiento de la sombra
                        blurRadius: 10, // Radio de desenfoque
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white, // Borde blanco
                      width: 3, // Ancho del borde blanco
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Artículos',
                    style: TextStyle(
                      color: Colors.white, // Color del texto
                      fontSize: 24, // Tamaño del texto
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre botones

              // Segundo botón
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'visitas');
                },
                child: Container(
                  width: 400,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/clientes2.jpg'), // Imagen de fondo
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black45
                            .withOpacity(0.3), // Aplica un filtro oscuro
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 6),
                        blurRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Visitas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

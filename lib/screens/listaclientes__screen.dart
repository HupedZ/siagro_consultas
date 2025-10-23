import 'package:flutter/material.dart';
import 'package:fz_consultas/postgre/conection_database.dart';

class ListaClientesWidget extends StatelessWidget {
  final List<ResultadoCliente> resultados;
  final Function(String nombre, String codigo) onClienteSeleccionado;

  const ListaClientesWidget({
    Key? key,
    required this.resultados,
    required this.onClienteSeleccionado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ResultadoCliente> clientesOrdenados = List.from(resultados)
      ..sort((a, b) => int.parse(a.code).compareTo(int.parse(b.code)));

    return Container(
      height: 400,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Text(
            'Seleccioná un cliente',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: clientesOrdenados.length,
              itemBuilder: (context, index) {
                final cliente = clientesOrdenados[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  child: InkWell(
                    onTap: () {
                      onClienteSeleccionado(cliente.nombre, cliente.code);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 254, 213, 169),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${cliente.code} - ${cliente.nombre}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

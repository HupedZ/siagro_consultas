import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fz_consultas/screens/bienvenida_screen.dart';
import 'package:fz_consultas/screens/listavisitas_screen.dart';
import 'package:fz_consultas/screens/regvisitas_screen.dart';
import 'package:fz_consultas/screens/respuesta_screen.dart';
import 'package:fz_consultas/screens/respuestavisitas_screen.dart';
import 'package:postgres/postgres.dart';

class CodigoParaImagen { 
  final String codei;


  CodigoParaImagen({
    required this.codei,

  });
}
class ResultadoListaVisitas{
  final String code;
  final String vendedor;
  final String nombre;
  final String fecha;
  final String tipo;
  final String estado;
  final String visid;
  final String? comment;



  ResultadoListaVisitas({
    required this.nombre,
    required this.vendedor,
    required this.code,
    required this.fecha,
    required this.tipo,
    required this.estado,
    required this.visid,
    required this.comment,

  });
}
class ResultadoVisitas{
  final String visid;
  final String code;
  final String vendedor;
  final String nombre;
  final String fecha;
  final String proxfecha;
  final String tipo;
  final String coment;
  final String imgurl;
  final String latitud;
  final String longitud;
  final String? estado;



  ResultadoVisitas({
    required this.nombre,
    required this.vendedor,
    required this.code,
    required this.visid,
    required this.fecha,
    required this.proxfecha,
    required this.coment,
    required this.imgurl,
    required this.tipo,
    required this.latitud,
    required this.longitud,
    required this.estado,

  });
}

class ResultadoCliente { 
  final String code;
  final String nombre;
  final String telefo;



  ResultadoCliente({
    required this.nombre,
    required this.code,
    required this.telefo,

  });
}

class ResultadoBusqueda { 
  final String code;
  final String refe;
  final String articulo;
  double stock;
  final int stockd;
  final double precioc;
  final double precio;
  final String ubica;
  final String? imgurl;
  String? codigoB;
  String? codigoBactualizado;


  ResultadoBusqueda({
    required this.ubica,
    required this.code,
    required this.refe,
    required this.articulo,
    required this.stockd,
    required this.stock,
    required this.precioc,
    required this.precio,
    required this.imgurl,
    required this.codigoB,
  });
}

class DBProvider extends ChangeNotifier{
  /*bool? _completed;
  final Completer<void> _primaryCompleter = Completer<void>();
  Completer<void>? _secondaryCompleter;*/
  
  
  Future<void> iniciar(BuildContext context, String usuario, String password) async {
    final conn = await _connect();

    try {
      await conn.open();
      final results1 = await conn.query(
        'SELECT * FROM vendedor WHERE vdd_codigo = @nombre AND vdd_clave = @contrasena',
        substitutionValues: {'nombre': usuario, 'contrasena': password},
      );

      if (results1.isNotEmpty) {
        final username = (results1[0][1] as String).trim(); // Asume que el nombre está en la segunda columna

        // Navegar a la pantalla de bienvenida
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen(username: username)),
        );
      } else {
        // Mostrar un mensaje de error si la autenticación falla
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Codigo de Vendedor o Contraseña incorrectas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      await conn.close();
      notifyListeners();
    }
  }

Future<List<ResultadoBusqueda>> consultarR(BuildContext context, String referencia, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];

    try {
      await conn.open();

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_barra LIKE @ref',
        substitutionValues: {'ref': '%$referencia%'},
      );


      for (var row in results) {
      resultados.add(ResultadoBusqueda(
      code: row[0] as String,
      refe: row[2] as String,
      articulo: row[1] as String,
      stock: double.parse(row[6] as String),
      stockd: int.parse(row[7] as String),
      precioc: double.parse(row[3] as String),  // Convertir a double
      precio: double.parse(row[4] as String), // Convertir a double
      ubica: row[8] as String,
      imgurl: row[9] as String?,
      codigoB: row[10]as String?
      ));
 }
      

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Referencia Invalida!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

    
  

Future<List<ResultadoBusqueda>> consultarC(BuildContext context, String codigo, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_codigo = @codigo',
        substitutionValues: {'codigo': codigo},
      );

      

      for (var row in results) {
      resultados.add(ResultadoBusqueda(
      code: row[0] as String,
      refe: row[2] as String,
      articulo: row[1] as String,
      stock: double.parse(row[6] as String),
      stockd: int.parse(row[7] as String),
      precioc: double.parse(row[3] as String),  // Convertir a double
      precio: double.parse(row[4] as String), // Convertir a double
      ubica: row[8] as String,
      imgurl: row[9] as String?,
      codigoB: row[10]as String?
      ));
      
 }

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Codigo Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

Future<List<ResultadoBusqueda>> consultarU(BuildContext context, String ubicacion, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_ubica = @ubicacion',
        substitutionValues: {'ubicacion': ubicacion},
      );

      

      for (var row in results) {
      resultados.add(ResultadoBusqueda(
      code: row[0] as String,
      refe: row[2] as String,
      articulo: row[1] as String,
      stock: double.parse(row[6] as String),
      stockd: int.parse(row[7] as String),
      precioc: double.parse(row[3] as String),  // Convertir a double
      precio: double.parse(row[4] as String), // Convertir a double
      ubica: row[8] as String,
      imgurl: row[9] as String?,
      codigoB: row[10]as String?
      ));
      
 }

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Codigo Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

Future<List<ResultadoBusqueda>> consultarB(BuildContext context, String codigoBarra, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoBusqueda> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT art_codigo, art_descri, art_barra, art_cospro, art_preven, art_unidad, sto_cantid, sto_deposi, art_ubica, art_imagen, art_codbar FROM articulo, stock WHERE sto_articu = art_codigo and art_codbar = @codigobarra',
        substitutionValues: {'codigobarra': codigoBarra},
      );

      

      for (var row in results) {
      resultados.add(ResultadoBusqueda(
      code: row[0] as String,
      refe: row[2] as String,
      articulo: row[1] as String,
      stock: double.parse(row[6] as String),
      stockd: int.parse(row[7] as String),
      precioc: double.parse(row[3] as String),  // Convertir a double
      precio: double.parse(row[4] as String), // Convertir a double
      ubica: row[8] as String,
      imgurl: row[9] as String?,
      codigoB: row[10]as String?
      ));
      
 }

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RespuestaForm(resultados: resultados, currentIndex: 0,  busquedaText: valorDelTextFormField,)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Codigo de Barra Invalido!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }

Future<void> eliminarImagen(String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'UPDATE articulo SET art_imagen = NULL WHERE art_codigo = @codigo',
      substitutionValues: {'codigo': codigo},
    );

    // Eliminar la entrada de imagen de la otra tabla
    await conn.execute(
      'DELETE FROM imagenes WHERE img_articu = @codigo',
      substitutionValues: {'codigo': codigo},
    );
  }finally {
    await conn.close();
  }
}
Future<void> eliminarCodigoB(String codigo) async {
  final conn = await _connect();
  String blanco = '';
  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'UPDATE articulo SET art_codbar = @blanco WHERE art_codigo = @codigo',
      substitutionValues: {'codigo': codigo, 'blanco' : blanco},
    );
  }finally {
    await conn.close();
  }
}
Future<void> actualizarinventario(String conteo, codigo, stockd, stock, time) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'INSERT INTO inven (inv_articu, inv_conteo, inv_deposi, inv_stock, inv_fechah) VALUES (@codigo, @conteo, @stockd, @stock, @hora)',
      substitutionValues: {'codigo': codigo, 'conteo' : conteo, 'stockd' : stockd, 'stock' : stock,'hora' : time },
    );
  } finally {
    await conn.close();
  }
}
Future<List<ResultadoListaVisitas>> consultarListaVisita(BuildContext context, String? codigo) async {
    final conn = await _connect();
    List<ResultadoListaVisitas> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT vis_id, vis_usuario, vis_coment, vis_foto, vis_client, vis_fechah, vis_proxim, vis_latitud, vis_longitud, vis_estado, cli_nombre, vis_tipo FROM visitas, clientes WHERE vis_client = @codigo AND cli_codigo = vis_client',
        substitutionValues: {'codigo': codigo},
      );

      for (var row in results) {
      resultados.add(ResultadoListaVisitas(
      vendedor: row[1]?.toString() ?? '',
      code: row[4]?.toString() ?? '',
      fecha: row[5]?.toString() ?? '',
      estado: row[9]?.toString() ?? '',
      nombre: row[10]?.toString() ?? '',
      tipo: row[11]?.toString() ?? '',
      visid: row[0]?.toString() ?? '',   
      comment: row[2]?.toString() ?? '',   
      ));
      
 }

      if (resultados.isNotEmpty) {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaVisitasScreen(
            articulos: resultados,
          ),
        ),
      );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡No se encontraron visitas con ese Nombre!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }
  Future<List<ResultadoListaVisitas>> consultarListaVisitaB(BuildContext context, String? codigo) async {
    final conn = await _connect();
    List<ResultadoListaVisitas> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT vis_id, vis_usuario, vis_coment, vis_foto, vis_client, vis_fechah, vis_proxim, vis_latitud, vis_longitud, vis_estado, cli_nombre, vis_tipo FROM visitas, clientes WHERE cli_codigo = vis_client',
        substitutionValues: {'codigo': codigo},
      );

      for (var row in results) {
      resultados.add(ResultadoListaVisitas(
      vendedor: row[1]?.toString() ?? '',
      code: row[4]?.toString() ?? '',
      fecha: row[5]?.toString() ?? '',
      estado: row[9]?.toString() ?? '',
      nombre: 'TODOS',
      tipo: row[11]?.toString() ?? '',
      visid: row[0]?.toString() ?? '',
      comment: row[2]?.toString() ?? '',      
      ));
      
 }

      if (resultados.isNotEmpty) {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListaVisitasScreen(
            articulos: resultados,
          ),
        ),
      );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡No se encontraron visitas con ese Nombre!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }
  Future<List<ResultadoVisitas>> consultarVisita(BuildContext context, String? codigo, String fecha) async {
    final conn = await _connect();
    List<ResultadoVisitas> resultados = [];
    try {
      await conn.open();

      final results = await conn.query(
        'SELECT vis_id, vis_usuario, vis_coment, vis_foto, vis_client, vis_fechah, vis_proxim, vis_latitud, vis_longitud, vis_estado, cli_nombre, vis_tipo FROM visitas, clientes WHERE vis_client = @codigo AND cli_codigo = vis_client AND vis_fechah = @fecha',
        substitutionValues: {'codigo': codigo, 'fecha': fecha},
      );

      

      for (var row in results) {
      resultados.add(ResultadoVisitas(
      visid: row[0]?.toString() ?? '',
      vendedor: row[1]?.toString() ?? '',
      coment: row[2]?.toString() ?? '',
      imgurl: row[3]?.toString() ?? '',
      code: row[4]?.toString() ?? '',
      fecha: row[5]?.toString() ?? '',
      proxfecha:row[6]?.toString() ?? '',
      latitud: row[7]?.toString() ?? '',
      longitud: row[8]?.toString() ?? '',
      estado: row[9]?.toString() ?? '',
      nombre: row[10]?.toString() ?? '',
      tipo: row[11]?.toString() ?? '',   
      ));

 }

      if (resultados.isNotEmpty) {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RespuestaVisitasScreen(
            resultados: resultados,  
          ),
          settings: RouteSettings(arguments: resultados),
        ),
      );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡Error!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }
Future<void> registrarvisita(String time, codigo, tipo, coment, proxtime, client, imgurl, latitud, longitud) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'INSERT INTO visitas (vis_fechah, vis_usuario, vis_tipo, vis_coment, vis_proxim, vis_client, vis_foto, vis_latitud, vis_longitud) VALUES (@time, @codigo, @tipo, @coment, @proxtime, @client, @foto, @latitud, @longitud)',
      substitutionValues: {'time' : time, 'codigo': codigo, 'tipo': tipo, 'coment': coment, 'proxtime': proxtime, 'client': client, 'foto': imgurl, 'latitud': latitud, 'longitud': longitud,},
    );
  } finally {
    await conn.close();
  }
}
Future<void> eliminarvisita(String visid) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'DELETE FROM visitas WHERE vis_id = @time',
      substitutionValues: {'time' : visid,},
    );
  } finally {
    await conn.close();
  }
}
  Future<List<ResultadoCliente>> consultarN(BuildContext context, String nombre, String valorDelTextFormField) async {
    final conn = await _connect();
    List<ResultadoCliente> resultados = [];

    try {
      await conn.open();

      final results = await conn.query(
        'SELECT cli_codigo, cli_nombre, cli_telefo FROM clientes WHERE cli_nombre LIKE @ref',
        substitutionValues: {'ref': '%$nombre%'},
      );

      
      for (var row in results) {
      resultados.add(ResultadoCliente(
      code: row[0] as String,
      nombre: row[1] as String,
      telefo: row[2] as String,
      ));
 }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }
  Future<List<ResultadoCliente>> consultarImagenCli(BuildContext context, String codigo) async {
    final conn = await _connect();
    List<ResultadoCliente> resultados = [];

    try {
      await conn.open();

      final results = await conn.query(
        'SELECT vis_ubica, vis_foto FROM visitas WHERE vis_client = @ref',
        substitutionValues: {'ref': '%$codigo%'},
      );

      
      for (var row in results) {
      resultados.add(ResultadoCliente(
      code: row[0] as String,
      nombre: row[1] as String,
      telefo: row[2] as String,
      ));
 }
      

      if (resultados.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrarVisitasScreen(resultados: resultados)));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
        content: Text('¡No existe un cliente con ese nombre!'),
        backgroundColor: Colors.red, // Puedes personalizar el color de fondo.
        ),
        );
      }
    } finally {
      await conn.close();
      //notifyListeners();
    }
    return resultados;
  }
  Future<void> eliminarImagenCasa1(String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la tabla de artículos
    await conn.execute(
      'UPDATE visitas SET vis_foto = NULL WHERE vis_id = @visid',
      substitutionValues: {'visid': codigo},
    );
  }finally {
    await conn.close();
  }
}
Future<void> actualizarRegistro(String nuevoImageUrl, String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la primera tabla
    await conn.execute(
      'UPDATE articulo SET art_imagen = @imageUrl WHERE art_codigo = @codigo',
      substitutionValues: {'imageUrl': nuevoImageUrl, 'codigo': codigo},
    );

    // Insertar en la otra tabla con la misma URL de imagen
    await conn.execute(
      'INSERT INTO imagenes (img_articu, img_url) VALUES (@codigo, @imageUrl)',
      substitutionValues: {'imageUrl': nuevoImageUrl, 'codigo': codigo},
    );
  } finally {
    await conn.close();
  }
  

}
Future<void> actualizarCodigoB(String codigoBarra, String codigo) async {
  final conn = await _connect();

  try {
    await conn.open();

    // Actualizar el campo de imagen en la primera tabla
    await conn.execute(
      'UPDATE articulo SET art_codbar = @codigobarra WHERE art_codigo = @codigo',
      substitutionValues: {'codigobarra': codigoBarra, 'codigo': codigo},
    );
  
  } finally {
    await conn.close();
  }
  

}

Future<PostgreSQLConnection> _connect() async {
    return PostgreSQLConnection(
      '170.254.216.73',
      5432,
      'dbsiagro',
      username: 'postgres',
      password: 'siagro2024',
    );
  }
}
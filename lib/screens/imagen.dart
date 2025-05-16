import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String? imageUrl;
  final String? code;

  const FullScreenImage({super.key, required this.imageUrl, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 230, 211),
        title: Text('Imagen del Articulo $code'),
      ),
      body: Center(
        child: InteractiveViewer(
                child: Image.network(
                  imageUrl!,
                  width: 500,
                  height: 500,
                ),
              ),
      ),
    );
  }
}
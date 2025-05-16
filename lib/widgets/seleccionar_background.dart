import 'package:flutter/material.dart';

class AuthSBackground extends StatelessWidget {
  const AuthSBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _GreenBox(),
          const _HeaderIcon(),
          const _BottomIcon(),
          
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top:30),
        child: const Icon(Icons.person_pin, size: 100, color: Colors.white)
        ),
      );    
  }
}
class _BottomIcon extends StatelessWidget {
  const _BottomIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100), // Ajusta el espacio entre la imagen y el borde inferior
      child: Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter, // Alinea la imagen en la parte inferior del contenedor
        child: Image.asset(
          'assets/siagro_logoc.png',
          scale: 3,
          fit: BoxFit.cover, // Ajusta la imagen para que cubra todo el contenedor
        ),
      ),
    );
  }
}

class _GreenBox extends StatelessWidget {
  const _GreenBox();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 1,
      decoration: _greenBackground(),
      child: const Stack(
        children: [
          /*Positioned(top:290, left: 5,child: _Bubble(),),
          Positioned(top:410, left: 20,child: _Bubble(),),
          Positioned(top:220, right: 5,child: _Bubble(),),
          Positioned(top:-40, left: -30,child: _Bubble(),),
          Positioned(top:-50, right: -20,child: _Bubble(),),
          Positioned(bottom:100, left: 10,child: _Bubble(),),
          Positioned(bottom:40, right: 13,child: _Bubble(),),
          Positioned(top:420, right: 5,child: _Bubble(),),*/

        ],
      ),
    );
  }

  BoxDecoration _greenBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 255, 255, 255),
        ]
      )
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromARGB(255, 255, 169, 169)
      ),
    );
  }
}
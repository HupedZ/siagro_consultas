import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.red,
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, bottom: 660),
      child: Image.asset(
        'assets/siagro_logoc.png',
        scale: 2.5,
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  const _BottomIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 0), // Ajusta el espacio entre la imagen y el borde inferior
      child: Container(
        width: double.infinity,
        alignment: Alignment
            .bottomCenter, // Alinea la imagen en la parte inferior del contenedor
        child: Image.asset(
          'assets/uniport2.jpg',
          fit: BoxFit
              .cover, // Ajusta la imagen para que cubra todo el contenedor
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
          Positioned(top:220, right: 5,child: _Bubble(),),
          Positioned(top:500, right: -25,child: _Bubble(),),
          Positioned(top:500, left: -25,child: _Bubble(),),
          Positioned(top:-40, left: -30,child: _Bubble(),),
          Positioned(top:-50, right: -20,child: _Bubble(),),*/
        ],
      ),
    );
  }

  BoxDecoration _greenBackground() {
    return const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          Color.fromARGB(255, 254, 242, 209),
          Colors.white,
        ]));
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
          borderRadius: BorderRadius.circular(100), color: Colors.orangeAccent),
    );
  }
}

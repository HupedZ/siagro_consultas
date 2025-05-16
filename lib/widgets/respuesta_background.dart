import 'package:flutter/material.dart';

class RespuestaBackground extends StatelessWidget {
  const RespuestaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _OrangeBoxR(),
          const _HeaderIcon(),
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
        margin: const EdgeInsets.only(top:1, bottom: 720),
        child: Image.asset('assets/siagro_logoc.png', scale: 5,),
        ),
      );    
  }
}

class _OrangeBoxR extends StatelessWidget {
  const _OrangeBoxR();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 1,
      decoration: _orangeBackground(),
      child: const Stack(
        children: [
          Positioned(top:90, left: 30,child: _Bubble(),),
          Positioned(top:-40, left: -30,child: _Bubble(),),
          Positioned(top:-50, right: -20,child: _Bubble(),),
          Positioned(bottom:-50, left: 10,child: _Bubble(),),
          Positioned(bottom:120, right: 20,child: _Bubble(),)
        ],
      ),
    );
  }

  BoxDecoration _orangeBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1)
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
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
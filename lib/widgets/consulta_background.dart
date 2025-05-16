import 'package:flutter/material.dart';

class ConsultaBackground extends StatelessWidget {
  const ConsultaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _OrangeBox(),
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
        margin: const EdgeInsets.only(top:18),
        child: Image.asset('assets/siagro_logoc.png', scale: 3,),
        ),
      );    
  }
}

class _OrangeBox extends StatelessWidget {
  const _OrangeBox();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 1,
      decoration: _orangeBackground(),
      child: const Stack(
        children: [
          /*Positioned(top:290, left: 5,child: _Bubble(),),
          Positioned(top:610, left: 20,child: _Bubble(),),
          Positioned(top:220, right: 5,child: _Bubble(),),
          Positioned(top:-40, left: -30,child: _Bubble(),),
          Positioned(top:-50, right: -20,child: _Bubble(),),
          Positioned(bottom:-50, left: 10,child: _Bubble(),),
          Positioned(bottom:120, right: 20,child: _Bubble(),)*/
        ],
      ),
    );
  }

  BoxDecoration _orangeBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(244, 246, 244, 1),
          Color.fromRGBO(244, 246, 244, 1),
        ]
      )
    );
  }
}

// ignore: unused_element
class _Bubble extends StatelessWidget {
  const _Bubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color:const Color.fromARGB(255, 216, 202, 130)
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CardRegContainer extends StatelessWidget {

  final Widget child;

  const CardRegContainer({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10 ),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all( 20 ),
          decoration: _createCardShape(),
          child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: const Color.fromARGB(255, 255, 247, 226),
    borderRadius: BorderRadius.circular(25),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5),
      )
    ],
    border: Border.all(color: Colors.orange, width: 2)
  );
}
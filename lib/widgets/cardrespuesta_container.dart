import 'package:flutter/material.dart';

class CardRContainer extends StatelessWidget {

  final Widget child;

  const CardRContainer({
    super.key, 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 10 ),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.all( 5 ),
          decoration: _createCardShape(),
          
          child: child,
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
    color: const Color.fromARGB(255, 255, 247, 226),
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 15,
        offset: Offset(0, 5),
      )
    ],
    

  );
}


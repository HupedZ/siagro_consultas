import 'package:flutter/material.dart';

class InputrDecorations {

  static InputDecoration respuestaInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon
  }){
    return InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:Colors.orangeAccent
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orangeAccent,
                    width: 2
                  )
                ),
                prefixIcon:prefixIcon != null
                 ? Icon(prefixIcon, color: Colors.orangeAccent,)
                 : null
              );
  }

}
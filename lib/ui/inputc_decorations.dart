import 'package:flutter/material.dart';

class InputcDecorations {

  static InputDecoration consultaInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon
  }){
    return InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color:Colors.orangeAccent,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orangeAccent,
                    width: 2
                  )
                ),
                hintText: hintText,
                labelText: labelText,
                labelStyle: const TextStyle(
                  color: Colors.grey
                ),
                prefixIcon:prefixIcon != null
                 ? Icon(prefixIcon, color: Colors.orangeAccent,)
                 : null
              );
  }

}
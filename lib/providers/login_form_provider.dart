import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String usuario = '';
  String password = '';
 
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading( bool value ){
    _isLoading = value;
    notifyListeners();
  }
  
  bool isValidForm(){
    //print('aqui entre en ingresar');
    return formKey.currentState?.validate() ?? false;
  }

}
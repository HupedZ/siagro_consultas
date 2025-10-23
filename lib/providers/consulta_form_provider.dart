import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConsultaFormProvider extends ChangeNotifier {
  GlobalKey<FormState> cformKey = GlobalKey<FormState>();
  var codigoBarra = '';
  var time = DateTime.now();
  String valorDelTextFormField = '';
  String referencia = '';
  String codigo = '';
  String ubicacion = '';
  String conteo = '';
  String nCodigoB = '';
  String _opcionSeleccionada = 'Referencia';

  String get opcionSeleccionada => _opcionSeleccionada;

  setOpcionSeleccionada(String value) {
    _opcionSeleccionada = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _switchValue = false;

  bool get switchValue => _switchValue;

  void setSwitchValue(bool value) {
    _switchValue = value;
    notifyListeners();
  }

  bool _switchValuer = false;

  bool get switchValuer => _switchValuer;

  void setSwitchValuer(bool value2) {
    _switchValuer = value2;
    notifyListeners();
  }

  bool isValidForm() {
    //print('aqui entre en ingresar');
    return cformKey.currentState?.validate() ?? false;
  }

  bool _showImage = false;

  bool get showImage => _showImage;

  void toggleImageVisibility() {
    _showImage = !_showImage;
    notifyListeners();
  }
}

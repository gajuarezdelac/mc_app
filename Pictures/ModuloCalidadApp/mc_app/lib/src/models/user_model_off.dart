/*
 * En si esto nos crea un modelo que almacenara de manera temporal los datos 
 * de nuestra tabla Empleados
 */

class UserModelOff {
  String _ficha; // Opcional api
  String _email; // Opcional api
  String _fechaIngreso; // Opcional api

  UserModelOff(this._ficha, this._email);

  UserModelOff.fromMap(dynamic obj) {
    this._ficha = obj['Ficha'];
    this._email = obj['Email'];
    this._fechaIngreso = obj['FechaIngreso'];
  }

  String get ficha => _ficha;
  String get email => _email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Ficha"] = _ficha;
    map["Email"] = _email;
    map['FechaIngreso'] = _fechaIngreso;
    return map;
  }
}

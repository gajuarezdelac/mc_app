/*
 * En si esto nos crea un modelo que almacenara de manera temporal los datos
 * de nuestra tabla Empleados
 */

class UserModelOff {
  String _ficha; // Opcional api
  String _nombre; // Opcional api
  String _email; // Opcional api
  // String _puestoId; // // Opcional api
  // String _puestoDescripcion; // Opcional api
  String _fechaIngreso; // Opcional api

  UserModelOff(this._ficha, this._email);

  UserModelOff.fromMap(dynamic obj) {
    this._ficha = obj['Ficha'];
    this._email = obj['Email'];
    this._fechaIngreso = obj['FechaIngreso'];
    this._nombre = obj['Nombre'];
  }

  String get ficha => _ficha;
  String get email => _email;
  String get fechaIngreso => _fechaIngreso;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["Ficha"] = _ficha;
    map["Email"] = _email;
    map['FechaIngreso'] = _fechaIngreso;
    map['Nombre'] = _nombre;
    return map;
  }
}

class UserGeneral {
  final int ficha;
  final String puesto;
  final String nombre;

  UserGeneral({this.ficha, this.puesto, this.nombre});

  factory UserGeneral.fromJson(Map<String, dynamic> json) => UserGeneral(
        ficha: json['Ficha'],
        puesto: json['PuestoDescripcion'],
        nombre: json['Nombre'],
      );
}

class QAWeldingUserModel {
  final int ficha;
  final String puesto;
  final String nombre;

  QAWeldingUserModel({this.ficha, this.puesto, this.nombre});

  factory QAWeldingUserModel.fromJson(Map<String, dynamic> json) =>
      QAWeldingUserModel(
        ficha: json['Ficha'],
        puesto: json['PuestoDescripcion'],
        nombre: json['Nombre'],
      );
}

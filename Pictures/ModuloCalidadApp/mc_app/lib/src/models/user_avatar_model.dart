/*
 * En si esto nos crea un modelo que almacenara de manera temporal los datos
 * de nuestra tabla Empleados
 */

class UserAvatarModel {
  String ficha;
  String nombre;
  String email;
  String puestoDescripcion;
  String rol;

  UserAvatarModel(
      {this.ficha, this.email, this.nombre, this.puestoDescripcion, this.rol});

  factory UserAvatarModel.fromJson(Map<String, dynamic> json) =>
      UserAvatarModel(
        ficha: json["Ficha"],
        email: json["Email"],
        nombre: json["Nombre"],
        puestoDescripcion: json["PuestoDescripcion"],
        rol: json["Rol"],
      );

  Map<String, dynamic> toJson() => {
        "Ficha": ficha,
        "Nombre": nombre,
        "Email": email,
        "PuestoDescripcion": puestoDescripcion,
        "Rol": rol,
      };
}

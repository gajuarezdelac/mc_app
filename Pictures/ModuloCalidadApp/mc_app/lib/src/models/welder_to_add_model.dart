class WelderToAddModel {
  String soldadorId;
  String nombre;
  bool activo;
  String ficha;
  String categoria;
  String vigencia;

  WelderToAddModel({
    this.soldadorId,
    this.nombre,
    this.activo,
    this.ficha,
    this.categoria,
    this.vigencia,
  });

  factory WelderToAddModel.fromJson(Map<String, dynamic> json) =>
      WelderToAddModel(
        soldadorId: json['SoldadorId'],
        nombre: json['Nombre'],
        activo: json['Activo'] == 1 ? true : false,
        ficha: json['Ficha'],
        categoria: json['Categoria'],
        vigencia: json['Vigencia'],
      );
}

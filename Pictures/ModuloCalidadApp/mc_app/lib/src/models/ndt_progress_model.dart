class NDTProgressModel {
  String clave;
  String folioPND;
  String fechaPND;
  String noTarjeta;
  String nombre;
  String evaluacion;

  NDTProgressModel({
    this.clave,
    this.folioPND,
    this.fechaPND,
    this.noTarjeta,
    this.nombre,
    this.evaluacion,
  });

  //Convierte un Json en un objeto de tipo NDTProgressModel
  factory NDTProgressModel.fromJson(Map<String, dynamic> json) =>
      NDTProgressModel(
        clave: json['Clave'],
        folioPND: json['FolioPND'],
        fechaPND: json['FechaPND'],
        noTarjeta: json['NoTarjeta'],
        nombre: json['Nombre'],
        evaluacion: json['Evaluacion'],
      );
}

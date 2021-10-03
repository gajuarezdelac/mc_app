class EquipmentModel {
  int orden;
  String nombre;

  EquipmentModel({
    this.orden,
    this.nombre
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      EquipmentModel(
        orden: json['Orden'],
        nombre: json['Nombre']
      );
}
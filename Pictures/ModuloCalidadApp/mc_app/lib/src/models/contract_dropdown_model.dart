class ContractDropdownModel {
  String contratoId;
  String nombre;

  ContractDropdownModel({
    this.contratoId,
    this.nombre,
  });

  //Convierte un Json en un objeto de tipo ContractDropdownModel
  factory ContractDropdownModel.fromJson(Map<String, dynamic> json) =>
      ContractDropdownModel(
        contratoId: json["ContratoId"],
        nombre: json["Nombre"],
      );
}

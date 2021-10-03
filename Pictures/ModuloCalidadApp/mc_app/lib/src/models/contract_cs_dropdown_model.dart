class ContractCSDropdownModel {
  String contratoId;
  String contratoNombre;
  String nombre;

  ContractCSDropdownModel({
    this.contratoId,
    this.contratoNombre,
    this.nombre,
  });

  //Convierte un Json en un objeto de tipo ContractCSDropdownModel
  factory ContractCSDropdownModel.fromJson(Map<String, dynamic> json) =>
      ContractCSDropdownModel(
        contratoId: json["ContratoId"],
        contratoNombre: json["ContratoNombre"],
        nombre: json["Nombre"],
      );
}

class FrontDropdownModel {
  int frenteId;
  String descripcion;

  FrontDropdownModel({
    this.frenteId,
    this.descripcion,
  });

  //Convierte un Json en un objeto de tipo FrontDropdownModel
  factory FrontDropdownModel.fromJson(Map<String, dynamic> json) =>
      FrontDropdownModel(
        frenteId: json["FrenteId"],
        descripcion: json["Descripcion"],
      );
}

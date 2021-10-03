class DataModel {
  String contratoId;
  int frenteId;

  DataModel({
    this.frenteId,
    this.contratoId,
  });

  //Convierte un Json en un objeto de tipo FrontDropdownModel
  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        frenteId: json["FrenteId"],
        contratoId: json["contratoId"],
      );
}

class ContractListModel {
  List<ContractModel> items = [];

  // Parse a POJO object into a List of WeldingControlModel
  ContractListModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final contractModel = ContractModel.fromJson(item);
      items.add(contractModel);
    }
  }
}

class ContractModel {
  String contratoId;
  String contratoNombre;
  String nombre;
  String embarcacion;

  ContractModel({
    this.contratoId,
    this.contratoNombre,
    this.nombre,
    this.embarcacion,
  });

  //Parse a POJO object into a WeldingControlModel object
  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
        contratoId: json["ContratoId"],
        contratoNombre: json["ContratoNombre"],
        nombre: json["Nombre"],
        embarcacion: json["Embarcacion"],
      );

  //Parse a WeldingControlModel object into a POJO object
  Map<String, dynamic> toJson() => {
        "ContratoId": contratoId,
        "ContratoNombre": contratoNombre,
        "Nombre": nombre,
        "Embarcacion": embarcacion,
      };
}

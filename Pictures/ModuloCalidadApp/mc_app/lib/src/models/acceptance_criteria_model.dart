class AcceptanceCriteriaWeldingModel {
  String criterioAceptacionId;
  String clave;
  String criterioId;

  AcceptanceCriteriaWeldingModel(
      {this.clave, this.criterioAceptacionId, this.criterioId});

  factory AcceptanceCriteriaWeldingModel.fromJson(Map<String, dynamic> json) =>
      AcceptanceCriteriaWeldingModel(
          criterioAceptacionId: json["CriterioAceptacionId"],
          clave: json["Clave"],
          criterioId: json["Criterio"]);
}

class AcceptanceCriteriaconformadoModel {
  String criterioAceptacionId;
  String clave;
  String criterioId;

  AcceptanceCriteriaconformadoModel(
      {this.clave, this.criterioAceptacionId, this.criterioId});

  factory AcceptanceCriteriaconformadoModel.fromJson(
          Map<String, dynamic> json) =>
      AcceptanceCriteriaconformadoModel(
          criterioAceptacionId: json["CriterioAceptacionId"],
          clave: json["Clave"],
          criterioId: json["Criterio"]);
}

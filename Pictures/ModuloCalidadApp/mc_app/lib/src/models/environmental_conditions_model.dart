class EnvironmentalConditionsModel {
  int orden;
  String temperaturaAmbiente;
  String temperaturaSustrato;
  String humedadRelativa;

  EnvironmentalConditionsModel({
    this.orden,
    this.temperaturaAmbiente,
    this.temperaturaSustrato,
    this.humedadRelativa
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory EnvironmentalConditionsModel.fromJson(Map<String, dynamic> json) =>
      EnvironmentalConditionsModel(
        orden: json['Orden'],
        temperaturaAmbiente: json['TemperaturaAmbiente'],
        temperaturaSustrato: json['TemperaturaSustrato'],
        humedadRelativa: json['HumedadRelativa']
      );
}
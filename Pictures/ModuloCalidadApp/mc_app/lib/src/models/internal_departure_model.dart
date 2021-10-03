class InternalDepartureModel {
  String partidaInterna;

  InternalDepartureModel({this.partidaInterna});

  factory InternalDepartureModel.fromJson(Map<String, dynamic> json) =>
      InternalDepartureModel(
        partidaInterna: json["PartidaInterna"],
      );
}

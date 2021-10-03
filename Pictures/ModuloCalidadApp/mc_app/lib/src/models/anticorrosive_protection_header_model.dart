class AnticorrosiveProtectionHeaderModel {
  String contratoId;
  String obra;
  String sistema;
  String instalacion;
  String plataforma;

  AnticorrosiveProtectionHeaderModel({
    this.contratoId,
    this.obra,
    this.sistema,
    this.instalacion,
    this.plataforma
  });

  factory AnticorrosiveProtectionHeaderModel.fromJson(Map<String, dynamic> json) => 
    AnticorrosiveProtectionHeaderModel(
      contratoId: json['ContratoId'],
      obra: json['OT'],
      sistema: json['Sistema'],
      instalacion: json['Instalacion'],
      plataforma: json['Plataforma']
    );
}
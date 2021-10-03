class JointTraceabilityModel {
  int filaId;
  String juntaId;
  String juntaNo;
  double cantidadUsada;
  int noTrazabilidad;
  String uM;

  // New fields
  String obraId;
  String planoDetalleId;
  String numeroPlano;
  int revision;
  int hoja;
  String plano;

  JointTraceabilityModel({
    this.plano,
    this.filaId,
    this.obraId,
    this.planoDetalleId,
    this.numeroPlano,
    this.revision,
    this.hoja,
    this.juntaId,
    this.juntaNo,
    this.cantidadUsada,
    this.noTrazabilidad,
    this.uM,
  });

  factory JointTraceabilityModel.fromJson(Map<String, dynamic> json) =>
      JointTraceabilityModel(
        filaId: json['FilaId'],
        planoDetalleId: json['PlanoDetalleId'],
        numeroPlano: json['NumeroPlano'],
        revision: json['Revision'],
        hoja: json['Hoja'],
        obraId: json['ObraId'],
        juntaId: json['JuntaId'],
        juntaNo: json['JuntaNo'],
        cantidadUsada: json['CantidadUsada'],
        noTrazabilidad: json['NoTrazabilidad'],
        uM: json['UM'],
        plano: json['Plano'],
      );
}

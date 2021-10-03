class JointWCModel {
  String juntaId;
  String junta;
  String siteId;
  String diametro;
  String espesor;
  String tipoJunta;
  String claveWPS;
  String spoolEstructura;
  String frente;
  int tuberos;
  bool firmaTuberos;
  double progreso;
  bool conformadoLiberado;
  String inspecVisConformado;
  bool soldaduraLiberada;
  String inspecVisSoldadura;
  int soldadores;
  bool firmaSoldadores;
  String solicitudPNDEnviada;
  String solicitudPNDTerminada;
  String conformadoId;
  double progresoGeneral;

  JointWCModel({
    this.juntaId,
    this.junta,
    this.siteId,
    this.diametro,
    this.espesor,
    this.tipoJunta,
    this.claveWPS,
    this.spoolEstructura,
    this.frente,
    this.tuberos,
    this.firmaTuberos,
    this.progreso,
    this.conformadoLiberado,
    this.inspecVisConformado,
    this.soldaduraLiberada,
    this.inspecVisSoldadura,
    this.soldadores,
    this.firmaSoldadores,
    this.solicitudPNDEnviada,
    this.solicitudPNDTerminada,
    this.conformadoId,
    this.progresoGeneral,
  });

  //Convierte un Json en un objeto de tipo JuntaCSModel
  factory JointWCModel.fromJson(Map<String, dynamic> json) => JointWCModel(
        juntaId: json['JuntaId'],
        junta: json['Junta'],
        siteId: json['SiteId'],
        diametro: json['Diametro'],
        espesor: json['Espesor'],
        tipoJunta: json['TipoJunta'],
        claveWPS: json['ClaveWPS'],
        spoolEstructura: json['SpoolEstructura'],
        frente: json['Frente'],
        tuberos: json['Tuberos'],
        firmaTuberos: json['FirmaTuberos'] == 1 ? true : false,
        progreso: json['Progreso'],
        conformadoLiberado: json['ConformadoLiberado'] == 1 ? true : false,
        inspecVisConformado: json['InspecVisConformado'],
        soldaduraLiberada: json['SoldaduraLiberada'] == 1 ? true : false,
        inspecVisSoldadura: json['InspecVisSoldadura'],
        soldadores: json['Soldadores'],
        firmaSoldadores: json['FirmaSoldadores'] == 1 ? true : false,
        solicitudPNDEnviada: json['SolicitudPNDEnviada'],
        solicitudPNDTerminada: json['SolicitudPNDTerminada'],
        conformadoId: json['ConformadoId'],
        progresoGeneral: json['ProgresoGeneral'],
      );
}

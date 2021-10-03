class EmpleadoSoldadorNotValidModel {
  String folioSoldadura;
  String soldadorId;
  String soldaduraId;
  String siteId;
  String registroSoldaduraId;
  String cuadranteSoldaduraId;
  String zonaSoldaduraId;
  String noTarjeta;
  String nombre;
  String ficha;
  String categoria;
  bool wPSVigente;
  String folioSoldaduraFN;
  int consecutivo;
  int result;

  EmpleadoSoldadorNotValidModel(
      {this.folioSoldadura,
      this.soldadorId,
      this.soldaduraId,
      this.siteId,
      this.registroSoldaduraId,
      this.cuadranteSoldaduraId,
      this.zonaSoldaduraId,
      this.noTarjeta,
      this.nombre,
      this.ficha,
      this.categoria,
      this.wPSVigente,
      this.folioSoldaduraFN,
      this.consecutivo,
      this.result});

  factory EmpleadoSoldadorNotValidModel.fromJson(Map<String, dynamic> json) =>
      EmpleadoSoldadorNotValidModel(
        folioSoldadura: json['IdEquipo'],
        soldadorId: json['EquipoNoSerie'],
        soldaduraId: json['EquipoMarca'],
        siteId: json['EquipoDescripcion'],
        registroSoldaduraId: json['registroSoldaduraId'],
        cuadranteSoldaduraId: json['cuadranteSoldaduraId'],
        zonaSoldaduraId: json['zonaSoldaduraId'],
        noTarjeta: json['NoTarjeta'],
        nombre: json['Nombre'],
        ficha: json['ficha'],
        categoria: json['Categoria'],
        wPSVigente: json['WPSVigente'],
        folioSoldaduraFN: json['FolioSoldaduraFN'],
        consecutivo: json['Consecutiv'],
      );
}

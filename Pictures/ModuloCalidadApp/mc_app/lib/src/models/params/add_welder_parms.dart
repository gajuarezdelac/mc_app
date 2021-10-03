class AddWelderParams {
  String noPlanInspeccion;
  String siteId;
  dynamic propuestaTecnicaId;
  dynamic actividadId;
  dynamic subActividadId;
  dynamic reprogramacionOTId;
  List<dynamic> soldadores;

  AddWelderParams(
      {this.noPlanInspeccion,
      this.siteId,
      this.propuestaTecnicaId,
      this.actividadId,
      this.subActividadId,
      this.reprogramacionOTId,
      this.soldadores});
}

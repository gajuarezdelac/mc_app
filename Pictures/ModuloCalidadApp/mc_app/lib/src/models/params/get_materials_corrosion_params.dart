class GetMaterialsCorrisionParamsModel {
  String noEnvio;
  String noRegistroInspeccion;
  String contratoId;
  String obraId;
  String destino;
  String deptoSolicitante;
  String observaciones;
  String fechaInicio;
  String fechaFin;

  GetMaterialsCorrisionParamsModel(
              {this.noEnvio,
               this.noRegistroInspeccion,
               this.contratoId,
               this.obraId,
               this.destino, 
               this.deptoSolicitante,
               this.observaciones,
               this.fechaFin,
               this.fechaInicio});
}

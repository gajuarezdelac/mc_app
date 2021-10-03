class MaterialsTableIPAModel {
  int materialIdIPA;
  String nombreElemento;
  String localizacion;
  String trazabilidadId;
  String planoDetalle;
  String um;
  String tipoMaterial;
  double cantidadUsada;
  String fechaLiberacion;

  MaterialsTableIPAModel({
    this.materialIdIPA,
    this.nombreElemento,
    this.localizacion,
    this.trazabilidadId,
    this.planoDetalle,
    this.um,
    this.tipoMaterial,
    this.cantidadUsada,
    this.fechaLiberacion
  });
}

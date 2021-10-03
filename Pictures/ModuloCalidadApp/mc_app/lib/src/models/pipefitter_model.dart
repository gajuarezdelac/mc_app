class PipefitterModel {
  int empleadoId;
  bool firmado;
  String foto;
  String nombre;
  int ficha;
  String puestoDescripcion;

  PipefitterModel({
    this.empleadoId,
    this.firmado,
    this.foto,
    this.nombre,
    this.ficha,
    this.puestoDescripcion,
  });

  //Convierte un Json en un objeto de tipo PipefitterModel
  factory PipefitterModel.fromJson(Map<String, dynamic> json) =>
      PipefitterModel(
        empleadoId: json['EmpleadoId'],
        firmado: json['Firmado'] == 1 ? true : false,
        foto: json['Foto'],
        nombre: json['Nombre'],
        ficha: json['Ficha'],
        puestoDescripcion: json['PuestoDescripcion'],
      );
}

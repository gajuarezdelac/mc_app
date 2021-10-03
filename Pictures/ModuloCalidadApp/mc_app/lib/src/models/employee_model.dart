class EmployeeModel {
  int empleadoId;
  String foto;
  String nombre;
  int ficha;
  String puestoDescripcion;

  EmployeeModel({
    this.empleadoId,
    this.foto,
    this.nombre,
    this.ficha,
    this.puestoDescripcion,
  });

  //Convierte un Json en un objeto de tipo EmployeeModel
  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        empleadoId: json['EmpleadoId'],
        foto: json['Foto'],
        nombre: json['Nombre'],
        ficha: json['Ficha'],
        puestoDescripcion: json['PuestoDescripcion'],
      );
}

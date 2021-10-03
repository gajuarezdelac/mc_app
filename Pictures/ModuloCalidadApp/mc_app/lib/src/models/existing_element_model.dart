class ExistingElementModel {
  String idElementoExistente;
  String materialDescrBreve;

  ExistingElementModel({
    this.idElementoExistente,
    this.materialDescrBreve
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory ExistingElementModel.fromJson(Map<String, dynamic> json) =>
      ExistingElementModel(
        idElementoExistente: json['IdElementoExistente'],
        materialDescrBreve: json['MaterialDescrBreve']
      );
}
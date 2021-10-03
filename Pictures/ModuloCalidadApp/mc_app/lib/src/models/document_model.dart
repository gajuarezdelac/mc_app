class DocumentModel {
  String id;
  String name;
  String contentType;
  String content;
  String nombre;

  DocumentModel({
    this.id,
    this.name,
    this.contentType,
    this.content,
    this.nombre
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => 
    DocumentModel(
      id: json['Id'],
      name: json['Name'],
      contentType: json['ContentType'],
      content: json['Content'],
      nombre: json['Nombre']
    );
}
class PhotographicEvidenceModel {
  String fotoId;
  String content;
  String thumbnail;
  String contentType;
  String identificadorTabla;
  String nombreTabla;
  String siteModificacion;
  String fechaModificacion;
  String nombre;
  int regBorrado;

  PhotographicEvidenceModel(
      {this.fotoId,
      this.content,
      this.thumbnail,
      this.contentType,
      this.identificadorTabla,
      this.nombre,
      this.nombreTabla,
      this.siteModificacion,
      this.fechaModificacion,
      this.regBorrado});

  factory PhotographicEvidenceModel.fromJson(Map<String, dynamic> json) =>
      PhotographicEvidenceModel(
          fotoId: json['FotoId'],
          content: json['Content'],
          thumbnail: json['Thumbnail'],
          contentType: json['ContentType'],
          identificadorTabla: json['IdentificadorTabla'],
          nombreTabla: json['NombreTabla'],
          siteModificacion: json['SiteModificacion'],
          fechaModificacion: json['FechaModificacion'],
          nombre: json['Nombre'],
          regBorrado: json['RegBorrado']);

  Map<String, dynamic> toMap() => {
        "FotoId": fotoId,
        "Content": content,
        "Thumbnail": thumbnail,
        "ContentType": contentType,
        "IdentificadorTabla": identificadorTabla,
        "NombreTabla": nombreTabla,
        "SiteModificacion": siteModificacion,
        "FechaModificacion": fechaModificacion,
        "Nombre": nombre,
        "RegBorrado": 0
      };

  Map<String, dynamic> toJson() => {
        "FotoId": fotoId,
        "Content": content,
        "Thumbnail": thumbnail,
        "ContentType": contentType,
        "IdentificadorTabla": identificadorTabla,
        "NombreTabla": nombreTabla,
        "SiteModificacion": siteModificacion,
        "FechaModificacion": fechaModificacion,
        "Nombre": nombre,
        "RegBorrado": regBorrado
      };

  /*
      'FotoId TEXT PRIMARY KEY,'
      'Content TEXT,'
      'Thumbnail TEXT,'
      'ContentType TEXT,'
      'IdentificadorTabla TEXT,'
      'NombreTabla TEXT,'
      'SiteModificacion TEXT,'
      'FechaModificacion TEXT,'
      'Nombre TEXT,'
      'RegBorrado INTEGER DEFAULT 0'
      */
}

class PhotographicEvidenceWeldingModel {
  String fotoId;
  String content;
  String thumbnail;
  String contentType;
  String identificadorTabla;
  String nombreTabla;
  String siteModificacion;
  String fechaModificacion;
  String nombre;
  int regBorrado;

  PhotographicEvidenceWeldingModel(
      {this.fotoId,
      this.content,
      this.thumbnail,
      this.contentType,
      this.identificadorTabla,
      this.nombre,
      this.nombreTabla,
      this.siteModificacion,
      this.fechaModificacion,
      this.regBorrado});

  factory PhotographicEvidenceWeldingModel.fromJson(
          Map<String, dynamic> json) =>
      PhotographicEvidenceWeldingModel(
          fotoId: json['FotoId'],
          content: json['Content'],
          thumbnail: json['Thumbnail'],
          contentType: json['ContentType'],
          identificadorTabla: json['IdentificadorTabla'],
          nombreTabla: json['NombreTabla'],
          siteModificacion: json['SiteModificacion'],
          fechaModificacion: json['FechaModificacion'],
          nombre: json['Nombre'],
          regBorrado: json['RegBorrado']);

  Map<String, dynamic> toMap() => {
        "FotoId": fotoId,
        "Content": content,
        "Thumbnail": thumbnail,
        "ContentType": contentType,
        "IdentificadorTabla": identificadorTabla,
        "NombreTabla": nombreTabla,
        "SiteModificacion": siteModificacion,
        "FechaModificacion": fechaModificacion,
        "Nombre": nombre,
        "RegBorrado": 0
      };

  Map<String, dynamic> toJson() => {
        "FotoId": fotoId,
        "Content": content,
        "Thumbnail": thumbnail,
        "ContentType": contentType,
        "IdentificadorTabla": identificadorTabla,
        "NombreTabla": nombreTabla,
        "SiteModificacion": siteModificacion,
        "FechaModificacion": fechaModificacion,
        "Nombre": nombre,
        "RegBorrado": regBorrado
      };
}

class PhotographicEvidenceIPModel {
  String fotoId;
  String content;
  String thumbnail;
  String contentType;
  String identificadorTabla;
  String nombreTabla;
  String siteModificacion;
  String fechaModificacion;
  String nombre;
  int regBorrado;

  PhotographicEvidenceIPModel(
      {this.fotoId,
      this.content,
      this.thumbnail,
      this.contentType,
      this.identificadorTabla,
      this.nombre,
      this.nombreTabla,
      this.siteModificacion,
      this.fechaModificacion,
      this.regBorrado});

  factory PhotographicEvidenceIPModel.fromJson(Map<String, dynamic> json) =>
      PhotographicEvidenceIPModel(
          fotoId: json['FotoId'],
          content: json['Content'],
          thumbnail: json['Thumbnail'],
          contentType: json['ContentType'],
          identificadorTabla: json['IdentificadorTabla'],
          nombreTabla: json['NombreTabla'],
          siteModificacion: json['SiteModificacion'],
          fechaModificacion: json['FechaModificacion'],
          nombre: json['Nombre'],
          regBorrado: json['RegBorrado']);

  Map<String, dynamic> toMap() => {
        "FotoId": fotoId,
        "Content": content,
        "Thumbnail": thumbnail,
        "ContentType": contentType,
        "IdentificadorTabla": identificadorTabla,
        "NombreTabla": nombreTabla,
        "SiteModificacion": siteModificacion,
        "FechaModificacion": fechaModificacion,
        "Nombre": nombre,
        "RegBorrado": 0
      };

  Map<String, dynamic> toJson() => {
        "FotoId": fotoId,
        "Content": content,
        "Thumbnail": thumbnail,
        "ContentType": contentType,
        "IdentificadorTabla": identificadorTabla,
        "NombreTabla": nombreTabla,
        "SiteModificacion": siteModificacion,
        "FechaModificacion": fechaModificacion,
        "Nombre": nombre,
        "RegBorrado": regBorrado
      };
}

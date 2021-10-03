class WeldingsControlModel {
  List<WeldingControlModel> items = [];

  // Parse a POJO object into a List of WeldingControlModel
  WeldingsControlModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final weldingControl = WeldingControlModel.fromJson(item);
      items.add(weldingControl);
    }
  }
}

class WeldingControlModel {
  String juntaId;
  String junta;
  String spoolEstructura;
  String juntaNo;

  WeldingControlModel({
    this.juntaId,
    this.junta,
    this.spoolEstructura,
    this.juntaNo,
  });

  //Parse a POJO object into a WeldingControlModel object
  factory WeldingControlModel.fromJson(Map<String, dynamic> json) =>
      WeldingControlModel(
        juntaId: json["juntaId"],
        junta: json["junta"],
        spoolEstructura: json["spoolEstructura"],
        juntaNo: json["juntaNo"],
      );

  //Parse a WeldingControlModel object into a POJO object
  Map<String, dynamic> toJson() => {
        "juntaId": juntaId,
        "junta": junta,
        "spoolEstructura": spoolEstructura,
        "juntaNo": juntaNo,
      };
}

class StudentsControlModel {
  List<StudentControlModel> items = [];

  // Parse a POJO object into a List of WeldingControlModel
  StudentsControlModel.fromJsonList(List<dynamic> studentList) {
    if (studentList == null) return;

    for (var item in studentList) {
      final studentControl = StudentControlModel.fromJson(item);
      items.add(studentControl);
    }
  }
}

class StudentControlModel {
  String id;

  StudentControlModel({
    this.id,
  });

  //Parse a POJO object into a WeldingControlModel object
  factory StudentControlModel.fromJson(Map<String, dynamic> json) =>
      StudentControlModel(
        id: json["id"],
      );

  //Parse a WeldingControlModel object into a POJO object
  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

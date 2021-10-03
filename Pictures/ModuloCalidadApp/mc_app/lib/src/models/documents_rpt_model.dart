class DocumentsRptModel {
  String data;

  DocumentsRptModel({this.data});

  factory DocumentsRptModel.fromJson(Map<String, dynamic> json) =>
      DocumentsRptModel(data: json["Data"]);
}

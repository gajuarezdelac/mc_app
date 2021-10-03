//import 'package:meta/meta.dart';

class ColumnModelList {
  List<ColumnModel> columns = [];
  String strColumns = "";

  ColumnModelList.fromJsonList(List<dynamic> json) {
    if (json == null) return;
    Map<String, dynamic> items = json[0];
    for (var item in items.keys) {
      final columnModel = new ColumnModel();
      columnModel.name = item;
      columns.add(columnModel);
    }
  }

  @override
  String toString() {
    var strCols = StringBuffer();
    columns.forEach((item) {
      strCols.write("," + item.name);
    });
    return strCols.toString().substring(1);
  }

  String getColumnsToImport() {
    var strCols = StringBuffer();
    columns.forEach((item) {
      if (item.isNew == false) {
        strCols.write("," + item.name);
      } else {
        strCols.write(",NULL");
      }
    });
    return strCols.toString().substring(1);
  }
}

class ColumnModel {
  String name;
  String type;
  bool isNew;
  ColumnModel({
    this.name,
    this.type,
    this.isNew,
  });
}

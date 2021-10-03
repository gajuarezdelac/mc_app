class SelectDropDownModel {
  String key;
  String value;

  SelectDropDownModel({
    this.key,
    this.value,
  });

   @override
  String toString() {
    return '$value';
  }

  //Convierte un Json en un objeto de tipo SelectDropDownModel
  factory SelectDropDownModel.fromJson(Map<String, dynamic> json) =>
      SelectDropDownModel(
        key: json["Key"].toString(),
        value: json["Value"],
      );

static List<SelectDropDownModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => SelectDropDownModel.fromJson(item)).toList();
  }
  
  //In this case I customized it so that the search returns everything that contains part of the name or age
  @override
  operator ==(object) => this.value.toLowerCase().contains(object.toLowerCase());
  
  @override
  int get hashCode => value.hashCode;

}

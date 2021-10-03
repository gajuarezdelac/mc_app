import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';

@immutable
abstract class MaterialsCorrosionState {
  final String errorMessage;
  final List<MaterialesCorrosionModel> lstMaterials;
  final List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion;

  MaterialsCorrosionState({this.errorMessage, this.lstMaterials, this.lstSpoolDetalleProteccion});
}

class InitialMaterialsCorrosionState extends MaterialsCorrosionState {
    InitialMaterialsCorrosionState(
      {@required List<MaterialesCorrosionModel> lstMaterials})
      : super(lstMaterials: lstMaterials);
}

class IsLoadingMaterialsCorrosion extends MaterialsCorrosionState {}

class ErrorMaterialsCorrosion extends MaterialsCorrosionState {
  ErrorMaterialsCorrosion({@required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SuccessGetAllMaterialsCorrosion extends MaterialsCorrosionState {
  SuccessGetAllMaterialsCorrosion(
      {@required List<MaterialesCorrosionModel> lstMaterials})
      : super(lstMaterials: lstMaterials);
}

// class SuccessGetSpoolDetalleProteccion extends MaterialsCorrosionState {
//   SuccessGetSpoolDetalleProteccion(
//       {@required List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion})
//       : super(lstSpoolDetalleProteccion: lstSpoolDetalleProteccion);
// }


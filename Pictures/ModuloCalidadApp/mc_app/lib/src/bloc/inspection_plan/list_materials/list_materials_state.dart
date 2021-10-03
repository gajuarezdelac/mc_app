import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';

@immutable
abstract class ListMaterialsState {
  final List<ReporteInspeccionMaterialModel> list;
  final InsUpdateReporteIPModel insUpdateReporteIPModel;
  final String message;

  ListMaterialsState({
    this.list,
    this.insUpdateReporteIPModel,
    this.message,
  });
}

class InitialListMaterialsState extends ListMaterialsState {}

class IsLoadingListMaterials extends ListMaterialsState {}

class ErrorListMaterials extends ListMaterialsState {
  ErrorListMaterials({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessListMaterials extends ListMaterialsState {
  SuccessListMaterials({@required List<ReporteInspeccionMaterialModel> list})
      : super(list: list);
}

// Update Table

class IsLoadingUpdateReporteIP extends ListMaterialsState {}

class ErrorUpdateReporteIP extends ListMaterialsState {
  ErrorUpdateReporteIP({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessUpdateReporteIP extends ListMaterialsState {
  SuccessUpdateReporteIP(
      {@required InsUpdateReporteIPModel insUpdateReporteIPModel})
      : super(insUpdateReporteIPModel: insUpdateReporteIPModel);
}

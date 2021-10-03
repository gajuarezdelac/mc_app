import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/report_send_materials_corrosion/rpt_materials_corrosion_event.dart';
import 'package:mc_app/src/bloc/materials_corrosion/report_send_materials_corrosion/rpt_materials_corrosion_state.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/repository/report_repository.dart';

class RptMaterialsCorrosionBloc
    extends Bloc<RptMaterialsCorrosionEvent, RptMaterialsCorrosionState> {
  RptMaterialsCorrosionBloc() : super(InitialRptMaterialsCorrosionState());

  final _materialsCorrosionRepository = ReportRepository();

  @override
  Stream<RptMaterialsCorrosionState> mapEventToState(
      RptMaterialsCorrosionEvent event) async* {
    if (event is GetRptMaterialsCorosion) {
      yield IsLoadingRptMaterialsCorrosion();

      try {
        RptMaterialsCorrosionHeader materials =
            await _materialsCorrosionRepository
                .getEnvioMaterialesCorrosionCabecera(noEnvio: event.noEnvio);

        yield SuccessGetRptMaterialsCorrosion(materials: materials);
      } catch (e) {
        yield ErrorRptMaterialsCorrosion(errorMessage: e.toString());
      }
    }
  }
}

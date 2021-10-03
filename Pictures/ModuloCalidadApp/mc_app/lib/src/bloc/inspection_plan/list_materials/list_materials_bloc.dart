import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/list_materials/list_materials_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/list_materials/list_materials_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class ListMaterialsBloc extends Bloc<ListMaterialsEvent, ListMaterialsState> {
  ListMaterialsBloc() : super(InitialListMaterialsState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<ListMaterialsState> mapEventToState(ListMaterialsEvent event) async* {
    // Cabecera

    if (event is GetTableMaterials) {
      yield IsLoadingListMaterials();

      try {
        List<ReporteInspeccionMaterialModel> list =
            await inspectionPlanRepository.getTableMaterialRegisterIP(
                noPlanInspeccion: event.noPlanInspeccion,
                siteId: event.siteId,
                propuestaTecnicaId: event.propuestaTecnicaId,
                actividadId: event.actividadId,
                subActividadId: event.subActividadId,
                reprogramacionOTId: event.reprogramacionOTId);

        yield SuccessListMaterials(list: list);
      } catch (e) {
        yield ErrorListMaterials(errorMessage: e.toString());
      }
    }

    //
    if (event is UpdateReporteIP) {
      yield IsLoadingUpdateReporteIP();

      try {
        InsUpdateReporteIPModel insUpdateReporteIPModel =
            await inspectionPlanRepository.insUpdReporteInspeccionActividad(
                noPlanInspection: event.noPlanInspeccion,
                siteId: event.siteId,
                propuestaTecnicaId: event.propuestaTecnicaId,
                actividadId: event.actividadId,
                subActividadId: event.subActividadId,
                reprogramacionOTId: event.reprogramacionOTId,
                materialId: event.materialId,
                idTrazabilidad: event.idTrazabilidad,
                resultado: event.resultado,
                incluirReporte: event.incluirReporte,
                comentarios: event.comentarios);

        yield SuccessUpdateReporteIP(
            insUpdateReporteIPModel: insUpdateReporteIPModel);
      } catch (e) {
        yield ErrorListMaterials(errorMessage: e.toString());
      }
    }
  }
}

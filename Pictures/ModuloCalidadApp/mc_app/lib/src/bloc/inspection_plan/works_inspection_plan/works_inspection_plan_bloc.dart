import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/works_inspection_plan/works_inspection_plan_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/works_inspection_plan/works_inspection_plan_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class WorksInspectionPlanBloc
    extends Bloc<WorksInspectionPlanEvent, WorksInspectionPlanState> {
  WorksInspectionPlanBloc() : super(InitialWorksInspectionPlanState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<WorksInspectionPlanState> mapEventToState(
      WorksInspectionPlanEvent event) async* {
    // Contratos
    if (event is GetWorksByIdInspectionPlan) {
      yield IsLoadingWorksInspectionPlan();

      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' || event.contractId == null)
          throw ('Detalles al obtener el Contrato seleccionado.');

        List<WorksInspectionPlanModel> listWorksInspectionPlan =
            await inspectionPlanRepository.getWorkByContractInspectionPlan(
                contractId: event.contractId);

        yield SuccessWorksInspectionPlan(
            listWorksInspectionPlan: listWorksInspectionPlan);
      } catch (e) {
        yield ErrorWorksInspectionPlan(errorMessage: e.toString());
      }
    }
  }
}

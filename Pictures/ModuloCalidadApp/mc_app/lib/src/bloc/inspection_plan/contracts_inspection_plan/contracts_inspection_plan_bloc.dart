import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/contracts_inspection_plan/contracts_inspection_plan_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/contracts_inspection_plan/contracts_inspection_plan_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class ContractsInspectionPlanBloc
    extends Bloc<ContractsInspectionPlanEvent, ContractsInspectionPlanState> {
  ContractsInspectionPlanBloc() : super(InitialContractsInspectionPlanState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<ContractsInspectionPlanState> mapEventToState(
      ContractsInspectionPlanEvent event) async* {
    // Contratos
    if (event is GetContractsInspectionPlan) {
      yield IsLoadingContractInspectionPlan();

      try {
        //Se valida si se pudo obtener el id del contrato
        List<ContractsInspectionPlanModel> listContractsInspectionPlanModel =
            await inspectionPlanRepository.getContractsInspectionPlan();

        yield SuccessContractInspectionPlan(
            listContractsInspectionPlanModel: listContractsInspectionPlanModel);
      } catch (e) {
        yield ErrorContractInspectionPlan(errorMessage: e.toString());
      }
    }
  }
}

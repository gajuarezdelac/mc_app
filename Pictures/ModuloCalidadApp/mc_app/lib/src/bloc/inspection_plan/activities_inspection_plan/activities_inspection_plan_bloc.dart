import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/activities_inspection_plan/activities_inspection_plan_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/activities_inspection_plan/activities_inspection_plan_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class ActivitiesInspectionPlanBloc
    extends Bloc<ActivitiesInspectionPlanEvent, ActivitiesInspectionPlanState> {
  ActivitiesInspectionPlanBloc()
      : super(InitialActivitiesInspectionPlanState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<ActivitiesInspectionPlanState> mapEventToState(
      ActivitiesInspectionPlanEvent event) async* {
    // Cabecera
    if (event is GetHeaderInspectionPlan) {
      yield IsLoadingHeaderInspectionPlan();

      try {
        InspectionPlanHeaderModel inspectionPlanHeaderModel =
            await inspectionPlanRepository.getHeaderActivitiesByInspectionPlan(
                noPlanInspection: event.noInspectionPlan);

        yield SuccessHeaderInspectionPlan(
            inspectionPlanHeaderModel: inspectionPlanHeaderModel);
      } catch (e) {
        yield ErrorHeaderInspectionPlan(errorMessage: e.toString());
      }
    }
  }
}

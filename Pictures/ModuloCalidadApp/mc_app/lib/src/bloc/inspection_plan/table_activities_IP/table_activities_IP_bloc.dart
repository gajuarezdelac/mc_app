import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/table_activities_IP/table_activities_IP_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/table_activities_IP/table_activities_IP_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class TableActivitiesIPBloc
    extends Bloc<TableActivitiesIPEvent, TableActivitiesIPState> {
  TableActivitiesIPBloc() : super(InitialTableActivitiesIPState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<TableActivitiesIPState> mapEventToState(
      TableActivitiesIPEvent event) async* {
    // Cabecera

    if (event is GetTableInspectionPlan) {
      yield IsLoadingTableActivitiesIP();

      try {
        List<InspectionPlanDModel> inspectionPlanDModel =
            await inspectionPlanRepository.getATablectivitiesByInspectionPlan(
                noInspectionPlan: event.noInspectionPlan);

        yield SuccessTableActivitiesIP(
            inspectionPlanDModel: inspectionPlanDModel);
      } catch (e) {
        yield ErrorTableActivitiesIP(errorMessage: e.toString());
      }
    }
  }
}

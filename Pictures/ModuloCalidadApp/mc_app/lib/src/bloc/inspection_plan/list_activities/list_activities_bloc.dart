import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/list_activities/list_activities_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/list_activities/list_activities_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class ListActivitiesBloc
    extends Bloc<ListActivitiesEvent, ListActivitiesState> {
  ListActivitiesBloc() : super(InitialListActivitiesState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<ListActivitiesState> mapEventToState(
      ListActivitiesEvent event) async* {
    // Contratos
    if (event is GetListActivitiesC) {
      yield IsLoadingListActivities();

      try {
        List<InspectionPlanCModel> list =
            await inspectionPlanRepository.getListPlansInspection(
          contractId: event.contractId,
          workId: event.workId,
          clear: event.clear,
        );

        yield SuccessListActivities(list: list, clear: event.clear);
      } catch (e) {
        yield ErrorListActivities(errorMessage: e.toString());
      }
    }
  }
}

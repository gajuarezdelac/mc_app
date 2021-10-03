import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/work_traceability/work_traceability_event.dart';
import 'package:mc_app/src/bloc/tab_forming/work_traceability/work_traceability_state.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class WorkTraceabilityBloc
    extends Bloc<WorkTraceabilityEvent, WorkTraceabiltyState> {
  WorkTraceabilityBloc() : super(InitialWorkTraceabiltyState());

  final _traceabilityRepository = TraceabilityRepository();

  @override
  Stream<WorkTraceabiltyState> mapEventToState(
      WorkTraceabilityEvent event) async* {
    if (event is GetWorkTR) {
      yield IsLoadingWorkTR();

      try {
        List<WorkTraceability> worksT = await _traceabilityRepository
            .fetchWorkTraceabilty(contradoId: event.contratoId);

        yield SuccessGetWorkTR(worksT: worksT);
      } catch (e) {
        yield ErrorWorkTR(error: e.toString());
      }
    }
  }
}

import 'bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/repository/work_repository.dart';

class WorkCSBloc extends Bloc<WorkCSEvent, WorkCSState> {
  WorkCSBloc() : super(InitialWorkCSState());

  final _workRepository = WorkRepository();

  @override
  Stream<WorkCSState> mapEventToState(WorkCSEvent event) async* {
    if (event is GetWorksCS) {
      yield IsLoadingWorkCS();

      try {
        List<WorkDropDownModel> works =
            await _workRepository.getWorkCS(contractId: event.contractId);

        yield SuccessWorkCS(works: works);
      } catch (e) {
        yield ErrorWorkCS(error: e.toString());
      }
    }
  }
}

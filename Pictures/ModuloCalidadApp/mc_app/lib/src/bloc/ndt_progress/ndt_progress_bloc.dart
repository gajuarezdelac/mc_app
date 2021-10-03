import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/ndt_progress/ndt_progress_event.dart';
import 'package:mc_app/src/bloc/ndt_progress/ndt_progress_state.dart';
import 'package:mc_app/src/models/ndt_progress_model.dart';
import 'package:mc_app/src/repository/ndt_progress_repository.dart';

class NDTProgressBloc extends Bloc<NDTProgressEvent, NDTProgressState> {
  NDTProgressBloc() : super(InitialNDTProgressState());

  final _ndtProgress = NDTProgressRepository();

  @override
  Stream<NDTProgressState> mapEventToState(NDTProgressEvent event) async* {
    if (event is GetNDTProgress) {
      yield IsLoadingNDTProgress();

      try {
        List<NDTProgressModel> ndtProgress =
            await _ndtProgress.getNDTProgress(jointId: event.jointId);

        yield SuccessNDTProgress(jointNDTProgress: ndtProgress);
      } catch (e) {
        yield ErrorNDTProgress(error: e.toString());
      }
    }
  }
}

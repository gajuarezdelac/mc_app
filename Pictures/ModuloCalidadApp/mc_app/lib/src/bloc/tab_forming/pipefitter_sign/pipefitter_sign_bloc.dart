import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter_sign/pipefitter_sign_event.dart';
import 'package:mc_app/src/bloc/tab_forming/pipefitter_sign/pipefitter_sign_state.dart';
import 'package:mc_app/src/repository/pipefitter_repository.dart';

class PipefitterSignBloc
    extends Bloc<PipefitterSignEvent, PipefitterSignState> {
  PipefitterSignBloc() : super(InitialPipefitterSignState());

  final _repository = PipefitterRepository();

  @override
  Stream<PipefitterSignState> mapEventToState(
      PipefitterSignEvent event) async* {
    if (event is PipefitterSign) {
      yield IsSigningPipefitter();

      try {
        int result = await _repository.signPipefitter(
          employeeId: event.employeeId,
          jointId: event.jointId,
        );

        yield SuccessPipefitterSign(result: result);
      } catch (e) {
        yield ErrorPipefitterSign(error: e.toString());
      }
    }
  }
}

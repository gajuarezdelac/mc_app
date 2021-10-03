import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';
import '../bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DropDownStatusBloc
    extends Bloc<DropdownStatusEvent, DropDownStatusState> {
  DropDownStatusBloc() : super(InitialDropDownStatusState());

  final _statusRepository = ActivitiesRepository();

  @override
  Stream<DropDownStatusState> mapEventToState(
      DropdownStatusEvent event) async* {
    if (event is GetStatus) {
      yield IsLoadingStatus();
      try {
        List<EstatusIdModel> estatus = await _statusRepository.getStatus();
        yield SuccessStatus(estatus: estatus);
      } catch (e) {
        yield ErrorStatus(errorMessage: e.toString());
      }
    }
  }
}

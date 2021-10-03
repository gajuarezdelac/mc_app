import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/internal_departure/internal_departure_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/internal_departure/internal_departure_state.dart';
import 'package:mc_app/src/models/internal_departure_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class InternalDepartureBloc
    extends Bloc<InternalDepartureEvent, InternalDepartureState> {
  InternalDepartureBloc() : super(InitialInternalDepartureState());

  final _internalDepartureRepository = ActivitiesRepository();

  @override
  Stream<InternalDepartureState> mapEventToState(
      InternalDepartureEvent event) async* {
    if (event is GetInternalDeparture) {
      yield IsLoadingInternalDeparture();

      try {
        List<InternalDepartureModel> internalDepartureModel =
            await _internalDepartureRepository.getInternalDeparture(
          siteId: event.siteId,
          contractId: event.contractId,
          workId: event.workId,
        );

        yield SuccessInternalDeparture(
            internalDepartureModel: internalDepartureModel);
      } catch (e) {
        yield ErrorInternalDeparture(errorMessage: e.toString());
      }
    }
  }
}

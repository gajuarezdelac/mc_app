import 'bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/front_dropdown_model.dart';
import 'package:mc_app/src/repository/front_repository.dart';

class DropDownFrontBloc extends Bloc<DropDownFrontEvent, DropDownFrontState> {
  DropDownFrontBloc() : super(InitialDropDownFrontState());

  final _frontRepository = FrontRepository();

  @override
  Stream<DropDownFrontState> mapEventToState(DropDownFrontEvent event) async* {
    if (event is GetFronts) {
      yield IsLoadingFront();

      try {
        List<FrontDropdownModel> fronts = event.clear
            ? []
            : await _frontRepository.getFrontCS(
                planDetailId: event.planDetailId,
              );

        yield SuccessFront(fronts: fronts);
      } catch (e) {
        yield ErrorFront(errorMessage: e.toString());
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/inspection_plan/welder/welder_event.dart';
import 'package:mc_app/src/bloc/inspection_plan/welder/welder_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/repository/inspection_plan_repository.dart';

class WelderPlanBloc extends Bloc<WelderEvent, WelderState> {
  WelderPlanBloc() : super(InitialWelderState());

  final inspectionPlanRepository = InspectionPlanRepository();

  @override
  Stream<WelderState> mapEventToState(WelderEvent event) async* {
    if (event is GetInformacionadicionalEvent) {
      yield IsLoadingInformacionadicional();

      try {
        List<InformacionadicionalModel> response =
            await inspectionPlanRepository.getInformacionadicional(
                params: event.params);

        yield SuccessGetInformacionadicional(information: response);
      } catch (e) {
        yield ErrorGetInformationAditional(errorMessage: e.toString());
      }
    }

    if (event is AddWelderPlanEvent) {
      yield IsLoadingAddWelder();

      try {
        List<ResponseSaveWelder> response = await inspectionPlanRepository
            .addWelderGeneral(params: event.params);

        yield SuccessAddWelder(success: response);
      } catch (e) {
        yield ErrorGetWelderPlan(errorMessage: e.toString());
      }
    }

    if (event is AddTrazabilidadEvent) {
      yield IsLoadingAddTrazabilidad();

      try {
        int response = await inspectionPlanRepository.addTrazabilidadGeneral(
            params: event.params);

        yield SuccessAddTrazabilidad(response: response);
      } catch (e) {
        yield ErrorWelder(errorMessage: e.toString());
      }
    }

    if (event is GetWelderPlanEvent) {
      yield IsLoadingGetWelderPlan();

      try {
        FetchWelderModel response =
            await inspectionPlanRepository.getWelderPlan(noFicha: event.params);

        yield SuccessGetWelderPlan(welder: response);
      } catch (e) {
        yield ErrorGetWelderPlan(errorMessage: e.toString());
      }
    }
  }
}

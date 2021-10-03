import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_primaveraId/dropdown_primaveraId_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_primaveraId/dropdown_primaveraId_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class DropDownPrimaveraIdBloc
    extends Bloc<DropdownPrimaveraIdEvent, DropDownPrimaveIdState> {
  DropDownPrimaveraIdBloc() : super(InitialDropDownPrimaveraIdState());

  final _primaveraIdRepository = ActivitiesRepository();

  @override
  Stream<DropDownPrimaveIdState> mapEventToState(
      DropdownPrimaveraIdEvent event) async* {
    if (event is GetPrimaveraId) {
      yield IsLoadingPrimaveraId();
      try {
        //Se valida si se pudo obtener el id del contrato
        if (event.contractId == '' ||
            event.contractId == null && event.obraId == '' ||
            event.obraId == null)
          throw ('Detalles al obtener PrimaveraId. ${event.obraId}');
        List<PrimaveraIdModel> primaveraIdModel = await _primaveraIdRepository
            .getPrimaveraId(contratoId: event.contractId, obraId: event.obraId);

        yield SuccessPrimaveraId(primaveraModel: primaveraIdModel);
      } catch (e) {
        yield ErrorPrimaveraId(errorMessage: e.toString());
      }
    }
  }
}

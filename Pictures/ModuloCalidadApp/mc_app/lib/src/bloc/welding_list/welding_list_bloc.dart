import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/welding_list/welding_list_event.dart';
import 'package:mc_app/src/bloc/welding_list/welding_list_state.dart';
import 'package:mc_app/src/models/joint_wc_model.dart';
import 'package:mc_app/src/repository/welding_repository.dart';

class WeldingListBloc extends Bloc<WeldingListEvent, WeldingListState> {
  WeldingListBloc() : super(InitialWeldingListState());

  final _weldingRepository = WeldingRepository();

  @override
  Stream<WeldingListState> mapEventToState(WeldingListEvent event) async* {
    if (event is GetJointsWC) {
      yield IsLoadingWeldingList();

      try {
        //Se valida si se pudo obtener el id de la obra
        /*if (event.workId == '' || event.workId == null)
          throw ('Detalles al obtener la Obra seleccionada.');*/

        List<JointWCModel> joints = await _weldingRepository.getJointsWC(
          plainDetailId: event.plainDetailId,
          frontId: event.frontId,
          state: event.state,
          clear: event.clear,
        );

        yield SuccessWeldingList(joints: joints);
      } catch (e) {
        yield ErrorWeldingList(errorMessage: e.toString());
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';
import 'package:mc_app/src/repository/plain_detail_repository.dart';
import 'package:mc_app/src/bloc/dropdown_plain_detail/dropdown_plain_detail_event.dart';
import 'package:mc_app/src/bloc/dropdown_plain_detail/dropdown_plain_detail_state.dart';

class DropDownPlainDetailBloc
    extends Bloc<DropDownPlainDetailEvent, DropDownPlainDetailState> {
  DropDownPlainDetailBloc() : super(InitialDropDownPlainDetailState());

  final _plainDetailRepository = PlainDetailRepository();

  @override
  Stream<DropDownPlainDetailState> mapEventToState(
      DropDownPlainDetailEvent event) async* {
    if (event is GetPlainDetails) {
      yield IsLoadingPlainDetails();

      try {
        //Se valida si se pudo obtener el id de la obra
        if (event.workId == '' || event.workId == null)
          throw ('Detalles al obtener la Obra seleccionada.');

        List<PlainDetailDropDownModel> plainDetails = event.clear == true
            ? []
            : await _plainDetailRepository.getPlanCS(workId: event.workId);

        yield SuccessPlainDetails(plainDetails: plainDetails);
      } catch (e) {
        yield ErrorPlainDetails(errorMessage: e.toString());
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_anexo/dropdown_anexo_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_anexo/dropdown_anexo_state.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';
import '../bloc.dart';

class DropDownAnexoBloc extends Bloc<DropdownAnexoEvent, DropDownAnexoState> {
  DropDownAnexoBloc() : super(InitialDropDownAnexoState());

  final _anexoRepository = ActivitiesRepository();

  @override
  Stream<DropDownAnexoState> mapEventToState(DropdownAnexoEvent event) async* {
    if (event is GetAnexo) {
      yield IsLoadingAnexo();
      try {
        List<AnexoModel> anexo = await _anexoRepository.getAnexo();
        yield SuccessAnexo(anexo: anexo);
      } catch (e) {
        yield ErrorAnexo(errorMessage: e.toString());
      }
    }
  }
}

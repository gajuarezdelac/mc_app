import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_aplication/coating_aplication_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_aplication/coating_aplication_state.dart';
import 'package:mc_app/src/models/coating_aplication_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class CoatingAplicationBloc extends Bloc<CoatingAplicationEvent, CoatingAplicationState> {
  CoatingAplicationBloc() : super(InitialCoatingAplicationState());

  final _anticorrosiveProtectionRepository =
      AnticorrosiveProtectionRepository();

  @override
  Stream<CoatingAplicationState> mapEventToState(CoatingAplicationEvent event) async* {
    if (event is GetCoatingAplication) {
      yield IsLoadingCoatingAplication();

      try {
        List<CoatingAplicationModel> data =
            await _anticorrosiveProtectionRepository
                .selCoatingAplication(event.noRegistro);

        yield SuccessCoatingAplication(data: data);
      } catch (e) {
        yield ErrorCoatingAplication(errorMessage: e.toString());
      }
    }

    if (event is InsUpdCoatingAplication) {
      yield IsLoadingCoatingAplication();

      try {
        await _anticorrosiveProtectionRepository.insUpdCoatingApplication(event.params, event.noRegistro);

        yield SuccessInsUpdCoatingAplication();
      } catch (e) {
        yield ErrorCoatingAplication(errorMessage: e.toString());
      }
    }
  }
}

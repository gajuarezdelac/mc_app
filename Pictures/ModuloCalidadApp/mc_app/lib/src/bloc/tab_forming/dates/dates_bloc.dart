import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/dates/dates_event.dart';
import 'package:mc_app/src/bloc/tab_forming/dates/dates_state.dart';
import 'package:mc_app/src/repository/welding_repository.dart';

class DatesBloc extends Bloc<DatesEvent, DatesState> {
  DatesBloc() : super(InitialDatesState());

  final _repository = WeldingRepository();

  @override
  Stream<DatesState> mapEventToState(DatesEvent event) async* {
    if (event is SetDates) {
      yield IsLoadingDates();

      try {
        int result = await _repository.saveFormingCS(params: event.params);
        String message;
        String action;

        switch (event.params.action) {
          case 'GUARDAR':
            message = 'Informacion guardada exitosamente.';
            action = event.params.action;
            break;
          case 'LIBERAR':
            message = 'El conformado ha sido liberado.';
            action = event.params.action;
            break;
          case 'D/N':
            message =
                'La inspección visual del conformado se ha llevado a cabo y se encuentra Dentro de Norma.';
            action = event.params.action;
            break;
          case 'F/N':
            message =
                'La inspección visual del conformado se ha llevado a cabo y se encuentra Fuera de Norma.';
            action = event.params.action;
            break;
          case 'REPAIR':
            message = 'Proceso de reparación realizado exitosamente.';
            action = event.params.action;
            break;
          default:
            message = '';
            action = '';
        }

        yield SuccessDates(result: result, message: message, action: action);
      } catch (e) {
        yield ErrorDates(error: e.toString());
      }
    }
  }
}

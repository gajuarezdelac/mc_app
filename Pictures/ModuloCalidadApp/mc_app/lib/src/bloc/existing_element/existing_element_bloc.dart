import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/existing_element/existing_element_event.dart';
import 'package:mc_app/src/bloc/existing_element/existing_element_state.dart';
import 'package:mc_app/src/models/existing_element_model.dart';
import 'package:mc_app/src/repository/traceability_repository.dart';

class ExistingElementBloc extends Bloc<ExistingElementEvent, ExistingElementState> {
  ExistingElementBloc() : super(InitialExistingElementState());

  final _traceabilityRepository = TraceabilityRepository();

  @override
  Stream<ExistingElementState> mapEventToState(ExistingElementEvent event) async* {
    if (event is GetExistingElement) {
      yield IsLoadingExistingElement();

      try {
        List<ExistingElementModel> existingElement =
            await _traceabilityRepository.getExistingElement(idElementoExistente: event.idElementoExistente);

        yield SuccessExistingElement(existingElement: existingElement);
      } catch (e) {
        yield ErrorExistingElement(errorMessage: e.toString());
      }
    }
  }
}
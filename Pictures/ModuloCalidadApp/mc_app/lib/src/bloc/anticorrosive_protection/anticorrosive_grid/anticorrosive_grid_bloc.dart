import '../bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class AnticorrosiveGridBloc
    extends Bloc<AnticorrosiveGridEvent, AnticorrosiveGridState> {
  AnticorrosiveGridBloc() : super(InitialGetAntiItemsState());

  final _repo = AnticorrosiveProtectionRepository();

  @override
  Stream<AnticorrosiveGridState> mapEventToState(
      AnticorrosiveGridEvent event) async* {
    if (event is GetAnticorrosiveItems) {
      yield IsLoadingAntiItems();

      try {
        List<AnticorrosiveProtectionModel> data =
            await _repo.getPaginatorAnticorrosive(params: event.params);

        yield SuccessAntiItems(data: data);
      } catch (e) {
        yield ErrorAntiItems(error: e.toString());
      }
    }
  }
}

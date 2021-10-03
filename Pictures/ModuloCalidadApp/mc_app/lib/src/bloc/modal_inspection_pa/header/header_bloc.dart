import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/header/header_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/header/header_state.dart';
import 'package:mc_app/src/models/anticorrosive_protection_header_model.dart';
import 'package:mc_app/src/repository/anticorrosive_protection_repository.dart';

class HeaderBloc extends Bloc<HeaderEvent, HeaderState> {
  HeaderBloc() : super(InitialHeaderState());

  final _anticorrosiveProtectionRepository = AnticorrosiveProtectionRepository();

  @override
  Stream<HeaderState> mapEventToState(HeaderEvent event) async* {
    if(event is GetHeader) {
      yield IsLoadingHeader();

      try {
        AnticorrosiveProtectionHeaderModel anticorrosiveProtectionHeaderModel =
          await _anticorrosiveProtectionRepository.selAnticorrosiveHeader(event.noRegistro);

          yield SuccessHeader(anticorrosiveProtectionHeaderModel: anticorrosiveProtectionHeaderModel);
      }
      catch (e) {
        yield ErrorHeader(error: e.toString());
      }
    }
  }
}
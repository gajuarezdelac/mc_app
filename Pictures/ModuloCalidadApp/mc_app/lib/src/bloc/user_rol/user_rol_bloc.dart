import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/user_rol/user_rol_event.dart';
import 'package:mc_app/src/bloc/user_rol/user_rol_state.dart';
import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/repository/avatar_repository.dart';

class UserRolBloc extends Bloc<UserRolEvent, UserRolState> {
  UserRolBloc() : super(InitialUserRolState());

  final _userRolRepository = AvatarRepository();
  /*@override
  DropDownContractState get initialState => InitialDropDownContractState();*/

  @override
  Stream<UserRolState> mapEventToState(UserRolEvent event) async* {
    yield IsLoadingGetUserRol();
    if (event is GetInfoUserRol) {
      try {
        UserGeneral userGeneral =
            await _userRolRepository.getRolUser(ficha: event.ficha);

        yield SuccessGetUserRol(userGeneral: userGeneral);
      } catch (e) {
        yield ErrorGetUserRol(errorMessage: e.toString());
      }
    }
  }
}

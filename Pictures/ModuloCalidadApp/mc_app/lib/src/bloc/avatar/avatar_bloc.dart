import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/avatar/avatar_event.dart';
import 'package:mc_app/src/bloc/avatar/avatar_state.dart';
import 'package:mc_app/src/models/user_avatar_model.dart';
import 'package:mc_app/src/repository/avatar_repository.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc() : super(InitialAvatarState());

  final _avatarRepository = AvatarRepository();
  /*@override
  DropDownContractState get initialState => InitialDropDownContractState();*/

  @override
  Stream<AvatarState> mapEventToState(AvatarEvent event) async* {
    yield IsLoading();
    if (event is GetInfoAvatar) {
      try {
        UserAvatarModel userAvatarModel =
            await _avatarRepository.getInfoAvatar(ficha: event.ficha);

        yield Success(userAvatarModel: userAvatarModel);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    }
  }
}

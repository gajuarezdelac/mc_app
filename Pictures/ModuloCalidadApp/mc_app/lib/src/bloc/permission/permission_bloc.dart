import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/permission/permission_event.dart';
import 'package:mc_app/src/bloc/permission/permission_state.dart';
import 'package:mc_app/src/models/user_permission_model.dart';
import 'package:mc_app/src/repository/avatar_repository.dart';

class UserPermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  UserPermissionBloc() : super(InitialPermissionState());

  final _user = AvatarRepository();

  @override
  Stream<PermissionState> mapEventToState(PermissionEvent event) async* {
    yield IsLoadingGetPermission();
    if (event is GetPermission) {
      try {
        UserPermissionModel permissions =
            await _user.getPermissions(card: event.ficha);

        yield SuccessGetPermission(permissions: permissions);
      } catch (e) {
        yield ErrorGetPermission(error: e.toString());
      }
    }
  }
}

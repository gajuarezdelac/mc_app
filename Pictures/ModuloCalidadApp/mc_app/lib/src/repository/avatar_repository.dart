import 'package:mc_app/src/data/dao/user_dao.dart';

class AvatarRepository {
  final userDao = UserDao();

  Future getInfoAvatar({String ficha}) => userDao.fetchInfoAvatar(ficha);

  Future getRolUser({int ficha}) => userDao.getUserGeneral(ficha);

  Future getPermissions({int card}) => userDao.fetchUserPermission(card);
}

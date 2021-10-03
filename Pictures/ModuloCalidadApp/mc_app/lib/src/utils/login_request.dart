import 'dart:async';
import 'package:mc_app/src/data/dao/user_dao.dart';
import 'package:mc_app/src/models/user_off_model.dart';

class LoginRequest {
  UserDao con = new UserDao();

  Future<UserModelOff> getLogin(
      String ficha, String email, String fecheIngreso) {
    var result = con.getLogin(ficha, email, fecheIngreso);
    return result;
  }
}


import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/utils/login_request.dart';

abstract class LoginCallBack {
  void onLoginSuccess(UserModelOff user);
  void onLoginError(String error);
}

class LoginResponse {
  LoginCallBack _callBack;
  LoginRequest loginRequest = new LoginRequest();
  LoginResponse(this._callBack);

  doLogin(String ficha, String email, String fechaIngreso) {
    loginRequest
        .getLogin(ficha, email, fechaIngreso)
        .then((user) => _callBack.onLoginSuccess(user))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  }
}

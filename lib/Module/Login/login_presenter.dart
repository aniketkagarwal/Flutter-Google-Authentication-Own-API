import 'dart:async';

import 'package:gmail/google.dart' as google;
import 'package:gmail/constants.dart';

abstract class LoginViewContract {
  void onLoginSuccess(google.Token token);
  void onLoginError(String message);
}

class LoginPresenter {
  LoginViewContract _view;
  LoginPresenter(this._view);

  void perform_login() {
    assert(_view != null);
    google.getToken(constants.APP_ID, constants.APP_SECRET).then((token){
      if (token != null) {
        _view.onLoginSuccess(token);
      }
      else{
        _view.onLoginError('Error');
      }
    });
  }
}
import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/login_screen/model/loginModel.dart';
import 'package:delivery_on_time/login_screen/repository/loginRepository.dart';

class LoginBloc {

  LoginRepository _loginRepository;

  StreamController _loginController;

  StreamSink<ApiResponse<LoginModel>> get loginSink =>
      _loginController.sink;

  Stream<ApiResponse<LoginModel>> get loginStream =>
      _loginController.stream;


  LoginBloc() {
    _loginController = StreamController<ApiResponse<LoginModel>>.broadcast();
    _loginRepository = LoginRepository();
  }

  login(Map body) async {
    loginSink.add(ApiResponse.loading("Submitting",));
    try {
      LoginModel response = await _loginRepository.login(body);
      loginSink.add(ApiResponse.completed(response));
    } catch (e) {
      loginSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _loginController?.close();
    loginSink?.close();
  }
}
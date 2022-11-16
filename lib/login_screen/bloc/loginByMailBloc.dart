import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/login_screen/model/loginByMailModel.dart';
import 'package:delivery_on_time/login_screen/repository/loginRepository.dart';

class LoginByMailBloc {

  LoginRepository _loginRepository;

  StreamController _loginByMailController;

  StreamSink<ApiResponse<LoginByMailModel>> get loginByMailSink =>
      _loginByMailController.sink;

  Stream<ApiResponse<LoginByMailModel>> get loginByMailStream =>
      _loginByMailController.stream;


  LoginByMailBloc() {
    _loginByMailController = StreamController<ApiResponse<LoginByMailModel>>.broadcast();
    _loginRepository = LoginRepository();
  }

  loginByMail(Map body) async {
    loginByMailSink.add(ApiResponse.loading("Submitting",));
    try {
      LoginByMailModel response = await _loginRepository.loginByMail(body);
      loginByMailSink.add(ApiResponse.completed(response));
    } catch (e) {
      loginByMailSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _loginByMailController?.close();
    loginByMailSink?.close();
  }
}
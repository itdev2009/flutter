import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/model/loginByMobileModel.dart';
import 'package:delivery_on_time/loginMobile_screen/repository/loginByMobileRepository.dart';

class LoginByMobileBloc {

  LoginByMobileRepository _loginByMobileRepository;

  StreamController _loginByMobileController;

  StreamSink<ApiResponse<LoginByMobileModel>> get loginByMobileSink =>
      _loginByMobileController.sink;

  Stream<ApiResponse<LoginByMobileModel>> get loginByMobileStream =>
      _loginByMobileController.stream;


  LoginByMobileBloc() {
    _loginByMobileController = StreamController<ApiResponse<LoginByMobileModel>>.broadcast();
    _loginByMobileRepository = LoginByMobileRepository();
  }

  loginByMobile(Map body) async {
    loginByMobileSink.add(ApiResponse.loading("Submitting",));
    try {
      LoginByMobileModel response = await _loginByMobileRepository.loginByMobile(body);
      loginByMobileSink.add(ApiResponse.completed(response));
    } catch (e) {
      loginByMobileSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _loginByMobileController?.close();
    loginByMobileSink?.close();
  }
}
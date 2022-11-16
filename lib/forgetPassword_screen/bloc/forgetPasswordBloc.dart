import 'dart:async';
import 'package:delivery_on_time/forgetPassword_screen/model/forgetPasswordModel.dart';
import 'package:delivery_on_time/forgetPassword_screen/repository/forgetPasswordRepository.dart';
import 'package:delivery_on_time/help/api_response.dart';

class ForgetPasswordBloc {

  ForgetPasswordRepository _forgetPasswordRepository;

  StreamController _forgetPasswordController;

  StreamSink<ApiResponse<ForgetPasswordModel>> get forgetPasswordSink =>
      _forgetPasswordController.sink;

  Stream<ApiResponse<ForgetPasswordModel>> get forgetPasswordStream =>
      _forgetPasswordController.stream;


  ForgetPasswordBloc() {
    _forgetPasswordController = StreamController<ApiResponse<ForgetPasswordModel>>.broadcast();
    _forgetPasswordRepository = ForgetPasswordRepository();
  }

  passwordChange(Map body) async {
    forgetPasswordSink.add(ApiResponse.loading("Submitting",));
    try {
      ForgetPasswordModel response = await _forgetPasswordRepository.forgetPassword(body);
      forgetPasswordSink.add(ApiResponse.completed(response));
    } catch (e) {
      forgetPasswordSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _forgetPasswordController?.close();
    forgetPasswordSink?.close();
  }
}
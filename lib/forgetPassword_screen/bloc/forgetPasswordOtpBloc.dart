import 'dart:async';
import 'package:delivery_on_time/forgetPassword_screen/model/forgetPasswordOtpModel.dart';
import 'package:delivery_on_time/forgetPassword_screen/repository/forgetPasswordRepository.dart';
import 'package:delivery_on_time/help/api_response.dart';

class ForgetPasswordOtpBloc {

  ForgetPasswordRepository _forgetPasswordRepository;

  StreamController _forgetPasswordOtpController;

  StreamSink<ApiResponse<ForgetPasswordOtpModel>> get forgetPasswordOtpSink =>
      _forgetPasswordOtpController.sink;

  Stream<ApiResponse<ForgetPasswordOtpModel>> get forgetPasswordOtpStream =>
      _forgetPasswordOtpController.stream;


  ForgetPasswordOtpBloc() {
    _forgetPasswordOtpController = StreamController<ApiResponse<ForgetPasswordOtpModel>>.broadcast();
    _forgetPasswordRepository = ForgetPasswordRepository();
  }

  otp(Map body) async {
    forgetPasswordOtpSink.add(ApiResponse.loading("Submitting",));
    try {
      ForgetPasswordOtpModel response = await _forgetPasswordRepository.forgetPasswordOtp(body);
      forgetPasswordOtpSink.add(ApiResponse.completed(response));
    } catch (e) {
      forgetPasswordOtpSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _forgetPasswordOtpController?.close();
    forgetPasswordOtpSink?.close();
  }
}
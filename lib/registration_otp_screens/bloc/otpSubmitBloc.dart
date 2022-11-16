import 'dart:async';

import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/registration_otp_screens/model/otpSubmitResponseModel.dart';
import 'package:delivery_on_time/registration_otp_screens/repository/registrationRepository.dart';

class OtpSubmitBloc {

  RegistrationRepository _registrationRepository;

  StreamController _otpSubmitController;

  StreamSink<ApiResponse<OtpSubmitResponseModel>> get otpSubmitSink =>
      _otpSubmitController.sink;

  Stream<ApiResponse<OtpSubmitResponseModel>> get otpSubmitStream =>
      _otpSubmitController.stream;


  OtpSubmitBloc() {
    _otpSubmitController = StreamController<ApiResponse<OtpSubmitResponseModel>>();
    _registrationRepository = RegistrationRepository();
  }

  otpSubmit(Map body, String token) async {
    otpSubmitSink.add(ApiResponse.loading("Submitting",));
    try {
      OtpSubmitResponseModel response = await _registrationRepository.otpSubmit(body,token);
      otpSubmitSink.add(ApiResponse.completed(response));
    } catch (e) {
      otpSubmitSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _otpSubmitController?.close();
    otpSubmitSink?.close();
  }
}
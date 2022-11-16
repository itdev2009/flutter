import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/registration_otp_screens/model/registrationModel.dart';
import 'package:delivery_on_time/registration_otp_screens/repository/registrationRepository.dart';

class RegistraionBloc {

  RegistrationRepository _registrationRepository;

  StreamController _registrationController;

  StreamSink<ApiResponse<RegistrationModel>> get registrationSink =>
      _registrationController.sink;

  Stream<ApiResponse<RegistrationModel>> get registrationStream =>
      _registrationController.stream;


  RegistraionBloc() {
    _registrationController = StreamController<ApiResponse<RegistrationModel>>.broadcast();
    _registrationRepository = RegistrationRepository();
  }

  Register(Map body) async {
    registrationSink.add(ApiResponse.loading("Submitting",));
    try {
      RegistrationModel response = await _registrationRepository.registration(body);
      registrationSink.add(ApiResponse.completed(response));
    } catch (e) {
      registrationSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _registrationController?.close();
    registrationSink?.close();
  }
}

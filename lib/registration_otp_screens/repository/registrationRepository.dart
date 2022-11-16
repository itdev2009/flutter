import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/registration_otp_screens/model/otpSubmitResponseModel.dart';
import 'package:delivery_on_time/registration_otp_screens/model/registrationModel.dart';

class RegistrationRepository {

  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();

  Future<RegistrationModel> registration(Map _body) async {
    Map body = _body;
    final response= await _apiBaseHelper.post("register", body);
    return RegistrationModel.fromJson(response);
  }

  Future<OtpSubmitResponseModel> otpSubmit(Map _body,String _token) async {

    final response= await _apiBaseHelper.postWithHeader("verify/mobile", _body, "Bearer $_token");
    return OtpSubmitResponseModel.fromJson(response);
  }
}

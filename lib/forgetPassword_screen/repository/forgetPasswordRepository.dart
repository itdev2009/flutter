import 'package:delivery_on_time/forgetPassword_screen/model/forgetPasswordModel.dart';
import 'package:delivery_on_time/forgetPassword_screen/model/forgetPasswordOtpModel.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/login_screen/model/loginModel.dart';

class ForgetPasswordRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<ForgetPasswordOtpModel> forgetPasswordOtp(Map _body) async {
    Map body = _body;
    final response= await _apiBaseHelper.post("recover/password/get_otp", body);
    return ForgetPasswordOtpModel.fromJson(response);
  }
  Future<ForgetPasswordModel> forgetPassword(Map _body) async {
    Map body = _body;
    final response= await _apiBaseHelper.post("recover/password/set", body);
    return ForgetPasswordModel.fromJson(response);
  }
}
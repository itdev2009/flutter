import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/login_screen/model/loginByMailModel.dart';
import 'package:delivery_on_time/login_screen/model/loginModel.dart';

class LoginRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<LoginModel> login(Map _body) async {
    Map body = _body;
    final response= await _apiBaseHelper.post("login", body);
    return LoginModel.fromJson(response);
  }

  Future<LoginByMailModel> loginByMail(Map _body) async {
    Map body = _body;
    final response= await _apiBaseHelper.post("login_by_mail", body);
    return LoginByMailModel.fromJson(response);
  }
}
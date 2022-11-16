import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/loginMobile_screen/model/loginByMobileModel.dart';

class LoginByMobileRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<LoginByMobileModel> loginByMobile(Map _body) async {
    Map body = _body;
    final response= await _apiBaseHelper.post("user/login", body);
    return LoginByMobileModel.fromJson(response);
  }

}
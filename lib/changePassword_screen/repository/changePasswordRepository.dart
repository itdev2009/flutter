
import 'package:delivery_on_time/changePassword_screen/model/changePasswordModel.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';

class ChangePasswordRepository{
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();

  Future<ChangePasswordModel> changePassword(body,token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("user/password/change", body,"Bearer $token");
    return ChangePasswordModel.fromJson(response);
  }



}
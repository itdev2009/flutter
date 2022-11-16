import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/login_screen/model/loginModel.dart';
import 'package:delivery_on_time/version_check/model/versionCheckModel.dart';

class VersionCheckRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<VersionCheckModel> vCheck( ) async {
    final response= await _apiBaseHelper.get("version/customer");
    return VersionCheckModel.fromJson(response);
  }
}
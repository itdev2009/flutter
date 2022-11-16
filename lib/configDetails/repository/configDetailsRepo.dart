import 'package:delivery_on_time/configDetails/model/configDetailsModel.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';

class ConfigDetailsRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<ConfigDetailsModel> configDetails(String token) async {
    final response= await _apiBaseHelper.getWithHeader("config", "Bearer $token");
    return ConfigDetailsModel.fromJson(response);
  }
}
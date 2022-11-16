import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/search_screen/model/foodSearchModel.dart';

class SearchRepository{
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();

  Future<FoodSearchModel> search(Map body) async{
    // Map body={};
    final response= await _apiBaseHelper.post("product/search", body);
    return FoodSearchModel.fromJson(response);
  }
}
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/ratingScreen/model/ratingModel.dart';

class RatingRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<RatingModel> rating(Map body,String token) async {
    final response= await _apiBaseHelper.postWithHeader("feedback/save", body,token);
    return RatingModel.fromJson(response);
  }


}
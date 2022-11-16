import 'package:delivery_on_time/cart_screen/model/couponApplyModel.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';

class CouponCodeRepository{
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();

  Future<CouponApplyModel> couponApply(Map body,String token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("apply/coupon", body,"Bearer $token");
    return CouponApplyModel.fromJson(response);
  }
}
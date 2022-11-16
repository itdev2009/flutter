import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/restaurants_screen/model/allCouponModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/foodDetailsModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/foodParentCategoryModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/recentOrdersModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/restaurantsListModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/subCategoriesModel.dart';

class FoodHomeRepository{
  ApiBaseHelper _helper=new ApiBaseHelper();

  Future<RestaurantsListModel> restaurantsList(int _id) async{

    Map body={
      "category_id":"$_id"
    };
    final response = await _helper.post("vendors/all", body);
    return RestaurantsListModel.fromJson(response);
  }

  Future<FoodDetailsModel> foodDetails(_categoryId,_vendorId,_cartId) async{

    final response = await _helper.get("productlist?category_id=$_categoryId&vendor_id=$_vendorId&cartid=$_cartId");
    return FoodDetailsModel.fromJson(response);
  }

  Future<FoodParentCategoryModel> foodParentCategory() async{

    Map body={};
    final response = await _helper.post("menu", body);
    return FoodParentCategoryModel.fromJson(response);
  }

  Future<RecentOrdersModel> recentOrders(_body,_token) async{

    final response = await _helper.postWithHeader("order/recent", _body,"Bearer $_token");
    return RecentOrdersModel.fromJson(response);
  }

  Future<AllCouponModel> allCouponList() async{

    Map body={};
    final response = await _helper.post("active/coupon", body);
    return AllCouponModel.fromJson(response);
  }

  Future<SubCategoriesModel> subCategories() async{

    Map body={};
    final response = await _helper.post("categories", body);
    return SubCategoriesModel.fromJson(response);
  }

}
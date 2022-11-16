import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/orderDetails_screen/model/orderDetailsModel.dart';
import 'package:delivery_on_time/orderDetails_screen/model/orderListModel.dart';

class OrderDetailsRepository{
  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<OrderDetailsModel> orderDetails(_body,_token) async{

    final response = await _apiBaseHelper.postWithHeader("user/order/list", _body,"Bearer $_token");
    return OrderDetailsModel.fromJson(response);
  }
  Future<OrderListModel> orderList(_body,_token) async{

    final response = await _apiBaseHelper.postWithHeader("user/order/list", _body,"Bearer $_token");
    return OrderListModel.fromJson(response);
  }
}
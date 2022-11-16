import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/orderPlace_paymennt/model/OrderPlaceResponseModel.dart';
import 'package:delivery_on_time/orderPlace_paymennt/model/OrderPlaceStatusModel.dart';
import 'package:flutter/material.dart';

class OrderPlaceRepository{
  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<OrderPlaceResponseModel> orderPlace(body,token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("order/place", body,"Bearer $token");
    return OrderPlaceResponseModel.fromJson(response);
  }

  Future<OrderPlaceStatusModel> orderPlaceStatus(body,token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("order/status/update", body,"Bearer $token");
    return OrderPlaceStatusModel.fromJson(response);
  }
}
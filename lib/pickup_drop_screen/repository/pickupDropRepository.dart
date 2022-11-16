import 'dart:convert';
import 'dart:io';
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/help/app_exceptions.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickDropOrderListModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropShowModel.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class PickupDropRepository{
  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  /*
  Future<PickupDropModel> pickupDropRequest(String _token,Map _body) async {
    final response= await _apiBaseHelper.postWithHeader("pickup/create", _body,"Bearer $_token");
    return PickupDropModel.fromJson(response);
  }

   */

  Future<PickupDropModel> pickupDropRequest(String _token,Map _body) async {
    final response= await _apiBaseHelper.postWithHeader("pickup/create-multiple", _body,"Bearer $_token");
    return PickupDropModel.fromJson(response);
  }



  Future<PickupDropShowModel> pickupDropShowAll(String _token) async {
    final response= await _apiBaseHelper.getWithHeader("pickup","Bearer $_token");
    return PickupDropShowModel.fromJson(response);
  }

  Future<PickupDropOrderListModel> pickupDropOrderList(String _token) async {
    final response= await _apiBaseHelper.getWithHeader("pickup","Bearer $_token");
    return PickupDropOrderListModel.fromJson(response);
  }
  Future<PickUpDropOrderDetailsModel> pickupDropOrderdetails(String _token, int id) async {

    Map body={
      "pickup_id": id.toString(),
    };
    final response= await _apiBaseHelper.postWithHeader("pickup/details-multiple",body,"Bearer $_token");
    return PickUpDropOrderDetailsModel.fromJson(response);
  }

  Future<MapDistanceModel> mapDistanceCalculate(double _senderLat,double _senderLong,double _receiverLat,double _receiverLong) async {
    String _url="https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$_senderLat,$_senderLong&destinations=$_receiverLat,$_receiverLong&key=AIzaSyCuGtIzD0qfGOsZjXtqaIu5syeDVZUrLUI";
    final response= await getForMap(_url);


    print('printing distance values in repo');
    print(response);
    print(response['rows'][0]['elements'][0]['distance']['value']);
    distanceList.add(response['rows'][0]['elements'][0]['distance']['value']);



    return MapDistanceModel.fromJson(response);
  }

  Future<dynamic> getForMap(String url) async {
    print('Api Get, url $url');
    print(url);
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print(jsonEncode(responseJson));
    print('api get recieved!');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        print(response.body.toString());
        var responseJson = json.decode(response.body.toString());
        // print(responseJson);
        return responseJson;
      case 201:
        print(response.body.toString());
        var responseJson = json.decode(response.body.toString());
        // print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response
                .statusCode}');
    }
  }
}
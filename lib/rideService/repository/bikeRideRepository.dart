import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/help/app_exceptions.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/rideService/model/bikeRideCreateModel.dart';
import 'package:delivery_on_time/rideService/model/bikeRideCancelModel.dart';
import 'package:delivery_on_time/rideService/model/bikeRideRateModel.dart';
import 'package:delivery_on_time/rideService/model/bikerAvailableModel.dart';
import 'package:delivery_on_time/rideService/model/rideBookingDetailsModel.dart';
import 'package:delivery_on_time/rideService/model/rideBookingListModel.dart';
import 'package:delivery_on_time/rideService/model/sucessModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:delivery_on_time/rideService/model/reassignmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';


class BikeRideRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();
  //SharedPreferences prefs = await SharedPreferences.getInstance();

  Future<BikerAvailableModel> availableBike(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/available-carriers", _body, "Bearer $token");
    print('BIKE AVAILABLE RESPONSE:');
    print(response);
    return BikerAvailableModel.fromJson(response);
  }

  Future<BikeRideRateModel> rideRate(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/get-fare", _body, "Bearer $token");
    return BikeRideRateModel.fromJson(response);
  }

  Future<BikeRideRateModel> reqBooking(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/request-booking", _body, "Bearer $token");
    print('printing request response :');
    print(response);
    print(response['data']['id']);
    rideId = response['data']['id'];
    //return BikeRideRateModel.fromJson(response);


  }

  Future<SuccessModel> acceptReq(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/accept", _body, "Bearer $token");
    print(response.toString());
    //return BikeRideRateModel.fromJson(response);
   // final data =  jsonDecode(response);
    //print('printing ride success :');
   // print(data);
    return SuccessModel.fromJson(response);

  }

  Future<BikeRideRateModel> offerMore(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/sendtripRequestMoreOffer", _body, "Bearer $token");
    print(response.toString());
    //return BikeRideRateModel.fromJson(response);
  }

  Future<BikeRideCreateModel> rideCreate(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/create", _body, "Bearer $token");
    return BikeRideCreateModel.fromJson(response);
  }




  Future<BikeRideCancelModel> rideCancel(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("trip/cancel", _body, "Bearer $token");
    return BikeRideCancelModel.fromJson(response);
  }

  Future<RideBookingListModel> rideBookingList(String token) async {
    final response= await _apiBaseHelper.getWithHeader("trip/customer","Bearer $token");
    return RideBookingListModel.fromJson(response);
  }

  Future<RideBookingListModel> rideHomerideBookingList(String token) async {
    final response= await _apiBaseHelper.getWithHeader("trip/customer/transit","Bearer $token");
    return RideBookingListModel.fromJson(response);
  }

  Future<RideBookingDetailsModel> rideBookingDetails(int rideId,String token) async {
    print('THIS IS THE RIDE ID:');
    print(rideId);
    final response= await _apiBaseHelper.getWithHeader("trip/customer/$rideId","Bearer $token");
    return RideBookingDetailsModel.fromJson(response);
  }

  Future<Reassignmodel> tripReassign(Map _body,String token) async {
    print('THIS IS THE RIDE ID:');
  //  print(rideId);
    final response= await _apiBaseHelper.postWithHeader("trip/reassign",_body,"Bearer $token");
    return Reassignmodel.fromJson(response);
  }

  Future<RideBookingDetailsModel> rideTracking(int rideId,String token) async {
    final response= await _apiBaseHelper.getWithHeader("trip/customer/$rideId","Bearer $token");
    return RideBookingDetailsModel.fromJson(response);
  }



  Future<MapDistanceModel> rideDistanceCalculate(double _sourceLat,double _sourceLong,double _dropLat,double _dropLong) async {
    String _url="https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$_sourceLat,$_sourceLong&destinations=$_dropLat,$_dropLong&key=AIzaSyCuGtIzD0qfGOsZjXtqaIu5syeDVZUrLUI";
    final response= await getForMap(_url);
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
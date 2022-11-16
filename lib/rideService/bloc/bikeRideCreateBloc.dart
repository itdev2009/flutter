import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/rideService/model/bikeRideCreateModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';

class BikRideCreateBloc {

  BikeRideRepository _bikeRideRepository;

  StreamController _bikeRideCreateController;

  StreamSink<ApiResponse<BikeRideCreateModel>> get bikeRideCreateSink =>
      _bikeRideCreateController.sink;

  Stream<ApiResponse<BikeRideCreateModel>> get bikeRideCreateStream =>
      _bikeRideCreateController.stream;


  BikRideCreateBloc() {
    _bikeRideCreateController = StreamController<ApiResponse<BikeRideCreateModel>>.broadcast();
    _bikeRideRepository = BikeRideRepository();
  }

  bikRideCreate(Map body, String userToken) async {
    bikeRideCreateSink.add(ApiResponse.loading("Submitting",));
    try {
      BikeRideCreateModel response = await _bikeRideRepository.rideCreate(body, userToken);
      bikeRideCreateSink.add(ApiResponse.completed(response));
    } catch (e) {
      bikeRideCreateSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _bikeRideCreateController?.close();
    bikeRideCreateSink?.close();
  }
}
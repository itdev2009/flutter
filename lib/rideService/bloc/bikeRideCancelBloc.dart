import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/rideService/model/bikeRideCancelModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';

class BikRideCancelBloc {

  BikeRideRepository _bikeRideRepository;

  StreamController _bikeRideCancelController;

  StreamSink<ApiResponse<BikeRideCancelModel>> get bikeRideCancelSink =>
      _bikeRideCancelController.sink;

  Stream<ApiResponse<BikeRideCancelModel>> get bikeRideCancelStream =>
      _bikeRideCancelController.stream;


  BikRideCancelBloc() {
    _bikeRideCancelController = StreamController<ApiResponse<BikeRideCancelModel>>.broadcast();
    _bikeRideRepository = BikeRideRepository();
  }

  bikRideCancel(Map body, String userToken) async {
    bikeRideCancelSink.add(ApiResponse.loading("Submitting",));
    try {
      BikeRideCancelModel response = await _bikeRideRepository.rideCancel(body, userToken);
      bikeRideCancelSink.add(ApiResponse.completed(response));
    } catch (e) {
      bikeRideCancelSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _bikeRideCancelController?.close();
    bikeRideCancelSink?.close();
  }
}
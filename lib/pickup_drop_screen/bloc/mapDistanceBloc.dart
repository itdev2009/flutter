import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/login_screen/model/loginModel.dart';
import 'package:delivery_on_time/login_screen/repository/loginRepository.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/repository/pickupDropRepository.dart';

class MapDistanceBloc {

  PickupDropRepository _pickupDropRepository;

  StreamController _mapDistanceController;

  StreamSink<ApiResponse<MapDistanceModel>> get mapDistanceSink =>
      _mapDistanceController.sink;

  Stream<ApiResponse<MapDistanceModel>> get mapDistanceStream =>
      _mapDistanceController.stream;


  MapDistanceBloc() {
    _mapDistanceController = StreamController<ApiResponse<MapDistanceModel>>.broadcast();
    _pickupDropRepository = PickupDropRepository();
  }

  mapDistanceCal(double _senderLat,double _senderLong,double _receiverLat,double _receiverLong) async {
    mapDistanceSink.add(ApiResponse.loading("Submitting",));
    try {
      MapDistanceModel response = await _pickupDropRepository.mapDistanceCalculate(_senderLat,_senderLong,_receiverLat,_receiverLong);
      mapDistanceSink.add(ApiResponse.completed(response));
    } catch (e) {
      mapDistanceSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _mapDistanceController?.close();
    mapDistanceSink?.close();
  }
}
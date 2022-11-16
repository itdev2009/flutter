import 'dart:async';

import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingPickDropModel.dart';
import 'package:delivery_on_time/tracking_screen/repository/mapTrackingRepository.dart';

class MapTrackingPickDropBloc {

  MapTrackingRepository _mapTrackingRepository;

  StreamController _mapTrackingController;

  StreamSink<ApiResponse<MapTrackingPickDropModel>> get mapTrackingSink =>
      _mapTrackingController.sink;

  Stream<ApiResponse<MapTrackingPickDropModel>> get mapTrackingStream =>
      _mapTrackingController.stream;


  MapTrackingPickDropBloc() {
    _mapTrackingController = StreamController<ApiResponse<MapTrackingPickDropModel>>.broadcast();
    _mapTrackingRepository = MapTrackingRepository();
  }

  mapTrackingPickDrop(String carrierId,String token) async {
    mapTrackingSink.add(ApiResponse.loading("Submitting",));
    try {
      MapTrackingPickDropModel response = await _mapTrackingRepository.mapTrackingforPickUp(carrierId,token);
      mapTrackingSink.add(ApiResponse.completed(response));
    } catch (e) {
      mapTrackingSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _mapTrackingController?.close();
    mapTrackingSink?.close();
  }
}
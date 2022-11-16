import 'dart:async';

import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/tracking_screen/repository/mapTrackingRepository.dart';

class MapTrackingBloc {

  MapTrackingRepository _mapTrackingRepository;

  StreamController _mapTrackingController;

  StreamSink<ApiResponse<MapTrackingMultiplePickup>> get mapTrackingSink =>
      _mapTrackingController.sink;

  Stream<ApiResponse<MapTrackingMultiplePickup>> get mapTrackingStream =>
      _mapTrackingController.stream;


  MapTrackingBloc() {
    _mapTrackingController = StreamController<ApiResponse<MapTrackingMultiplePickup>>.broadcast();
    _mapTrackingRepository = MapTrackingRepository();
  }

  mapTracking(String id, String token) async {
    mapTrackingSink.add(ApiResponse.loading("Submitting",));
    try {
      MapTrackingMultiplePickup response = await _mapTrackingRepository.mapTracking(id, token);
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
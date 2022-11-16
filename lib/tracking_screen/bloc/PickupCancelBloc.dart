import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/tracking_screen/model/pickupCancelModel.dart';
import 'package:delivery_on_time/tracking_screen/repository/mapTrackingRepository.dart';

class PickupCancelBloc {

  MapTrackingRepository _mapTrackingRepository;

  StreamController _pickupCancelController;

  StreamSink<ApiResponse<PickupCancelModel>> get pickupCancelSink =>
      _pickupCancelController.sink;

  Stream<ApiResponse<PickupCancelModel>> get pickUpCancelStream =>
      _pickupCancelController.stream;


  PickupCancelBloc() {
    _pickupCancelController = StreamController<ApiResponse<PickupCancelModel>>.broadcast();
    _mapTrackingRepository = MapTrackingRepository();
  }

  bikRideCancel(Map body, String userToken) async {
    pickupCancelSink.add(ApiResponse.loading("Submitting",));
    try {
      PickupCancelModel response = await _mapTrackingRepository.pickUpCancel(body, userToken);
      pickupCancelSink.add(ApiResponse.completed(response));
    } catch (e) {
      pickupCancelSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _pickupCancelController?.close();
    pickupCancelSink?.close();
  }
}
import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/login_screen/model/loginModel.dart';
import 'package:delivery_on_time/login_screen/repository/loginRepository.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/repository/pickupDropRepository.dart';

class PickupDropBloc {

  PickupDropRepository _pickupDropRepository;

  StreamController _pickupDropController;

  StreamSink<ApiResponse<PickupDropModel>> get pickupDropSink =>
      _pickupDropController.sink;

  Stream<ApiResponse<PickupDropModel>> get pickupDropStream =>
      _pickupDropController.stream;


  PickupDropBloc() {
    _pickupDropController = StreamController<ApiResponse<PickupDropModel>>.broadcast();
    _pickupDropRepository = PickupDropRepository();
  }

  pickupDropRequest(String _token,Map _body) async {
    pickupDropSink.add(ApiResponse.loading("Submitting",));
    try {
      PickupDropModel response = await _pickupDropRepository.pickupDropRequest(_token,_body);
      pickupDropSink.add(ApiResponse.completed(response));
    } catch (e) {
      pickupDropSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _pickupDropController?.close();
    pickupDropSink?.close();
  }
}
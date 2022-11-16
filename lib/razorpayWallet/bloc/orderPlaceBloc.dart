import 'dart:async';

import 'package:delivery_on_time/address_screens/model/addressAddModel.dart';
import 'package:delivery_on_time/address_screens/repository/addressRepository.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/orderPlace_paymennt/model/OrderPlaceResponseModel.dart';
import 'package:delivery_on_time/orderPlace_paymennt/repository/orderPlaceRepository.dart';

class OrderPlaceBloc {

  OrderPlaceRepository _orderPlaceRepository;

  StreamController _orderPlaceController;

  StreamSink<ApiResponse<OrderPlaceResponseModel>> get orderPlaceSink =>
      _orderPlaceController.sink;

  Stream<ApiResponse<OrderPlaceResponseModel>> get orderPlaceStream =>
      _orderPlaceController.stream;


  OrderPlaceBloc() {
    _orderPlaceController = StreamController<ApiResponse<OrderPlaceResponseModel>>.broadcast();
    _orderPlaceRepository = OrderPlaceRepository();
  }

  orderPlace(Map _body,String _token) async {
    orderPlaceSink.add(ApiResponse.loading("Submitting",));
    try {
      OrderPlaceResponseModel response = await _orderPlaceRepository.orderPlace(_body,_token);
      orderPlaceSink.add(ApiResponse.completed(response));
    } catch (e) {
      orderPlaceSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _orderPlaceController?.close();
    orderPlaceSink?.close();
  }
}
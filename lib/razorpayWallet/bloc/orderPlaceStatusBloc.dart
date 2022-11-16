import 'dart:async';

import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/orderPlace_paymennt/model/OrderPlaceStatusModel.dart';
import 'package:delivery_on_time/orderPlace_paymennt/repository/orderPlaceRepository.dart';

class OrderPlaceStatusBloc {

  OrderPlaceRepository _orderPlaceRepository;

  StreamController _orderPlaceStatusController;

  StreamSink<ApiResponse<OrderPlaceStatusModel>> get orderPlaceStatusSink =>
      _orderPlaceStatusController.sink;

  Stream<ApiResponse<OrderPlaceStatusModel>> get orderPlaceStatusStream =>
      _orderPlaceStatusController.stream;


  OrderPlaceStatusBloc() {
    _orderPlaceStatusController = StreamController<ApiResponse<OrderPlaceStatusModel>>();
    _orderPlaceRepository = OrderPlaceRepository();
  }

  orderPlaceStatus(Map _body,String _token) async {
    orderPlaceStatusSink.add(ApiResponse.loading("Submitting",));
    try {
      OrderPlaceStatusModel response = await _orderPlaceRepository.orderPlaceStatus(_body,_token);
      orderPlaceStatusSink.add(ApiResponse.completed(response));
    } catch (e) {
      orderPlaceStatusSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _orderPlaceStatusController?.close();
    orderPlaceStatusSink?.close();
  }
}
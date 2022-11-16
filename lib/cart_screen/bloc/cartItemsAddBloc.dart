import 'dart:async';

import 'package:delivery_on_time/cart_screen/model/cartItemsAddModel.dart';
import 'package:delivery_on_time/cart_screen/repository/cartRepository.dart';
import 'package:delivery_on_time/help/api_response.dart';

class CartItemsAddBloc {

  CartRepository _cartRepository;

  StreamController _cartItemsAddController;

  StreamSink<ApiResponse<CartItemsAddModel>> get cartItemsAddSink =>
      _cartItemsAddController.sink;

  Stream<ApiResponse<CartItemsAddModel>> get cartItemsAddStream =>
      _cartItemsAddController.stream;


  CartItemsAddBloc() {
    _cartItemsAddController = StreamController<ApiResponse<CartItemsAddModel>>.broadcast();
    _cartRepository = CartRepository();
  }

  cartItemsAdd(Map body) async {
    cartItemsAddSink.add(ApiResponse.loading("Submitting",));
    try {
      CartItemsAddModel response = await _cartRepository.cartItemsAdd(body);
      cartItemsAddSink.add(ApiResponse.completed(response));
    } catch (e) {
      cartItemsAddSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _cartItemsAddController?.close();
    cartItemsAddSink?.close();
  }
}
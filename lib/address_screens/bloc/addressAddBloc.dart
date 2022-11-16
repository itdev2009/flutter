import 'dart:async';

import 'package:delivery_on_time/address_screens/model/addressAddModel.dart';
import 'package:delivery_on_time/address_screens/repository/addressRepository.dart';
import 'package:delivery_on_time/help/api_response.dart';

class AddressAddBloc {

  AddressRepository _addressRepository;

  StreamController _addressAddController;

  StreamSink<ApiResponse<AddressAddModel>> get addressAddSink =>
      _addressAddController.sink;

  Stream<ApiResponse<AddressAddModel>> get addressAddStream =>
      _addressAddController.stream;


  AddressAddBloc() {
    _addressAddController = StreamController<ApiResponse<AddressAddModel>>.broadcast();
    _addressRepository = AddressRepository();
  }

  addressAdd(Map _body,String _token) async {
    addressAddSink.add(ApiResponse.loading("Submitting",));
    try {
      AddressAddModel response = await _addressRepository.addressAdd(_body,_token);
      addressAddSink.add(ApiResponse.completed(response));
    } catch (e) {
      addressAddSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _addressAddController?.close();
    addressAddSink?.close();
  }
}
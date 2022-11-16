import 'dart:async';

import 'package:delivery_on_time/changePassword_screen/model/changePasswordModel.dart';
import 'package:delivery_on_time/changePassword_screen/repository/changePasswordRepository.dart';
import 'package:delivery_on_time/help/api_response.dart';

class ChangePasswordBloc {

  ChangePasswordRepository _changePasswordRepository;

  StreamController _changePasswordController;

  StreamSink<ApiResponse<ChangePasswordModel>> get changePasswordAddSink =>
      _changePasswordController.sink;

  Stream<ApiResponse<ChangePasswordModel>> get changePasswordAddStream =>
      _changePasswordController.stream;


  ChangePasswordBloc() {
    _changePasswordController = StreamController<ApiResponse<ChangePasswordModel>>.broadcast();
    _changePasswordRepository = ChangePasswordRepository();
  }

  changePassword(Map _body,String _token) async {
    changePasswordAddSink.add(ApiResponse.loading("Submitting",));
    try {
      ChangePasswordModel response = await _changePasswordRepository.changePassword(_body,_token);
      changePasswordAddSink.add(ApiResponse.completed(response));
    } catch (e) {
      changePasswordAddSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _changePasswordController?.close();
    changePasswordAddSink?.close();
  }
}
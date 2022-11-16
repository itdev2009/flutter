import 'package:delivery_on_time/constants.dart';

class SuccessModel {
  bool success;
  //Data data;
 // String message;

  SuccessModel({this.success,});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
   // data = json['data'] != null ? new Data.fromJson(json['data']) : null;
   // message = json['message'];
    print('printing success');
    print(success);
    ridesuccess = success;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
   // if (this.data != null) {
   //   data['data'] = this.data.toJson();
   // }
   // data['message'] = this.message;
   // return data;
  }
}

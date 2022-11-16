import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/profile_screen/model/profileUpdateModel.dart';
import 'dart:io';
import 'package:dio/dio.dart';


class ProfileRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();
  final Dio _dio = Dio();

  Future<ProfileUpdateModel> profileUpdate(Map body, File imageFile1, String token) async {


    if(imageFile1!=null){
      print(imageFile1.path);
      var filenames = await MultipartFile.fromFile(File(imageFile1.path).path,
          filename: imageFile1.path);

      FormData formData =
      FormData.fromMap({"filenames[]": filenames, "type": "category"});

      print(formData);

      Response res = await _dio.post(ApiBaseHelper.baseUrl + "upload/image",
          data: formData,
          options: Options(headers: {"Authorization": "Bearer " + token}));

      print(res.data);
      print(res.runtimeType);
      print(res.data['data']);


      if (res.data['code'] == 200) {

        print(res.data['data']);
        body["profile_pic"] = res.data["data"][0];

        // Map body={
        //   "name":"$name",
        //   "email":"$email",
        //   "profile_pic":res.data['data'],
        //   "user_id":"$userId"
        // };

        final response= await _apiBaseHelper.postWithHeader("user/update/profile", body, "Bearer $token");
        return ProfileUpdateModel.fromJson(response);

      }
    }
    else{
      final response= await _apiBaseHelper.postWithHeader("user/update/profile", body, "Bearer $token");
      return ProfileUpdateModel.fromJson(response);
    }


  }

}
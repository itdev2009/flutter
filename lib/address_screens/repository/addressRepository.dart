
import 'package:delivery_on_time/address_screens/model/addressAddModel.dart';
import 'package:delivery_on_time/address_screens/model/addressByAddressIdModel.dart';
import 'package:delivery_on_time/address_screens/model/addressShowAllModel.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';

class AddressRepository{
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();

  Future<AddressShowAllModel> addressShowAll(body,token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("address/all", body,"Bearer $token");
    return AddressShowAllModel.fromJson(response);
  }

  Future<AddressAddModel> addressAdd(body,token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("address/store", body,"Bearer $token");
    return AddressAddModel.fromJson(response);
  }

  Future<AddressByAddressIdModel> addressByAddressId(body,token) async{
    // Map body={};
    final response= await _apiBaseHelper.postWithHeader("address", body,"Bearer $token");
    return AddressByAddressIdModel.fromJson(response);
  }



}
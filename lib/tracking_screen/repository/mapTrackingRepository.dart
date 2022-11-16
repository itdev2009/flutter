import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingPickDropModel.dart';
import 'package:delivery_on_time/tracking_screen/model/pickupCancelModel.dart';

class MapTrackingRepository{
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();


  Future<MapTrackingModel> mapTrackingOrg(String id, String token) async{
    // Map body={};
    final response= await _apiBaseHelper.getWithHeader("carrier/$id/location","Bearer $token");
    return MapTrackingModel.fromJson(response);
  }
  Future<PickupCancelModel> pickUpCancel(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("pickup/cancel-multiple", _body, "Bearer $token");
    return PickupCancelModel.fromJson(response);
  }
  Future<PickupCancelModel> pickupCancel(String id, String token) async{
    // Map body={};

    Map body={
      "id": id,
    };
    final response= await _apiBaseHelper.postWithHeader("pickup/cancel-multiple",body,"Bearer $token");

    return PickupCancelModel.fromJson(response);
  }

  Future<MapTrackingMultiplePickup> mapTracking(String id, String token) async{
    // Map body={};

    Map body={
      "pickup_id": id,
    };
    final response= await _apiBaseHelper.postWithHeader("pickup/details-multiple",body,"Bearer $token");

    return MapTrackingMultiplePickup.fromJson(response);
  }

  Future<MapTrackingPickDropModel> mapTrackingforPickUp(carrierId,token) async{
    // Map body={};
    final response= await _apiBaseHelper.getWithHeader("carrier/$carrierId/location","Bearer $token");
    return MapTrackingPickDropModel.fromJson(response);
  }
}
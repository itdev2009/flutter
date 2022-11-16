class RideBookingDetailsModel {
  bool success;
  Data data;
  String message;

  RideBookingDetailsModel({this.success, this.data, this.message});

  RideBookingDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  int customerId;
  int carrierId;
  String pickupAddress;
  String pickupLatitude;
  String pickupLongitude;
  String dropAddress;
  String dropLatitude;
  String dropLongitude;
  String projectedDistance;
  String status;
  String actualDistance;
  String tripCharge;
  String tax;
  String payableAmount;
  String ewalletAmount;
  String paymentMethod;
  String paymentStatus;
  String transactionId;
  String orderId;
  dynamic rating;
  dynamic review;
  String pickedUpAt;
  String droppedAt;
  String updatedAt;
  String createdAt;
  Carrier carrier;

  Data(
      {this.id,
        this.customerId,
        this.carrierId,
        this.pickupAddress,
        this.pickupLatitude,
        this.pickupLongitude,
        this.dropAddress,
        this.dropLatitude,
        this.dropLongitude,
        this.projectedDistance,
        this.status,
        this.actualDistance,
        this.tripCharge,
        this.tax,
        this.payableAmount,
        this.ewalletAmount,
        this.paymentMethod,
        this.paymentStatus,
        this.transactionId,
        this.orderId,
        this.rating,
        this.review,
        this.pickedUpAt,
        this.droppedAt,
        this.updatedAt,
        this.createdAt,
        this.carrier});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    carrierId = json['carrier_id'];
    pickupAddress = json['pickup_address'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    dropAddress = json['drop_address'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    projectedDistance = json['projected_distance'];
    status = json['status'];
    actualDistance = json['actual_distance'];
    tripCharge = json['trip_charge'];
    tax = json['tax'];
    payableAmount = json['payable_amount'];
    ewalletAmount = json['ewallet_amount'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    rating = json['rating'];
    review = json['review'];
    pickedUpAt = json['picked_up_at'];
    droppedAt = json['dropped_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    carrier =
    json['carrier'] != null ? new Carrier.fromJson(json['carrier']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['carrier_id'] = this.carrierId;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['drop_address'] = this.dropAddress;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['projected_distance'] = this.projectedDistance;
    data['status'] = this.status;
    data['actual_distance'] = this.actualDistance;
    data['trip_charge'] = this.tripCharge;
    data['tax'] = this.tax;
    data['payable_amount'] = this.payableAmount;
    data['ewallet_amount'] = this.ewalletAmount;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['picked_up_at'] = this.pickedUpAt;
    data['dropped_at'] = this.droppedAt;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.carrier != null) {
      data['carrier'] = this.carrier.toJson();
    }
    return data;
  }
}

class Carrier {

  String vehicle_type;
  String vehicle_make;
  String vehicle_no;
  int id;
  String latitude;
  String longitude;
  String proofVehicleNo;
  String proofPhoto;
  String proofAddress;
  int isAvailable;
  User user;

  Carrier(

      {
        this.vehicle_type,
        this.vehicle_make,
        this.vehicle_no,
        this.id,
        this.latitude,
        this.longitude,
        this.proofVehicleNo,
        this.proofPhoto,
        this.proofAddress,
        this.isAvailable,
        this.user});

  Carrier.fromJson(Map<String, dynamic> json) {
    vehicle_type = json['vehicle_type'];
    vehicle_make = json['vehicle_make'];
    vehicle_no = json['vehicle_no'];
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    proofVehicleNo = json['proof_vehicle_no'];
    proofPhoto = json['proof_photo'];
    proofAddress = json['proof_address'];
    isAvailable = json['is_available'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_type'] = vehicle_type;
    data['vehicle_make'] = vehicle_make;
    data['vehicle_no'] = vehicle_no;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['proof_vehicle_no'] = this.proofVehicleNo;
    data['proof_photo'] = this.proofPhoto;
    data['proof_address'] = this.proofAddress;
    data['is_available'] = this.isAvailable;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  int carrierId;
  String name;
  String mobileNumber;
  String profilePic;
  String deviceId;

  User(
      {this.id,
        this.carrierId,
        this.name,
        this.mobileNumber,
        this.profilePic,
        this.deviceId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carrierId = json['carrier_id'];
    name = json['name'];
    mobileNumber = json['mobile_number'];
    profilePic = json['profile_pic'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['carrier_id'] = this.carrierId;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['profile_pic'] = this.profilePic;
    data['device_id'] = this.deviceId;
    return data;
  }
}

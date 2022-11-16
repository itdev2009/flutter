class RestaurantsListModel {
  List<Data> data;
  String message;
  int status;

  RestaurantsListModel({this.data, this.message, this.status});

  RestaurantsListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int userId;
  String userEmail;
  String mobileNumber;
  int categoryId;
  int vendorId;
  String name;
  String categoryName;
  String shopName;
  String address;
  String city;
  String state;
  int zip;
  String longitude;
  String latitude;
  int isActive;
  String vendorImage;
  String availableFrom;
  String availableTo;
  int parentId;
  int totalNumberOfFeedback;
  String averageRating;
  double distance;
  bool shopTimingAvailability;

  Data(
      {this.userId,
        this.userEmail,
        this.mobileNumber,
        this.categoryId,
        this.vendorId,
        this.name,
        this.categoryName,
        this.shopName,
        this.address,
        this.city,
        this.state,
        this.zip,
        this.longitude,
        this.latitude,
        this.isActive,
        this.vendorImage,
        this.availableFrom,
        this.availableTo,
        this.parentId,
        this.totalNumberOfFeedback,
        this.averageRating,
        this.distance,
        this.shopTimingAvailability});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    mobileNumber = json['mobile_number'];
    categoryId = json['category_id'];
    vendorId = json['vendor_id'];
    name = json['name'];
    categoryName = json['category_name'];
    shopName = json['shop_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    isActive = json['is_active'];
    vendorImage = json['vendor_image'];
    availableFrom = json['available_from'];
    availableTo = json['available_to'];
    parentId = json['parent_id'];
    totalNumberOfFeedback = json['total_number_of_feedback'];
    averageRating = json['average_rating'];
    distance = json['distance'];
    shopTimingAvailability = json['shopTimingAvailability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_email'] = this.userEmail;
    data['mobile_number'] = this.mobileNumber;
    data['category_id'] = this.categoryId;
    data['vendor_id'] = this.vendorId;
    data['name'] = this.name;
    data['category_name'] = this.categoryName;
    data['shop_name'] = this.shopName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['is_active'] = this.isActive;
    data['vendor_image'] = this.vendorImage;
    data['available_from'] = this.availableFrom;
    data['available_to'] = this.availableTo;
    data['parent_id'] = this.parentId;
    data['total_number_of_feedback'] = this.totalNumberOfFeedback;
    data['average_rating'] = this.averageRating;
    data['distance'] = this.distance;
    data['shopTimingAvailability'] = this.shopTimingAvailability;
    return data;
  }
}

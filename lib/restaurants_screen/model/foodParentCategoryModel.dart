class FoodParentCategoryModel {
  List<Data> data;
  String message;
  int code;

  FoodParentCategoryModel({this.data, this.message, this.code});

  FoodParentCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String categoryname;
  String id;
  List<Subcategory> subcategory;

  Data({this.categoryname, this.id, this.subcategory});

  Data.fromJson(Map<String, dynamic> json) {
    categoryname = json['categoryname'];
    id = json['id'];
    if (json['subcategory'] != null) {
      subcategory = new List<Subcategory>();
      json['subcategory'].forEach((v) {
        subcategory.add(new Subcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryname'] = this.categoryname;
    data['id'] = this.id;
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategory {
  String subcategoryname;
  String id;

  Subcategory({this.subcategoryname, this.id});

  Subcategory.fromJson(Map<String, dynamic> json) {
    subcategoryname = json['subcategoryname'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcategoryname'] = this.subcategoryname;
    data['id'] = this.id;
    return data;
  }
}

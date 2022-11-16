class SubCategoriesModel {
  List<Data> data;
  String message;
  int status;

  SubCategoriesModel({this.data, this.message, this.status});

  SubCategoriesModel.fromJson(Map<String, dynamic> json) {
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
  String categoryname;
  String id;
  String status;
  String categoryImage;
  String description;
  String slug;
  List<Subcategory> subcategory;

  Data(
      {this.categoryname,
        this.id,
        this.status,
        this.categoryImage,
        this.description,
        this.slug,
        this.subcategory});

  Data.fromJson(Map<String, dynamic> json) {
    categoryname = json['categoryname'];
    id = json['id'];
    status = json['status'];
    categoryImage = json['category_image'];
    description = json['description'];
    slug = json['slug'];
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
    data['status'] = this.status;
    data['category_image'] = this.categoryImage;
    data['description'] = this.description;
    data['slug'] = this.slug;
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategory {
  String subcategoryname;
  String id;
  String status;
  String categoryImage;
  String description;
  String slug;

  Subcategory(
      {this.subcategoryname,
        this.id,
        this.status,
        this.categoryImage,
        this.description,
        this.slug});

  Subcategory.fromJson(Map<String, dynamic> json) {
    subcategoryname = json['subcategoryname'];
    id = json['id'];
    status = json['status'];
    categoryImage = json['category_image'];
    description = json['description'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcategoryname'] = this.subcategoryname;
    data['id'] = this.id;
    data['status'] = this.status;
    data['category_image'] = this.categoryImage;
    data['description'] = this.description;
    data['slug'] = this.slug;
    return data;
  }
}

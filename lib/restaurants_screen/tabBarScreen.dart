import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_on_time/cart_screen/bloc/cartEmptyBloc.dart';
import 'package:delivery_on_time/cart_screen/bloc/cartItemsAddBloc.dart';
import 'package:delivery_on_time/cart_screen/bloc/cartItemsUpdateBloc.dart';
import 'package:delivery_on_time/cart_screen/model/cartItemsAddModel.dart';
import 'package:delivery_on_time/cart_screen/model/cartItemsEmptyModel.dart';
import 'package:delivery_on_time/cart_screen/model/cartItemsUpdateModel.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/restaurants_screen/detailscreen.dart';
import 'package:delivery_on_time/restaurants_screen/model/foodDetailsModel.dart' as fdm;
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:delivery_on_time/utility/Error.dart';
import 'package:delivery_on_time/utility/Loading.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TabBarScreen extends StatefulWidget {


  final double shopLat;
  final double shopLong;
  final fdm.Data foodDetailsModelData;
  final vendorId;
  final categoryId;
  final parentCategoryId;
  final index;
  final bool shopAvailability;

  const TabBarScreen({Key key, this.shopLat, this.shopLong, this.foodDetailsModelData, this.vendorId, this.categoryId, this.parentCategoryId, this.index, this.shopAvailability})
      : super(key: key);

  @override
  _TabBarScreenState createState() =>
      _TabBarScreenState(this.shopLat, this.shopLong, this.foodDetailsModelData, this.vendorId, this.categoryId, this.parentCategoryId, this.index, this.shopAvailability);
/*TabBarScreen(this.foodDetailsModelData,category_id, vendor_id, parentCategory_Id, index1) {
    categoryId = category_id;
    vendorId = vendor_id;
    parentCategoryId = parentCategory_Id;
    index = index1;
  }*/
}

class _TabBarScreenState extends State<TabBarScreen> {
  final double shopLat;
  final double shopLong;
  final fdm.Data foodDetailsModelData;
  final vendorId;
  final categoryId;
  final parentCategoryId;
  final tabIndex;
  final bool shopAvailability;

  _TabBarScreenState(this.shopLat, this.shopLong, this.foodDetailsModelData, this.vendorId, this.categoryId, this.parentCategoryId, this.tabIndex, this.shopAvailability);

  // var vendorId = TabBarScreen.vendorId;
  // var categoryId = TabBarScreen.categoryId;
  // var parentCategoryId = TabBarScreen.parentCategoryId;
  // var tabIndex = TabBarScreen.index;
  String currentVendorId;
  String currentCategoryId;

  bool check = true;

  // int count=0;

  FoodHomeRepository _foodHomeRepository = new FoodHomeRepository();
  Future<fdm.FoodDetailsModel> _foodDetailsFuture;


  List productparentCategoryId = new List();

  // ProductDetails _productDetails = new ProductDetails();
  List<fdm.ProductDetails> _productDetailsList = new List<fdm.ProductDetails>();

  bool setStateCheck = false;
  List _productAmount = [];
  List _cartItemId = new List();
  List _addVisibility = new List();
  List _moreLessVisibility = new List();
  List _circularProgressVisibility = new List();
  List _outOfStockVisibility = new List();
  CartItemsAddBloc _cartItemsAddBloc;
  CartItemsUpdateBloc _cartItemsUpdateBloc;
  CartEmptyBloc _cartEmptyBloc;
  SharedPreferences prefs;
  int _index1 = 0;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    print("next page hit "+DateTime.now().toLocal().toString());
    // _foodDetailsFuture = _foodHomeRepository.foodDetails(categoryId, vendorId);
    _cartItemsAddBloc = CartItemsAddBloc();
    _cartItemsUpdateBloc = CartItemsUpdateBloc();
    _cartEmptyBloc = CartEmptyBloc();
    createSharedPref();
  }

  Future<void> managedSharedPref(CartItemsAddModel data) async {
    prefs.setString("cart_id", data.data.cartItems[0].cartId.toString());
    // cartId=data.data.cartItems[0].cartId;
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    currentVendorId = prefs.getString("vendor_id");
    currentCategoryId = prefs.getString("parent_category_id");
  }

  @override
  Widget build(BuildContext context) {
    if (check) {
      print("before data process "+DateTime.now().toLocal().toString());

      for (int i = 0; i < foodDetailsModelData.productDetails.length; i++) {
        if (foodDetailsModelData.productDetails[i].categoryId == parentCategoryId) {
          if (foodDetailsModelData.productDetails[i].skus.length > 0) {
            _productDetailsList.add(foodDetailsModelData.productDetails[i]);

            // Dynamically List Data Generate...

            if(shopAvailability){
              _productAmount.add(List.generate(
                  foodDetailsModelData.productDetails[i].skus.length,
                      (index) => (foodDetailsModelData.productDetails[i].skus[index].cartItem == null)
                      ? 0
                      : int.parse(foodDetailsModelData.productDetails[i].skus[index].cartItem.quantity.toString())));

              _cartItemId.add(List.generate(
                  foodDetailsModelData.productDetails[i].skus.length,
                      (index) => (foodDetailsModelData.productDetails[i].skus[index].cartItem == null)
                      ? "0"
                      : foodDetailsModelData.productDetails[i].skus[index].cartItem.cartItemId));

              _outOfStockVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length, (index) =>
                (foodDetailsModelData.productDetails[i].skus[index].isOutOfStock==1)? true : false));

              _addVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length,
                      (index) => (foodDetailsModelData.productDetails[i].skus[index].isOutOfStock==0)? ((foodDetailsModelData.productDetails[i].skus[index].cartItem == null) ? true : false) :false));

              _moreLessVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length,
                      (index) => (foodDetailsModelData.productDetails[i].skus[index].isOutOfStock==0)? (foodDetailsModelData.productDetails[i].skus[index].cartItem == null) ? false : true : false));

              _circularProgressVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length, (index) => false));
            }
            else{
              _productAmount.add(List.generate(
                  foodDetailsModelData.productDetails[i].skus.length,
                      (index) => 0));

              // _cartItemId.add(List.generate(
              //     foodDetailsModelData.productDetails[i].skus.length,
              //         (index) => (foodDetailsModelData.productDetails[i].skus[index].cartItem == null)
              //         ? "0"
              //         : foodDetailsModelData.productDetails[i].skus[index].cartItem.cartItemId));

              _addVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length,
                      (index) => false));

              _moreLessVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length,
                      (index) => false));

              _circularProgressVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length, (index) => false));

              _outOfStockVisibility.add(List.generate(foodDetailsModelData.productDetails[i].skus.length, (index) => false));
            }

          }
        }
      }
      check = !check;
      print("after data process "+DateTime.now().toLocal().toString());

    }
    print("parenCatID Tabbar screen passing $parentCategoryId");
    print("Tab index Tabbar screen passing $tabIndex");
    int count = 0;
    print("during build "+DateTime.now().toLocal().toString());

    return Column(
      // shrinkWrap: true,
      // physics: ScrollPhysics(),
      children: [
        StreamBuilder<ApiResponse<CartItemsAddModel>>(
          stream: _cartItemsAddBloc.cartItemsAddStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  // alertDialogue(context);
                  break;
                case Status.COMPLETED:
                  {
                    prefs.setString("cart_id", "${snapshot.data.data.data.cartItems[0].cartId}");
                    print("cart id ${snapshot.data.data.data.cartItems[0].cartId}");
                    _cartItemId[_index1][_index] = snapshot.data.data.data.cartItemId;
                    print("complete111");
                    print(_cartItemId[_index1][_index]);
                    print("$_index1 $_index");
                    print(_cartItemId);
                    print(snapshot.data.data.data.cartItemId);
                    managedSharedPref(snapshot.data.data);
                    if (setStateCheck) {
                      Future.delayed(Duration.zero, () {
                        setState(() {
                          _moreLessVisibility[_index1][_index] = !_moreLessVisibility[_index1][_index];

                          _circularProgressVisibility[_index1][_index] = !_circularProgressVisibility[_index1][_index];
                        });
                      });
                      setStateCheck = false;
                    }
                  }
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                  );
                  break;
              }
            } else if (snapshot.hasError) {
              print("error");
            }

            return Container();
          },
        ),
        StreamBuilder<ApiResponse<CartItemsUpdateModel>>(
          stream: _cartItemsUpdateBloc.cartItemsUpdateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Container();
                  break;
                case Status.COMPLETED:
                  {
                    print("data update +++");
                    // prefs.setString("cart_id", "${snapshot.data.data.data.cartItems[0].cartId}");
                    // cartId=snapshot.data.data.data.cartItems[0].cartId;
                    // print(snapshot.data.data.data.cartItems[0].cartId);
                  }
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                  );
                  break;
              }
            } else if (snapshot.hasError) {
              print("error");
            }

            return Container();
          },
        ),
        Expanded(
          child: Container(
            child: tabBarListViewWidget(),
          ),
        ),
      ],
    );

    print("after build "+DateTime.now().toLocal().toString());

  }

  Widget tabBarListViewWidget() {
    if (foodDetailsModelData.productDetails != null && _productDetailsList.length > 0) {
      return ListView.builder(
          // physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: _productDetailsList.length,
          itemBuilder: (context, index1) {
            return StickyHeader(
              header: Container(
                // height: 30.0,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                  color: lightThemeBlue,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                ),
                child: Text(
                  _productDetailsList[index1].name.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: Colors.white),
                ),
              ),
              content: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _productDetailsList[index1].skus.length,
                  itemBuilder: (context, index) {
                    // count++;
                    return Container(
                        margin: EdgeInsets.only(top: 4.0, bottom: 14.0),
                        padding: EdgeInsets.all(5.0),
                        // height: screenWidth * 0.22,
                        // width: screenWidth*0.05,
                        // height: 100.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(14.0)), color: Colors.white),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: screenWidth * 0.2,
                                // width: screenWidth * 0.20,
                                // height: double.infinity,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                child: InkWell(
                                  onTap: ()
                                  {
                                    imageurl = (_productDetailsList[index1].skus[index].image!=null)?_productDetailsList[index1].skus[index].image.productImages:"null";
                                    print(imageurl);
                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                     return DetailScreen();
                                   }));
                                  },
                                  child: Hero(
                                    //tag: "customTag",
                                    tag: imageurl!=null?imageurl:'customTag',
                                    child: FadeInImage(

                                      image: NetworkImage(
                                        "$imageBaseURL${(_productDetailsList[index1].skus[index].image!=null)?_productDetailsList[index1].skus[index].image.productImages:"null"}",
                                      ),
                                      placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Container(
                                // color: Colors.redAccent,
                                // width: screenWidth * 0.6,
                                margin: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0, right: 10.0),
                                // 9647965502 149

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${_productDetailsList[index1].skus[index].skuName}",
                                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: screenWidth * 0.04)),
                                    Container(
                                      // color: Colors.greenAccent,
                                      margin: EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "₹ ${_productDetailsList[index1].skus[index].price}",
                                            style: TextStyle(
                                                color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.access_time,
                                            color: Colors.deepOrange,
                                            size: (shopAvailability)?screenWidth * 0.04 : 0,
                                          ),
                                          InkWell(
                                            onTap: ()
                                              {
                                                print(_productDetailsList[index1].skus[index].preparationTime);
                                              },
                                            child: Text(
                                              (_productDetailsList[index1].skus[index].preparationTime!=null)?"${_productDetailsList[index1].skus[index].preparationTime}m":"40m",
                                              style: TextStyle(
                                                color: Colors.deepOrange,
                                                fontSize: (shopAvailability)?screenWidth * 0.035 : 0,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Spacer(),


                                          //Out of Stock visbility
                                          Visibility(
                                            visible: _outOfStockVisibility[index1][index],
                                            child: Container(
                                              // width: 60,
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                            border: Border.all(
                                            color: Colors.black54,
                                            ),
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                          ),
                                              child: Text("OUT OF STOCK",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                                color: Colors.black54
                                              ),),
                                            ),
                                          ),

                                          //circular Progressbar
                                          Visibility(
                                            visible: _circularProgressVisibility[index1][index],
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 17.0,
                                                  height: 17.0,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: circularBGCol,
                                                    strokeWidth: 4,
                                                    valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * 0.05,
                                                ),
                                              ],
                                            ),
                                          ),

                                          //addVisibility Product Icon
                                          Visibility(
                                            visible: _addVisibility[index1][index],
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    print(prefs.getString("cart_id")!="");

                                                    if ( currentVendorId!=null && currentVendorId != vendorId && (prefs.getString("cart_id") != "" && prefs.getString("cart_id") != null)) {
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              // title: Text("Give the code?"),
                                                              content: Padding(
                                                                padding: const EdgeInsets.only(top: 10.0),
                                                                child: Text(
                                                                  "You Have Product in Your Cart of Another Seller.\n"
                                                                  "Do You Want to Clear Your Cart?",
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 14.0,
                                                                    // fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                new FlatButton(
                                                                    child: const Text(
                                                                      "Yes, I want",
                                                                      style: TextStyle(
                                                                        color: Colors.deepOrangeAccent,
                                                                        fontSize: 14.0,
                                                                        // fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      Map _body = {"cartid": prefs.getString("cart_id")??""};
                                                                      _cartEmptyBloc.cartItemsEmpty(_body);
                                                                      currentVendorId = "";
                                                                      currentCategoryId = "";
                                                                      prefs.setString("cart_id", "");
                                                                      prefs.setString("vendor_id", "");
                                                                      prefs.setString("parent_category_id", "");
                                                                      prefs.setString("coupon_code", "");
                                                                      Navigator.pop(context);
                                                                    }),
                                                                new FlatButton(
                                                                    child: const Text(
                                                                      "No, I Dont",
                                                                      style: TextStyle(
                                                                        color: Colors.deepOrangeAccent,
                                                                        fontSize: 14.0,
                                                                        // fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    }),
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      setState(() {
                                                        ++_productAmount[index1][index];

                                                        _circularProgressVisibility[index1][index] =
                                                        !_circularProgressVisibility[index1][index];

                                                        _addVisibility[index1][index] = !_addVisibility[index1][index];

                                                        setStateCheck = true;

                                                        _index = index;
                                                        _index1 = index1;
                                                        currentVendorId = vendorId;
                                                        currentCategoryId = categoryId;

                                                      });
                                                      Map body;
                                                      if (prefs.getString("cart_id") != "") {
                                                        if (prefs.getString("user_id") == "") {
                                                          body = {
                                                            "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                            "quantity": "${_productAmount[index1][index]}",
                                                            "cartid": prefs.getString("cart_id")??""
                                                          };
                                                        } else if (prefs.getString("user_id") != "") {
                                                          print(prefs.getString("user_id"));
                                                          body = {
                                                            "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                            "quantity": "${_productAmount[index1][index]}",
                                                            "userid":   prefs.getString("user_id")==null?"":"${prefs.getString("user_id")}",
                                                            "cartid": prefs.getString("cart_id")??""
                                                          };
                                                        }
                                                      } else if (prefs.getString("cart_id") == "") {
                                                        if (prefs.getString("user_id") == "") {
                                                          body = {
                                                            "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                            "quantity": "${_productAmount[index1][index]}"
                                                          };
                                                        } else if (prefs.getString("user_id") != "") {
                                                          body = {
                                                            "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                            "quantity": "${_productAmount[index1][index]}",
                                                            "userid": prefs.getString("user_id")==null?"":"${prefs.getString("user_id")}",
                                                          };
                                                        }
                                                      }
                                                      prefs.setDouble("shopLat", shopLat);
                                                      prefs.setDouble("shopLong", shopLong);

                                                      prefs.setDouble("userLat", userLat);
                                                      prefs.setDouble("userLong", userLong);

                                                      prefs.setString("vendor_id", vendorId);
                                                      prefs.setString("parent_category_id", categoryId);
                                                      _cartItemsAddBloc.cartItemsAdd(body);
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: screenWidth * 0.07,
                                                    color: Colors.deepOrange,
                                                  ),
                                                ),
                                                // InkWell(
                                                //   onTap: () {
                                                //     print(prefs.getString("cart_id")!="");
                                                //     if (currentVendorId != vendorId && (prefs.getString("cart_id") != "" && prefs.getString("cart_id") != null)) {
                                                //       showDialog(
                                                //           context: context,
                                                //           barrierDismissible: false,
                                                //           builder: (context) {
                                                //             return AlertDialog(
                                                //               // title: Text("Give the code?"),
                                                //               content: Padding(
                                                //                 padding: const EdgeInsets.only(top: 10.0),
                                                //                 child: Text(
                                                //                   "You Have Product in Your Cart of Another Seller.\n"
                                                //                   "Do You Want to Clear Your Cart?",
                                                //                   style: TextStyle(
                                                //                     color: Colors.black,
                                                //                     fontSize: 14.0,
                                                //                     // fontWeight: FontWeight.bold
                                                //                   ),
                                                //                 ),
                                                //               ),
                                                //               actions: [
                                                //                 new FlatButton(
                                                //                     child: const Text(
                                                //                       "Yes, I want",
                                                //                       style: TextStyle(
                                                //                         color: Colors.deepOrangeAccent,
                                                //                         fontSize: 14.0,
                                                //                         // fontWeight: FontWeight.bold
                                                //                       ),
                                                //                     ),
                                                //                     onPressed: () {
                                                //                       Map _body = {"cartid": prefs.getString("cart_id")??""};
                                                //                       _cartEmptyBloc.cartItemsEmpty(_body);
                                                //                       currentVendorId = "";
                                                //                       currentCategoryId = "";
                                                //                       prefs.setString("cart_id", "");
                                                //                       prefs.setString("vendor_id", "");
                                                //                       prefs.setString("parent_category_id", "");
                                                //                       prefs.setString("coupon_code", "");
                                                //                       Navigator.pop(context);
                                                //                     }),
                                                //                 new FlatButton(
                                                //                     child: const Text(
                                                //                       "No, I Dont",
                                                //                       style: TextStyle(
                                                //                         color: Colors.deepOrangeAccent,
                                                //                         fontSize: 14.0,
                                                //                         // fontWeight: FontWeight.bold
                                                //                       ),
                                                //                     ),
                                                //                     onPressed: () {
                                                //                       Navigator.pop(context);
                                                //                     }),
                                                //               ],
                                                //             );
                                                //           });
                                                //     } else {
                                                //       setState(() {
                                                //         ++_productAmount[index1][index];
                                                //
                                                //         _circularProgressVisibility[index1][index] =
                                                //         !_circularProgressVisibility[index1][index];
                                                //
                                                //         _addVisibility[index1][index] = !_addVisibility[index1][index];
                                                //
                                                //         setStateCheck = true;
                                                //
                                                //         _index = index;
                                                //         _index1 = index1;
                                                //         currentVendorId = vendorId;
                                                //         currentCategoryId = categoryId;
                                                //
                                                //       });
                                                //       Map body;
                                                //       if (prefs.getString("cart_id") != "") {
                                                //         if (prefs.getString("user_id") == "") {
                                                //           body = {
                                                //             "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                //             "quantity": "${_productAmount[index1][index]}",
                                                //             "cartid": prefs.getString("cart_id")??""
                                                //           };
                                                //         } else if (prefs.getString("user_id") != "") {
                                                //           body = {
                                                //             "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                //             "quantity": "${_productAmount[index1][index]}",
                                                //             "userid": "${prefs.getString("user_id")}",
                                                //             "cartid": prefs.getString("cart_id")??""
                                                //           };
                                                //         }
                                                //       } else if (prefs.getString("cart_id") == "") {
                                                //         if (prefs.getString("user_id") == "") {
                                                //           body = {
                                                //             "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                //             "quantity": "${_productAmount[index1][index]}"
                                                //           };
                                                //         } else if (prefs.getString("user_id") != "") {
                                                //           body = {
                                                //             "skuid": "${_productDetailsList[index1].skus[index].id}",
                                                //             "quantity": "${_productAmount[index1][index]}",
                                                //             "userid": "${prefs.getString("user_id")}"
                                                //           };
                                                //         }
                                                //       }
                                                //       prefs.setDouble("shopLat", shopLat);
                                                //       prefs.setDouble("shopLong", shopLong);
                                                //
                                                //       prefs.setDouble("userLat", userLat);
                                                //       prefs.setDouble("userLong", userLong);
                                                //
                                                //       prefs.setString("vendor_id", vendorId);
                                                //       prefs.setString("parent_category_id", categoryId);
                                                //       _cartItemsAddBloc.cartItemsAdd(body);
                                                //     }
                                                //   },
                                                //   child: Icon(
                                                //     Icons.add_circle_outline,
                                                //     size: screenWidth * 0.07,
                                                //     color: Colors.deepOrange,
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: screenWidth * 0.05,
                                                ),
                                              ],
                                            ),
                                          ),

                                          //addVisibility and Less Product 2 Icons and Number
                                          Visibility(
                                            visible: _moreLessVisibility[index1][index],
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (_productAmount[index1][index] == 1) {
                                                        _moreLessVisibility[index1][index] = !_moreLessVisibility[index1][index];
                                                        _addVisibility[index1][index] = !_addVisibility[index1][index];
                                                      }
                                                      --_productAmount[index1][index];
                                                    });
                                                    Map body = {
                                                      "cart_item_id": "${_cartItemId[index1][index]}",
                                                      "quantity": "${_productAmount[index1][index]}"
                                                    };
                                                    _cartItemsUpdateBloc.cartItemsUpdate(body);
                                                  },
                                                  child: Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.deepOrange,
                                                    size: screenWidth * .07,
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth * .012),
                                                Container(
                                                    alignment: Alignment.topCenter,
                                                    // height: screenHeight * .025,
                                                    // width: screenHeight * .025,
                                                    child: Center(
                                                        child: Text(
                                                      "${_productAmount[index1][index]}",
                                                      style: TextStyle(fontSize: screenWidth * .04, fontFamily: 'pop'),
                                                    ))),
                                                SizedBox(width: screenWidth * .012),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      ++_productAmount[index1][index];
                                                    });
                                                    Map body = {
                                                      "cart_item_id": "${_cartItemId[index1][index]}",
                                                      "quantity": "${_productAmount[index1][index]}"
                                                    };
                                                    print(_cartItemId[index1][index]);
                                                    print("$index1 $index");
                                                    print(_cartItemId);

                                                    _cartItemsUpdateBloc.cartItemsUpdate(body);
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.deepOrange,
                                                    size: screenWidth * .07,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ));
                  }),
            );
            // );
          });
    }
  }
}

// alertDialogue(context) async {
//   Future.delayed(Duration.zero, () {
//     print("push");
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             // title: Text("Give the code?"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Image.asset(
//                   "assets/images/icons/rightSymbol.png",
//                   height: 60.0,
//                 ),
//                 Text(
//                   "You Have Successfully Added Your Product ",
//                   style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
//                 )
//               ],
//             ),
//             actions: [
//               new FlatButton(
//                 child: const Text("Ok"),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           );
//         });
//   });
// }

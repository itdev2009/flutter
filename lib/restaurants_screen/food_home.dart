import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:delivery_on_time/cart_screen/model/cartItemsDetailsModel.dart';
import 'package:delivery_on_time/cart_screen/repository/cartRepository.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/restaurants_screen/model/allCouponModel.dart' as acm;
import 'package:delivery_on_time/restaurants_screen/model/recentOrdersModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/restaurantsListModel.dart' as rlm;
import 'package:delivery_on_time/restaurants_screen/recentOrders.dart';
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:delivery_on_time/restaurants_screen/shop_details.dart';
import 'package:delivery_on_time/widgets/noInternetBackground.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:geolocator/geolocator.dart';
import 'customAppBarFoodHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class FoodHome extends StatefulWidget {
  // 18001025963
  final int _categodyId;

  FoodHome(this._categodyId);

  @override
  _FoodHomeState createState() => _FoodHomeState(_categodyId);
}

class _FoodHomeState extends State<FoodHome> {
  final int _categodyId;

  _FoodHomeState(this._categodyId);

  String address = "";
  FoodHomeRepository _foodHomeRepo = new FoodHomeRepository();

  List picFromApi = [];
  List restaurantNameFromApi = [];
  List restaurantAddressFromApi = [];
  List restaurantTimingFromApi = [];
  List restaurantAvailabilityFromApi = [];

  List offerPlaceHolder = [
    "blue.png",
    "yellow.png",
    "green.png",
  ];

  List restroPlaceHolder = [
    "food1.png",
    "food2.png",
    "food3.png",
    "food4.png",
  ];

  int restroIndex = 0;
  int offerIndex = 0;

  List<acm.Data> allCouponData = [];

  SharedPreferences prefs;

  String _cartId = "";
  Future<rlm.RestaurantsListModel> _restroListApi;
  Future<acm.AllCouponModel> _allCouponApi;
  int cartItemNo = 0;
  DateTime startTime;
  DateTime endTime;
  DateTime nowTime = DateTime.now();
  DateTime availableFrom;
  DateTime availableTo;

  ScrollController controller;
  int totalRestaurants = 0;
  int restaurantIndex;
  bool restroAssignFirstTime = true;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    _cartId = prefs.getString("cart_id");
    print("cart ${prefs.getString("cart_id")}");
  }

  void updateRestaurants() {
    int currentItems;
    if (restaurantIndex + 10 > totalRestaurants) {
      currentItems = totalRestaurants - restaurantIndex;
    } else {
      currentItems = 10;
    }
    restaurantIndex += currentItems;
    setState(() {});
  }

  void _scrollListener() {
    if (controller.position.atEdge) {
      if (controller.position.pixels != 0) {
        print("Samiran");
        updateRestaurants();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _restroListApi = _foodHomeRepo.restaurantsList(_categodyId);
    _allCouponApi = _foodHomeRepo.allCouponList();
    controller = new ScrollController()..addListener(_scrollListener);
    createSharedPref();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //Custom AppBar....
          appBar: CustomAppBarFoodHome(address, _cartId),
          backgroundColor: darkThemeBlue, //Main Body Back Color
          body: ListView(
            controller: controller,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              FutureBuilder<acm.AllCouponModel>(
                future: _allCouponApi,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    for (int i = 0; i < snapshot.data.data.length; i++) {
                      if (snapshot.data.data[i].categories[0].categoryId == _categodyId) {
                        allCouponData.add(snapshot.data.data[i]);
                        // print(i);
                      }
                    }
                    if (allCouponData.length > 0) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Offer Text...
                          Container(
                              margin: EdgeInsets.fromLTRB(15, 20, 10, 10),
                              child: Text(
                                "OFFERS",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
                              )),

                          Container(
                            color: darkThemeBlue,
                            height: 195.0,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: allCouponData.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  offerIndex = (index - ((index / offerPlaceHolder.length).floor() * offerPlaceHolder.length));
                                  // print(offerIndex);
                                  return InkWell(
                                    onTap: () {
                                      // print("$imageBaseURL${allCouponData[index].couponBannerUrl}");
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) {
                                            return AlertDialog(
                                              // title: Text("Give the code?"),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(),
                                                        ),
                                                        Expanded(
                                                          flex: 6,
                                                          child: Container(
                                                            clipBehavior: Clip.hardEdge,
                                                            decoration: BoxDecoration(
                                                                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                                                            child: FadeInImage(
                                                              height: 180.0,
                                                              width: 130.0,
                                                              image: NetworkImage(
                                                                "$imageBaseURL${allCouponData[index].couponBannerUrl}",
                                                              ),
                                                              placeholder: AssetImage("assets/images/placeHolder/Offer/blue.png"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Align(
                                                            alignment: Alignment.topRight,
                                                            child: InkWell(
                                                                child: Icon(Icons.cancel_outlined),
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                }),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text(
                                                        "${allCouponData[index].couponDescription}",
                                                        style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 12.0),
                                                      child: Text(
                                                        "Valid From : ${allCouponData[index].couponValidFrom}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          // fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 5.0),
                                                      child: Text(
                                                        "Valid To : ${allCouponData[index].couponValidTo}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0,
                                                          // fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Vendors : ",
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              (allCouponData[index].vendors.length > 0)
                                                                  ? "${allCouponData[index].vendors[0].shopName}"
                                                                  : "For All Vendors",
                                                              style: TextStyle(
                                                                  color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Coupon Code : ",
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                          Text(
                                                            "${allCouponData[index].couponCode}",
                                                            style:
                                                                TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Colors.red,
                                                    ),
                                                    Center(
                                                      child: new FlatButton(
                                                          shape: RoundedRectangleBorder(
                                                              side:
                                                                  BorderSide(color: Colors.deepOrange, width: 1, style: BorderStyle.solid),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child: const Text(
                                                            "Copy Coupon Code",
                                                            style: TextStyle(
                                                              color: Colors.deepOrangeAccent,
                                                              fontSize: 14.0,
                                                              // fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            ClipboardManager.copyToClipBoard("${allCouponData[index].couponCode}")
                                                                .then((result) {
                                                              Fluttertoast.showToast(
                                                                  msg: "${allCouponData[index].couponCode} Copied to Your ClipBoard",
                                                                  fontSize: 14,
                                                                  backgroundColor: Colors.orange[100],
                                                                  textColor: darkThemeBlue,
                                                                  toastLength: Toast.LENGTH_LONG);
                                                              Navigator.pop(context);
                                                            });
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                      margin: EdgeInsets.all(8.0),
                                      color: darkThemeBlue,
                                      child: Container(
                                        // margin: EdgeInsets.only(bottom: 15),
                                        height: 120.0,
                                        width: 120.0,
                                        clipBehavior: Clip.hardEdge,
                                        decoration:
                                            BoxDecoration(color: lightThemeBlue, borderRadius: BorderRadius.all(Radius.circular(12))),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                            "$imageBaseURL${allCouponData[index].couponBannerUrl}",
                                          ),
                                          placeholder: AssetImage("assets/images/placeHolder/Offer/${offerPlaceHolder[offerIndex]}"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    } else
                      return Container();
                  } else if (snapshot.hasError) {
                    print(snapshot.hasError);
                    return Text("");
                  } else
                    return VideoShimmer(
                      padding: EdgeInsets.all(0.0),
                      margin: EdgeInsets.only(top: 15, bottom: 20),
                      hasBottomBox: false,
                    );
                },
              ),

              Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    "Popular Restaurants".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
                  )),

              //Popular Restaurants Details
              (userAddress != null)
                  ? FutureBuilder<rlm.RestaurantsListModel>(
                      future: _restroListApi,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                          if (restroAssignFirstTime) {
                            print("before calc " + DateTime.now().toLocal().toString());

                            for (int i = 0; i < snapshot.data.data.length; i++) {
                              double totalDistance = calculateDistance(
                                  userLat,
                                  userLong,
                                  (snapshot.data.data[i].latitude != null) ? double.parse(snapshot.data.data[i].latitude) : userLat,
                                  (snapshot.data.data[i].longitude != null) ? double.parse(snapshot.data.data[i].longitude) : userLong);

                              snapshot.data.data[i].distance = totalDistance;
                            }
                            snapshot.data.data.sort((a, b) => a.distance.compareTo(b.distance));

                            print("after calc " + DateTime.now().toLocal().toString());
                            restroAssignFirstTime = false;
                          }

                          if (totalRestaurants == 0) {
                            totalRestaurants = snapshot.data.data.length;
                            int currentItems;
                            restaurantIndex = 0;
                            if (restaurantIndex + 10 > totalRestaurants) {
                              currentItems = totalRestaurants - restaurantIndex;
                            } else {
                              currentItems = 10;
                            }
                            restaurantIndex += currentItems;
                          }
                          print("before build " + DateTime.now().toLocal().toString());
                          return ListView.builder(
                              shrinkWrap: true,
                              // controller: controller,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: restaurantIndex,
                              itemBuilder: (context, index) {
                                restroIndex = (index - ((index / restroPlaceHolder.length).floor() * restroPlaceHolder.length));

                                availableFrom = DateFormat("HH:mm:ss").parse(snapshot.data.data[index].availableFrom);
                                availableTo = DateFormat("HH:mm:ss").parse(snapshot.data.data[index].availableTo);

                                if (DateTime.now().compareTo(
                                            DateTime(nowTime.year, nowTime.month, nowTime.day, availableFrom.hour, availableFrom.minute)) >
                                        0 &&
                                    DateTime.now().compareTo(
                                            DateTime(nowTime.year, nowTime.month, nowTime.day, availableTo.hour, availableTo.minute)) <
                                        0) {
                                  snapshot.data.data[index].shopTimingAvailability = true;
                                } else {
                                  snapshot.data.data[index].shopTimingAvailability = false;
                                }

                                return Visibility(
                                  //visible: snapshot.data.data[index].distance <= 10.0,
                                  child: InkWell(
                                    onTap: () {
                                      if(snapshot.data.data[index].distance <= 30.0) {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShopDetail(
                                                      shopLat: (snapshot.data
                                                          .data[index]
                                                          .latitude != null)
                                                          ? double.parse(
                                                          snapshot.data
                                                              .data[index]
                                                              .latitude)
                                                          : userLat,
                                                      shopLong: (snapshot.data
                                                          .data[index]
                                                          .longitude != null)
                                                          ? double.parse(
                                                          snapshot.data
                                                              .data[index]
                                                              .longitude)
                                                          : userLong,
                                                      categoryId: snapshot.data
                                                          .data[index]
                                                          .categoryId
                                                          .toString(),
                                                      vendorId: snapshot.data
                                                          .data[index].vendorId
                                                          .toString(),
                                                      vendorName: snapshot.data
                                                          .data[index].shopName,
                                                      shopAvailability: snapshot
                                                          .data.data[index]
                                                          .shopTimingAvailability,
                                                      cartId: prefs.getString(
                                                          "cart_id") ?? "",
                                                    )));
                                      }
                                      else
                                        {
                                          Fluttertoast.showToast(
                                              msg: "${snapshot.data.data[index].shopName} is Undeliverable at your location",
                                              fontSize: 14,
                                              backgroundColor: Colors.orange[100],
                                              textColor: darkThemeBlue,
                                              toastLength: Toast.LENGTH_LONG);
                                        }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(7.0),
                                        padding: EdgeInsets.all(5.0),
                                        height: screenWidth * 0.27,
                                        // width: screenWidth*0.05,
                                        // height: 100.0,
                                         //color: Colors.white.withOpacity(0.5),
                                        decoration:
                                            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: (snapshot.data.data[index].distance <= 30.0)?Colors.white:Colors.white.withOpacity(0.7)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: screenWidth * 0.24,
                                                  // width: screenWidth * 0.20,
                                                  // height: double.infinity,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                                  ),
                                                  child: FadeInImage(
                                                    image: NetworkImage("$imageBaseURL${snapshot.data.data[index].vendorImage}"),
                                                    placeholder:
                                                        AssetImage("assets/images/placeHolder/restro/${restroPlaceHolder[restroIndex]}"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 8,
                                              child: Container(
                                                // color: Colors.redAccent,
                                                width: screenWidth * 0.58,
                                                margin: EdgeInsets.only(left: 15.0, top: 4.0, right: 10.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text("${snapshot.data.data[index].shopName}",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                              fontSize: screenWidth * 0.04)),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "${snapshot.data.data[index].address}",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: screenWidth * 0.032),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            size: screenWidth * 0.037,
                                                            color: Colors.orangeAccent,
                                                          ),
                                                          Text(
                                                            " ${snapshot.data.data[index].averageRating ?? 4.2}",
                                                            style: TextStyle(
                                                              color: Colors.orangeAccent,
                                                            ),
                                                          ),
                                                          Spacer(),

                                                          // SizedBox(
                                                          //   width: 20.0,
                                                          // ),
                                                          Icon(
                                                            Icons.access_time,
                                                            color: Colors.black45,
                                                            size: screenWidth * 0.032,
                                                          ),
                                                          Text(
                                                            " ${snapshot.data.data[index].availableFrom.split(":")[0]}:${snapshot.data.data[index].availableFrom.split(":")[1]} - ${snapshot.data.data[index].availableTo.split(":")[0]}:${snapshot.data.data[index].availableTo.split(":")[1]}",
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                color: Colors.black45,
                                                                fontSize: screenWidth * 0.030),
                                                          ),
                                                          Spacer(),
                                                          (snapshot.data.data[index].shopTimingAvailability)
                                                              ? Text("OPEN",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: screenWidth * 0.032,
                                                                    color: Colors.green,
                                                                  ))
                                                              : Text("CLOSED",
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: screenWidth * 0.032,
                                                                    color: Colors.red[800],
                                                                  ))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              });
                        }
                        else if (snapshot.hasError) {
                          print(snapshot.error);
                          if(snapshot.error.toString().contains("No Internet connection")){
                            return Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                    NoInternetBackground(imageHeight: screenHeight*0.35,imageWidth: screenWidth*0.8,
                                      onTapButton: (){
                                        _restroListApi = _foodHomeRepo.restaurantsList(_categodyId);
                                        _allCouponApi = _foodHomeRepo.allCouponList();
                                        setState(() {});
                                      },),
                                    SizedBox(
                                      height: screenHeight * 0.05,
                                    ),
                                  ],
                                ));
                          }else
                          return Center(
                              child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.15,
                              ),
                              Image.asset("assets/images/icons/sad_face.png",
                                height: screenHeight*0.1,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Oops! Something went wrong. please try again...",
                                style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              new FlatButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.deepOrange, width: 0.6, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text(
                                    "Try Again",
                                    style: TextStyle(
                                        color: Colors.deepOrangeAccent, fontSize: 13.0, letterSpacing: 0.5, fontWeight: FontWeight.w400),
                                  ),
                                  onPressed: () {
                                    _restroListApi = _foodHomeRepo.restaurantsList(_categodyId);
                                    setState(() {});
                                  }),
                              SizedBox(
                                height: screenHeight * 0.2,
                              ),
                            ],
                          ));
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return ListTileShimmer(
                                  padding: EdgeInsets.only(top: 0, bottom: 0),
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
                                  height: 20,
                                  isDisabledAvatar: false,
                                  isRectBox: true,
                                  colors: [Colors.white],
                                );
                              });
                        } else
                          return Container();
                      },
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: lightThemeBlue,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            child: Text(
                              "  Please Select Delivery Location",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

              //Your Recent Orders List
              RecentOrders(),

              SizedBox(
                height: 50.0,
              )
            ],
          )),
    );
  }
}

// Custom AppBar Class...
// class CustomAppBar extends PreferredSize {
//   final String _address;
//   final String _cartId;
//   final int cartItemNo;
//
//   CustomAppBar(this._address, this._cartId, this.cartItemNo);
//
//   @override
//   Size get preferredSize => Size.fromHeight(120.0);
//
//   @override
//   Widget build(BuildContext context) {
//     print("cart hereeaaae $_cartId");
//     return Container(
//       height: 120.0,
//       child: Column(
//         children: [
//           //Upper Container with Address and icons....
//           Container(
//             margin: EdgeInsets.fromLTRB(15, 0, 10, 5),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(0.0, 5.0, 3.0, 5.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: Icon(
//                       Icons.location_on,
//                       color: Colors.white,
//                       size: 18.0,
//                     ),
//                   ),
//
//                   //Address Text....
//                   Expanded(
//                     flex: 9,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => MapHomePage1(
//                                       pageIndex: 1,
//                                     )
//                                 // AddressPage()
//                                 ));
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 2.9),
//                             child: Text(
//                               "Delivery Location",
//                               overflow: TextOverflow.visible,
//                               style: TextStyle(color: Colors.white70, fontSize: 10.5),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Expanded(
//                                 flex: 7,
//                                 child: Text(
//                                   userAddress??"Choose Delivery Address...",
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(color: Colors.white, fontSize: 12.5),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: Icon(
//                                   Icons.edit_outlined,
//                                   color: Colors.white,
//                                   size: 15.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//
//                     ),
//                   ),
//
//                   //Address Arrow Icon....
//                   /*Icon(
//                     Icons.keyboard_arrow_down,
//                     color: Colors.white,
//                     size: 14.0,
//                   ),*/
//
//                   //Bell Icon in Expanded....
//                   // Expanded(
//                   //   flex: 1,
//                   //   child: Badge(
//                   //
//                   //     position: BadgePosition.bottomStart(bottom: 10.0,start: 14.0),
//                   //     badgeContent: Text('3',style: TextStyle(
//                   //       fontSize: 12.0,
//                   //       color: Colors.white
//                   //     ),),
//                   //     badgeColor: Colors.deepOrangeAccent,
//                   //     child: Icon(Icons.shopping_cart_outlined,
//                   //       color: Colors.white,
//                   //       size: 24.0,),
//                   //   ),
//                   // ),
//                   /*Expanded(
//                     flex: 1,
//                     child: Container(
//                       alignment: Alignment.centerRight,
//                       child: (_cartId!="")?InkWell(
//                         onTap: (){
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => CartPage()
//                                 // AddressPage()
//                               ));
//                         },
//                         child: Badge(
//                           position: BadgePosition.bottomStart(bottom: 10.0,start: 14.0),
//                           badgeContent: Text('$cartItemNo',style: TextStyle(
//                               fontSize: 12.0,
//                               color: Colors.white
//                           ),),
//                           badgeColor: Colors.deepOrangeAccent,
//                           child: Icon(Icons.shopping_cart_outlined,
//                             color: Colors.white,
//                             size: 24.0,),
//                         ),
//                       ):IconButton(
//                         icon: Icon(
//                           Icons.remove_shopping_cart_outlined,
//                           color: Colors.deepOrangeAccent,
//                           size: 24.0,
//                         ),
//                         onPressed: () {
//                           Fluttertoast.showToast(
//                               msg: "You Have Nothing In Your Cart",
//                               fontSize: 16,
//                               backgroundColor: Colors.orange[100],
//                               textColor: darkThemeBlue,
//                               toastLength: Toast.LENGTH_LONG);
//                           // do something
//                         },
//                       ),
//                     ),
//                   )*/
//
//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                         alignment: Alignment.centerRight,
//                         child: /*(_cartId!="")?*/ IconButton(
//                           icon: Icon(
//                             Icons.shopping_cart_outlined,
//                             color: Colors.white,
//                             size: 22.0,
//                           ),
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => CartPage()
//                                     // AddressPage()
//                                     ));
//                           },
//                         )
//                         /*:IconButton(
//                         icon: Icon(
//                           Icons.remove_shopping_cart_outlined,
//                           color: Colors.white,
//                           size: 22.0,
//                         ),
//                         onPressed: () {
//                           Fluttertoast.showToast(
//                               msg: "You Have Nothing In Your Cart",
//                               fontSize: 16,
//                               backgroundColor: Colors.orange[100],
//                               textColor: darkThemeBlue,
//                               toastLength: Toast.LENGTH_LONG);
//                           // do something
//                         },
//                       ),*/
//                         ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//
//           //Search TextFiled Container....
//           Container(
//             height: 45.0,
//             alignment: Alignment.topCenter,
//             margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(5.0)),
//             ),
//             child: TextField(
//               readOnly: true,
//               style: TextStyle(fontSize: 14.0),
//               textAlignVertical: TextAlignVertical.top,
//               decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   hintText: "search",
//                   hintStyle: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14.0,
//                   ),
//                   border: InputBorder.none),
//               onTap: () {
//                 showSearch(context: context, delegate: SearchPage());
//               },
//             ),
//           ),
//         ],
//       ),
//
//       // height: preferredSize.height,
//       // color: lightThemeBlue,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         color: lightThemeBlue,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
//       ),
//       // child: child,
//     );
//   }
// }

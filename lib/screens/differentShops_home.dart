import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:delivery_on_time/cart_screen/cart_page.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/restaurants_screen/customAppBarFoodHome.dart';
import 'package:delivery_on_time/restaurants_screen/model/allCouponModel.dart' as acm;
import 'package:delivery_on_time/restaurants_screen/model/recentOrdersModel.dart';
import 'package:delivery_on_time/restaurants_screen/model/restaurantsListModel.dart' as rlm;
import 'package:delivery_on_time/restaurants_screen/recentOrders.dart';
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:delivery_on_time/restaurants_screen/shop_details.dart';
import 'package:delivery_on_time/screens/mapCurrentAddressPicker.dart';
import 'package:delivery_on_time/search_screen/searchPage.dart';
import 'package:delivery_on_time/widgets/noInternetBackground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math' show cos, sqrt, asin;



class DifferentShopsHome extends StatefulWidget {
  // 18001025963
  final int _categodyId;


  DifferentShopsHome(this._categodyId);

  @override
  _DifferentShopsHomeState createState() => _DifferentShopsHomeState(_categodyId);
}

class _DifferentShopsHomeState extends State<DifferentShopsHome> {
  final int _categodyId;

  _DifferentShopsHomeState(this._categodyId);

  String address = "";
  FoodHomeRepository _foodHomeRepo = new FoodHomeRepository();

  List offer_images = [
    "offer1.png",
    "offer2.png",
    "offer1.png",
    "offer2.png",
    "offer1.png"
  ];

  List restaurants_images = [
    "pizzaHut.png",
    "dhaba.png",
    "snacksShop.png",
    "biriyaniHouse.png",
  ];

  List restaurants_name = [
    "Pizzahut Kolkata",
    "Raushan Shahi Dhaba",
    "Snacks Shop",
    "Biriyani House",
  ];

  List offerPlaceHolder=[
    "yellow.png",
    "red.png",
    "green.png",
  ];
    // "blue.png",
  List cakeShopPlaceHolder=[
    "cake1.png",
    "cake2.png",
    "cake3.png",
    "cake4.png",
  ];

  int cakeShopIndex=0;
  int offerIndex=0;

  List<acm.Data> allCouponData=[];

  SharedPreferences prefs;
  String _cartId="";
  Future<rlm.RestaurantsListModel> _groceryListApi;
  Future<acm.AllCouponModel> _allCouponApi;

  DateTime startTime;
  DateTime endTime;
  DateTime nowTime=DateTime.now();
  DateTime availableFrom;
  DateTime availableTo;

  // List<double> shopDistance=new List<double>();
  // List<bool> shopTimingAvailability=new List<bool>();
  bool restroAssignFirstTime = true;

  ScrollController controller;
  int totalRestaurants = 0;
  int restaurantIndex;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    _cartId=prefs.getString("cart_id");
  }

  void updateRestaurants() {
    int currentItems;
    if(restaurantIndex + 10 > totalRestaurants) {
      currentItems = totalRestaurants - restaurantIndex;
    }
    else {
      currentItems = 10;
    }
    restaurantIndex += currentItems;
    setState(() {

    });
  }

  void _scrollListener() {
    if (controller.position.atEdge) {
      if(controller.position.pixels != 0) {
        print("Samiran");
        updateRestaurants();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _groceryListApi=_foodHomeRepo.restaurantsList(_categodyId);
    _allCouponApi=_foodHomeRepo.allCouponList();
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
            shrinkWrap: true,
            controller: controller,
            physics: ScrollPhysics(),
            children: [

              //Offer Images...
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
                    if(allCouponData.length>0){
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
                                  offerIndex=(index-((index/offerPlaceHolder.length).floor()*offerPlaceHolder.length));
                                  return InkWell(
                                    onTap: () {
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
                                                              style: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w500),
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
                                                            style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
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
                                                              side: BorderSide(color: Colors.deepOrange, width: 1, style: BorderStyle.solid),
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
                                                            ClipboardManager.copyToClipBoard("${allCouponData[index].couponCode}").then((result) {
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
                                        decoration: BoxDecoration(color: lightThemeBlue, borderRadius: BorderRadius.all(Radius.circular(12))),
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
                    }else
                      return Container();

                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("");
                  } else
                    return VideoShimmer(
                      padding: EdgeInsets.all(0.0),
                      margin: EdgeInsets.only(top: 15,bottom: 20),
                      hasBottomBox: false,
                    );
                },
              ),

              Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    "Popular Shops".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  )),

              //Popular Restaurants Details
              (userAddress!=null)?
              FutureBuilder<rlm.RestaurantsListModel>(
                future: _groceryListApi,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('DATA PRESENT');
                    print('${snapshot.data.data.length}');

                    if (restroAssignFirstTime) {

                      for (int i = 0; i < snapshot.data.data.length; i++) {
                        double totalDistance = calculateDistance(
                            userLat,
                            userLong,
                            (snapshot.data.data[i].latitude != null) ? double.parse(snapshot.data.data[i].latitude) : userLat,
                            (snapshot.data.data[i].longitude != null) ? double.parse(snapshot.data.data[i].longitude) : userLong);

                        snapshot.data.data[i].distance = totalDistance;
                      }
                      snapshot.data.data.sort((a, b) => a.distance.compareTo(b.distance));

                      restroAssignFirstTime = false;
                    }

                    if(totalRestaurants == 0) {
                      totalRestaurants = snapshot.data.data.length;
                      int currentItems;
                      restaurantIndex = 0;
                      if(restaurantIndex + 10 > totalRestaurants) {
                        currentItems = totalRestaurants - restaurantIndex;
                      }
                      else {
                        currentItems = 10;
                      }
                      restaurantIndex += currentItems;
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: restaurantIndex,
                        itemBuilder: (context, index) {

                          cakeShopIndex=(index-((index/cakeShopPlaceHolder.length).floor()*cakeShopPlaceHolder.length));

                          availableFrom=DateFormat("HH:mm:ss").parse(snapshot.data.data[index].availableFrom);
                          availableTo=DateFormat("HH:mm:ss").parse(snapshot.data.data[index].availableTo);


                          // print(snapshot.data.data[index].shopName);
                          if(DateTime.now(). compareTo(DateTime(nowTime.year,nowTime.month,nowTime.day,availableFrom.hour,availableFrom.minute))>0 &&
                              DateTime.now(). compareTo(DateTime(nowTime.year,nowTime.month,nowTime.day,availableTo.hour,availableTo.minute))<0){
                            snapshot.data.data[index].shopTimingAvailability = true;
                          }else{
                            snapshot.data.data[index].shopTimingAvailability = false;
                          }
                          // print(DateTime.now(). compareTo(DateTime(nowTime.year,nowTime.month,nowTime.day,availableFrom.hour,availableFrom.minute)));
                          // print(DateTime.now().compareTo(DateTime.now()));

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
                                            categoryId: snapshot.data
                                                .data[index].categoryId
                                                .toString(),
                                            vendorId: snapshot.data.data[index]
                                                .vendorId.toString(),
                                            vendorName: snapshot.data
                                                .data[index].shopName,
                                            shopAvailability: snapshot.data
                                                .data[index]
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
                                  // color: Colors.white,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: (snapshot.data.data[index].distance <= 30.0)?Colors.white:Colors.white.withOpacity(0.7)),
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
                                              placeholder: AssetImage("assets/images/placeHolder/cake/${cakeShopPlaceHolder[cakeShopIndex]}"),
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
                                                        fontWeight: FontWeight.bold, color: Colors.black, fontSize: screenWidth * 0.04)),
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
                                                      " ${snapshot.data.data[index].averageRating??4.2}",
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
                                                    (snapshot.data.data[index].shopTimingAvailability)?
                                                    Text("OPEN",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: screenWidth * 0.032,
                                                          color: Colors.green,
                                                        ))
                                                        :
                                                    Text("CLOSED",
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
                  } else if (snapshot.hasError) {
                    if(snapshot.error.toString().contains("No Internet connection")){
                      return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              NoInternetBackground(imageHeight: screenHeight*0.35,imageWidth: screenWidth*0.8,
                                onTapButton: (){
                                  _groceryListApi = _foodHomeRepo.restaurantsList(_categodyId);
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
                                    _groceryListApi = _foodHomeRepo.restaurantsList(_categodyId);
                                    setState(() {});
                                  }),
                              SizedBox(
                                height: screenHeight * 0.2,
                              ),
                            ],
                          ));
                  } else
                    print('LAST ELSE TRIGGERED');
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index){
                          return ListTileShimmer(
                            padding: EdgeInsets.only(top: 0,bottom: 0),
                            margin: EdgeInsets.only(top: 20,bottom: 20),
                            height: 20,
                            isDisabledAvatar: false,
                            isRectBox: true,
                            colors: [
                              Colors.white
                            ],
                          );
                        }
                    );

                },
              )
                  :
              Container(
                margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: lightThemeBlue,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 28,),
                    SizedBox(
                      width: 2,
                    ),
                    Flexible(
                      child: Text("  Please Select Delivery Location",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                        ),),
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // _getLocation() async
  // {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   debugPrint('location: ${position.latitude}');
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   var addresses = await Geocoder.local.findAddressesFromCoordinates(
  //       coordinates);
  //   var first = addresses.first;
  //   address = "${first.addressLine}";
  //   print("${first.featureName} : ${first.addressLine}");
  //   setState(() {
  //
  //   });
  // }
}


// Custom AppBar Class...
// class CustomAppBar extends PreferredSize {
//
//   final String _address;
//   final String _cartId;
//
//   CustomAppBar(this._address, this._cartId);
//
//
//   @override
//   Size get preferredSize => Size.fromHeight(120.0);
//
//   @override
//   Widget build(BuildContext context) {
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
//                       onTap: (){
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => MapHomePage1(pageIndex: 0,)
//                               // AddressPage()
//                             ));
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
//                                   "$userAddress",
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
//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       alignment: Alignment.centerRight,
//                       child: /*(_cartId!="")?*/
//                       IconButton(
//                         icon: Icon(
//                           Icons.shopping_cart_outlined,
//                           color: Colors.white,
//                           size: 22.0,
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => CartPage()
//                                 // AddressPage()
//                               ));
//                         },
//                       )
//                       /*:IconButton(
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
//                     ),
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
//               onTap: (){
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




/*Container(
margin: EdgeInsets.all(5.0),
// color: Colors.white,
height: 225.0,
// decoration: BoxDecoration(
//   // color: lightThemeBlue,
//     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//     ),
child: ListView.builder(
shrinkWrap: true,
itemCount: 5,
scrollDirection: Axis.horizontal,
itemBuilder: (context, index) {
return Card(
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.all(Radius.circular(15.0))),
elevation: 5,
shadowColor: Color.fromRGBO(190, 255, 255, 0.1),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
//Images of Your Recent Orders...
Container(
margin: EdgeInsets.all(5),
height: 135.0,
width: 150.0,
decoration: BoxDecoration(
// color: lightThemeBlue,
borderRadius:
BorderRadius.all(Radius.circular(15.0)),
image: DecorationImage(
image: AssetImage(
"assets/images/restaurants_images/biriyaniHouse.png"),
fit: BoxFit.fill)),
),

//Details of Your Recent Orders...
Container(
margin: EdgeInsets.only(left: 10.0, top: 5.0),
// alignment: Alignment.topLeft,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text("Chicken Biryani",
// textAlign: TextAlign.start,
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 14.0,
color: Colors.black)),

SizedBox(
height: 5.0,
),

Text("Biryani House ",
// textAlign: TextAlign.start,
style: TextStyle(
// fontWeight: FontWeight.bold,
fontSize: 12.0,
color: Colors.black38)),

//Price of Your Recent Orders...
Container(
// color: Colors.blue,
width: 140,
padding: const EdgeInsets.fromLTRB(
0.0, 3.0, 0.0, 0.0),
child: Row(
children: [
Text("Rs. 150/-",
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 14.0,
color: Colors.deepOrange)),
Expanded(
child: Align(
alignment: Alignment.centerRight,
child: Icon(
Icons.shopping_cart,
size: 19.0,
color: Colors.deepOrange,
),
),
),
],
),
)
],
),
)
],
),
);
})),*/


// //Restaurants Near You Text
// Container(
//     margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
//     child: Text(
//       "Shops Near You".toUpperCase(),
//       style: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//           fontSize: 14.0),
//     )),
//
// //Restaurants Near You List
// Container(
//     margin: EdgeInsets.all(5.0),
//     // color: darkThemeBlue,
//     height: 200.0,
//     // decoration: BoxDecoration(
//     //   // color: lightThemeBlue,
//     //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
//     //     ),
//     child: ListView.builder(
//         shrinkWrap: true,
//         itemCount: 5,
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           return Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//                 borderRadius:
//                 BorderRadius.all(Radius.circular(12.0))),
//             elevation: 5,
//             shadowColor: Color.fromRGBO(190, 255, 255, 0.1),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //Images of Near Restaurants...
//                 Container(
//                   margin: EdgeInsets.all(5),
//                   height: 130.0,
//                   width: 230.0,
//                   decoration: BoxDecoration(
//                     // color: lightThemeBlue,
//                       borderRadius:
//                       BorderRadius.all(Radius.circular(12.0)),
//                       image: DecorationImage(
//                           image: AssetImage(
//                               "assets/images/grocery/grocery2.jpeg"),
//                           fit: BoxFit.fill)),
//                 ),
//
//                 //Details of Near Restaurants...
//                 Container(
//                   margin: EdgeInsets.only(left: 10.0, top: 5.0),
//                   // alignment: Alignment.topLeft,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Footware Store",
//                           // textAlign: TextAlign.start,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13.0,
//                               color: Colors.black)),
//
//                       //Rating of Near Restaurants...
//                       Container(
//                         width: 230,
//                         padding: const EdgeInsets.fromLTRB(
//                             0.0, 3.0, 15.0, 0.0),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.star,
//                               size: 16.0,
//                               color: Colors.orangeAccent,
//                             ),
//                             Text(" 4.2",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12.0,
//                                     color: Colors.orangeAccent)),
//                             Text("  (125)",
//                                 style: TextStyle(
//                                   // fontWeight: FontWeight.bold,
//                                     fontSize: 12.0,
//                                     color: Colors.black38)),
//
//                             //Delivery Timing of Near Restaurants...
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.end,
//                                 children: [
//                                   Icon(
//                                     Icons.access_time,
//                                     size: 16.0,
//                                     color: Colors.deepOrange,
//                                   ),
//                                   Text("  30m",
//                                       style: TextStyle(
//                                         fontWeight:
//                                         FontWeight.bold,
//                                         fontSize: 12.0,
//                                         color: Colors.deepOrange,
//                                       ))
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         })
// ),

//Popular Restaurants Text


// FutureBuilder<RestaurantsListModel>(
//   future: _groceryListApi,
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {
//       return ListView.builder(
//           shrinkWrap: true,
//           physics: ScrollPhysics(),
//           itemCount: snapshot.data.data.length,
//
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             ShopDetail(
//                                 categoryId: snapshot.data.data[index].categoryId,
//                                 vendorId: snapshot.data.data[index].vendorId,
//                                 vendorName: snapshot.data.data[index].shopName,
//                                 // shopAvailability: shopTimingAvailability[index],
//
//
//
//                                 // snapshot.data.data[index]
//                                 // .categoryId,
//                                 // snapshot.data.data[index]
//                                 //     .vendorId,
//                                 // snapshot.data.data[index]
//                                 //     .shopName
//                             ))
//                 );
//               },
//               child: Container(
//                   margin: EdgeInsets.all(7.0),
//                   padding: EdgeInsets.all(5.0),
//                   height: screenWidth * 0.27,
//                   // width: screenWidth*0.05,
//                   // height: 100.0,
//                   // color: Colors.white,
//                   decoration: BoxDecoration(
//                       borderRadius:
//                       BorderRadius.all(Radius.circular(12.0)),
//                       color: Colors.white),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           flex: 3,
//                           child: Container(
//                             height: screenWidth * 0.24,
//                             // width: screenWidth * 0.20,
//                             // height: double.infinity,
//                             clipBehavior: Clip.hardEdge,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(12.0)),
//                             ),
//                             child: FadeInImage(
//                               image: NetworkImage("$imageBaseURL${snapshot.data.data[index].vendorImage}"),
//
//                               placeholder: AssetImage(
//                                   "assets/images/placeHolder/square_white.png"),
//                               fit: BoxFit.fill,
//                             ),
//                           )
//                       ),
//                       Expanded(
//                         flex: 8,
//                         child: Container(
//                           // color: Colors.redAccent,
//                           width: screenWidth * 0.58,
//                           margin:
//                           EdgeInsets.only(left: 15.0, top: 4.0,right: 10.0),
//                           child: Column(
//                             crossAxisAlignment:
//                             CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 3,
//                                 child: Text(
//                                     "${snapshot.data.data[index].shopName}",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                         fontSize:
//                                         screenWidth * 0.04)),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Container(
//                                   margin: EdgeInsets.only(top: 0.0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         "${snapshot.data.data[index].city}  ${snapshot.data.data[index].zip}",
//                                         style: TextStyle(
//                                           // fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                             fontSize:
//                                             screenWidth * 0.032),
//                                       ),
//                                       Expanded(
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                             children: [
//                                               Icon(
//                                                 Icons.access_time,
//                                                 color: Colors.black38,
//                                                 size: screenWidth * 0.032,
//                                               ),
//                                               Text(
//                                                 " 9AM-7PM",
//                                                 textAlign: TextAlign.end,
//                                                 style: TextStyle(
//                                                   // fontWeight: FontWeight.bold,
//                                                     color: Colors.black38,
//                                                     fontSize:
//                                                     screenWidth *
//                                                         0.030),
//                                               ),
//                                             ],
//                                           ))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 flex: 2,
//                                 child: Container(
//                                   margin: EdgeInsets.only(top: 0.0),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         Icons.star,
//                                         size: screenWidth * 0.037,
//                                         color: Colors.orangeAccent,
//                                       ),
//                                       Text(
//                                         " 4.2",
//                                         style: TextStyle(
//                                           color: Colors.orangeAccent,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 20.0,
//                                       ),
//                                       Icon(
//                                         Icons.access_time,
//                                         size: screenWidth * 0.032,
//                                         color: Colors.deepOrange,
//                                       ),
//                                       Text("  30m",
//                                           style: TextStyle(
//                                             fontWeight:
//                                             FontWeight.bold,
//                                             fontSize:
//                                             screenWidth * 0.030,
//                                             color: Colors.deepOrange,
//                                           ))
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//
//                     ],
//                   )),
//             );
//           });
//     }
//     else if (snapshot.hasError) {
//       return Text("No Data Found");
//     }
//     else
//       return Center(
//         heightFactor: 5,
//         widthFactor: 10,
//         child:
//         CircularProgressIndicator(
//             backgroundColor: circularBGCol,
//             strokeWidth: strokeWidth,
//             valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
//       );
//   },
// ),


//Your Recent Orders Text...


/*Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    "Your Recent Orders".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14.0),
                  )),*/
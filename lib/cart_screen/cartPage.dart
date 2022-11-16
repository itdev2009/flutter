import 'package:delivery_on_time/address_screens/address_page.dart';
import 'package:delivery_on_time/address_screens/mapAddressPick.dart';
import 'package:delivery_on_time/address_screens/model/addressShowAllModel.dart';
import 'package:delivery_on_time/address_screens/repository/addressRepository.dart';
import 'package:delivery_on_time/cart_screen/model/cartItemsUpdateModel.dart' as cartModel;
import 'package:delivery_on_time/cart_screen/promoCode_page.dart';
import 'package:delivery_on_time/cart_screen/repository/cartRepository.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/otpVerificationPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/bloc/mapDistanceBloc.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../customAlertDialog.dart';
import 'package:delivery_on_time/profile_screen/bloc/profileUpdateBloc.dart';
import 'bloc/cartItemsUpdateBloc.dart';
import 'package:delivery_on_time/profile_screen/model/profileUpdateModel.dart';
import 'package:delivery_on_time/address_screens/addressListPage.dart';

class CartPageNew extends StatefulWidget {
  @override
  _CartPageNewState createState() => _CartPageNewState();
}

class _CartPageNewState extends State<CartPageNew> {
  Future<cartModel.CartItemsUpdateModel> _cartApi;
  Future<AddressShowAllModel> _addressApi;
  ProfileUpdateBloc _profileUpdateBloc;

  AddressRepository _addressRepository;
  CartRepository _cartRepository;
  MapDistanceBloc _mapDistanceBloc;
  CartItemsUpdateBloc _cartItemsUpdateBloc;

  ScrollController _scrollController;
  TextEditingController _phoneNumberController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  bool addressAvailableCheck = true;
  String _userToken = "";
  String userId = "";
  String cartId = "";
  String user_id = "";
  String couponCode = "";
  String userAddress = "";
  String userAddressId = "";
  String userAddressLat = "";
  String userAddressLong = "";
  double shopLat = 0.0;
  double shopLong = 0.0;
  double shopDistance;
  int deliveryTime;
  String name = "";

  // Map _cartBody;

  bool updateCheck = false;
  bool mapApiCheck = false;
  bool firstCheck = true;
  bool cartChangeCheck = false;
  bool cartNotEmptyCheck = false;
  TextEditingController _nameController = new TextEditingController();
  cartModel.Data cartData;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _addressRepository = new AddressRepository();
    _mapDistanceBloc = new MapDistanceBloc();
    _cartItemsUpdateBloc = CartItemsUpdateBloc();
    _cartRepository = new CartRepository();
    _profileUpdateBloc = new ProfileUpdateBloc();
    createSharedPref();

    // if(prefs.getString("cart_id")!="")
    // print("cartId at Cart page"+prefs.getString("cart_id"));
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddressListPage()));
    });
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    addressAvailableCheck = prefs.getString("userAddressLat") == null ? false : true;

    userAddressId = prefs.getString("userAddressId");
    userAddress = prefs.getString("userAddress");
    userAddressLat = prefs.getString("userAddressLat");
    userAddressLong = prefs.getString("userAddressLong");
    shopDistance = prefs.getDouble("shopDistance") ?? 0.0;
    deliveryTime = prefs.getInt("deliveryTime") ?? 15;
    name = prefs.getString("name");
    shopLat = prefs.getDouble("shopLat") ?? userLat;
    shopLong = prefs.getDouble("shopLong") ?? userLong;
    user_id = prefs.getString("user_id") ?? "";
    _userToken = prefs.getString("user_token") ?? "";
    userId = prefs.getString("user_id") ?? "";
    cartId = prefs.getString("cart_id") ?? "";
    _userToken = prefs.getString("user_token") ?? "";
    couponCode = prefs.getString("coupon_code") ?? "";

    if (addressAvailableCheck) {
      mapApiCheck = true;
      _mapDistanceBloc.mapDistanceCal(shopLat, shopLong, double.parse(userAddressLat), double.parse(userAddressLong));
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: CustomDialog(
                  backgroundColor: Colors.white60,
                  clipBehavior: Clip.hardEdge,
                  insetPadding: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(
                          backgroundColor: circularBGCol,
                          strokeWidth: strokeWidth,
                          valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                    ),
                  ),
                ),
              );
            });
      });
    } else {
      Map _body = {"cartid": cartId, "userid": userId, "coupon_code": couponCode, "distance": "0"};
      _cartApi = _cartRepository.cartItemsDetailsNew(_body);
      print("data cart");
      print(_body);
      setState(() {});
    }
  }

  Future<void> managedSharedPref(String totalIncludingTaxDelivery) async {
    prefs.setString("Total_cart_amount", totalIncludingTaxDelivery);
    // cartId=data.data.cartItems[0].cartId;
  }

  final snackBar = SnackBar(
    content: SizedBox(
      width: screenWidth * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/icons/sad.png",
                height: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Your selected address is not deliverable.\nPlease select an address within 30.0 km.",
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035, color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: lightThemeBlue,
        appBar: AppBar(
          backgroundColor: lightThemeBlue,
          title: Text(
            "CART",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: (cartNotEmptyCheck)
            ? (_userToken == "")
                ? Container(
                    alignment: Alignment.centerRight,
                    width: screenWidth * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
                    ),
                    // clipBehavior: Clip.hardEdge,
                    height: 115,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: screenWidth * 0.95,
                        height: 110,
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        decoration: BoxDecoration(
                          color: darkThemeBlue,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.login,
                                  color: Colors.white,
                                  size: screenWidth * 0.06,
                                ),
                                Text(
                                  "    Please Login First to Proceed",
                                  style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.04, color: Colors.white, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                modalSheetToLogin();
                              },
                              child: Container(
                                height: 40.0,
                                width: MediaQuery.of(context).size.width,
                                // padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: darkThemeBlue,
                                          // offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : (addressAvailableCheck)
                    ? Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
                        ),
                        // clipBehavior: Clip.hardEdge,
                        height: 150,
                        child: Stack(
                          // overflow: Overflow.visible,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: screenWidth * 0.95,
                                  height: 150,
                                  padding: EdgeInsets.fromLTRB(18.0, 15.0, 10.0, 0.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.access_time_outlined,
                                              color: orangeCol,
                                              size: screenWidth * 0.038,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 18,
                                            child: Text(
                                              " ${deliveryTime + 30} MINS",
                                              style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.035, color: lightThemeBlue, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.location_on,
                                              color: orangeCol,
                                              size: screenWidth * 0.038,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 18,
                                            child: Text(
                                              " Deliver to",
                                              style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.035, color: lightThemeBlue, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.location_on,
                                              color: orangeCol,
                                              size: screenWidth * 0,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 15,
                                            child: Text(
                                              " $userAddress",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.033, color: lightThemeBlue, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: InkWell(
                                              onTap: () {
                                                modalSheetUserAddress();
                                              },
                                              child: Text(
                                                "CHANGE",
                                                textAlign: TextAlign.end,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: screenWidth * 0.033, color: orangeCol, fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: lightThemeBlue,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _scrollController.animateTo(screenHeight,
                                              duration: new Duration(seconds: 1), curve: Curves.easeInSine);
                                        },
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "VIEW DETAILED BILL",
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.032, color: lightThemeBlue, fontWeight: FontWeight.w400),
                                            ),
                                            Spacer(),
                                            Text(
                                              "  Total Rs.${(cartData != null) ? cartData.totalIncludingTaxDelivery ?? "0.0" : "0.0"}",
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                  fontSize: screenWidth * 0.038, color: lightThemeBlue, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                                bottom: 126,
                                right: 20,
                                child: InkWell(
                                  onTap: () {
                                    if (shopDistance > 30.0) {
                                      scaffoldKey.currentState.showSnackBar(snackBar);
                                    } else if (name == "") {
                                      print("hiii");
                                      modalSheet();
                                      // _modalBottomSheetMenu();
                                    } else
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddressPage(
                                                    addressId: userAddressId,
                                                    totalCartAmount:
                                                        double.parse(cartData.totalIncludingTaxDelivery.replaceAll(",", "")),
                                                  )));
                                  },
                                  child: Container(
                                    width: screenWidth * 0.34,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: darkOrangeCol,
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "PROCEED  >",
                                        style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.038, color: Colors.white, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        width: screenWidth * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
                        ),
                        // clipBehavior: Clip.hardEdge,
                        height: 115,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: screenWidth * 0.95,
                            height: 110,
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            decoration: BoxDecoration(
                              color: darkThemeBlue,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_history,
                                      color: Colors.white,
                                      size: screenWidth * 0.07,
                                    ),
                                    Text(
                                      "  Please Select Address to Proceed",
                                      style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.04, color: Colors.white, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    modalSheetUserAddress();
                                  },
                                  child: Container(
                                    height: 40.0,
                                    width: MediaQuery.of(context).size.width,
                                    // padding: EdgeInsets.symmetric(vertical: 15),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: darkThemeBlue,
                                              // offset: Offset(2, 4),
                                              blurRadius: 5,
                                              spreadRadius: 2)
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                                    child: Text(
                                      'Select Address',
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
            : Container(
                height: 0,
                width: 0,
              ),
        body: ListView(
          shrinkWrap: true,
          controller: _scrollController,
          children: [
            StreamBuilder<ApiResponse<MapDistanceModel>>(
              stream: _mapDistanceBloc.mapDistanceStream,
              builder: (context, snapshot) {
                if (mapApiCheck) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.status) {
                      case Status.LOADING:
                        break;
                      case Status.COMPLETED:
                        {
                          if (snapshot.data.data.rows[0].elements[0].status == "ZERO_RESULTS") {
                            Fluttertoast.showToast(
                                msg: "Please Select a Proper User Location",
                                fontSize: 14,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                            Navigator.pop(context);
                            return Center(
                              child: Text(
                                "Please Select a Proper Restaurant or Proper user Location",
                                textAlign: TextAlign.center,
                                style:
                                    GoogleFonts.poppins(color: Colors.white, fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500),
                              ),
                            );
                          }

                          else {
                            mapApiCheck = false;
                            shopDistance =
                                double.parse((snapshot.data.data.rows[0].elements[0].distance.value / 1000).toStringAsFixed(1));
                            deliveryTime = (snapshot.data.data.rows[0].elements[0].duration.value / 60).ceil();
                            prefs.setDouble("shopDistance", shopDistance);
                            prefs.setInt("deliveryTime", deliveryTime);
                            Future.delayed(Duration.zero, () {
                              Navigator.pop(context);
                              _cartApi = _cartRepository.cartItemsDetailsNew(
                                  {"cartid": cartId, "userid": userId, "coupon_code": couponCode, "distance": "$shopDistance"});
                              setState(() {});
                            });
                          }
                        }
                        break;
                      case Status.ERROR:
                        mapApiCheck = false;
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: "Please try again!",
                            fontSize: 14,
                            backgroundColor: Colors.orange[100],
                            textColor: darkThemeBlue,
                            toastLength: Toast.LENGTH_LONG);
                        print(snapshot.data.message);
                        break;
                    }
                  } else if (snapshot.hasError) {
                    mapApiCheck = false;
                    Navigator.pop(context);
                    print("error");
                  }
                }
                return Container();
              },
            ),
            StreamBuilder<ApiResponse<cartModel.CartItemsUpdateModel>>(
              stream: _cartItemsUpdateBloc.cartItemsUpdateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      Future.delayed(Duration.zero, () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return CustomDialog(
                                backgroundColor: Colors.transparent,
                                clipBehavior: Clip.hardEdge,
                                insetPadding: EdgeInsets.all(0),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    width: 40.0,
                                    height: 40.0,
                                    child: CircularProgressIndicator(
                                        backgroundColor: circularBGCol,
                                        strokeWidth: strokeWidth,
                                        valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                                  ),
                                ),
                              );
                            });
                      });
                      return Container();
                      break;
                    case Status.COMPLETED:
                      {
                        if (cartChangeCheck) {
                          print("data update +++in cart page");
                          Navigator.pop(context);
                          cartData = snapshot.data.data.data;
                          cartChangeCheck = false;
                          cartNotEmptyCheck = (cartData.totalIncludingTaxDelivery != null) ? true : false;
                          if (snapshot.data.data.message.contains("The cart is empty")) {
                            prefs.setString("cart_id", "");
                            prefs.setString("coupon_code", "");
                            print("cart id Cleared : ${prefs.getString("cart_id")}");
                            print("coupon Cleared : ${prefs.getString("coupon_code")}");
                          }
                          Future.delayed(Duration.zero, () {
                            // _cartApi = _cartRepository.cartItemsDetailsNew({"cartid": cartId, "userid": userId, "coupon_code": couponCode, "distance": "$shopDistance"});
                            setState(() {});
                          });
                        }
                      }
                      break;
                    case Status.ERROR:
                      Navigator.pop(context);
                      Fluttertoast.showToast(
                          msg: "Please try again",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_SHORT);
                      print(snapshot.error);

                      break;
                  }
                } else if (snapshot.hasError) {
                  print("error");
                }
                return Container();
              },
            ),
            FutureBuilder<cartModel.CartItemsUpdateModel>(
              future: _cartApi,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  if (firstCheck) {
                    cartData = snapshot.data.data;
                    cartNotEmptyCheck = (cartData.totalIncludingTaxDelivery != null) ? true : false;

                    Future.delayed(Duration.zero, () {
                      setState(() {});
                    });
                    firstCheck = false;
                  }
                  if (cartData.totalIncludingTaxDelivery != null) {
                    managedSharedPref(cartData.totalIncludingTaxDelivery);
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: cartData.cartItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(screenWidth * 0.04, 5.0, screenWidth * 0.04, 5.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.white),
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
                                      child: FadeInImage(
                                        image: NetworkImage(
                                          "$imageBaseURL${cartData.cartItems[index].detailedProductImages}",
                                        ),
                                        placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15.0, top: 2.0, bottom: 2.0, right: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 8,
                                                child: Text(
                                                  "${cartData.cartItems[index].skuName}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: screenWidth * 0.035, color: Colors.black, fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Visibility(
                                                  visible: false,
                                                  child: Icon(
                                                    Icons.delete_forever_outlined,
                                                    size: screenWidth * 0.06,
                                                    color: Colors.red[600],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "₹${cartData.cartItems[index].totalprice}",
                                                style: TextStyle(
                                                    fontSize: screenWidth * 0.037, color: orangeCol, fontWeight: FontWeight.w500),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Map body = {
                                                        "cart_item_id": "${cartData.cartItems[index].cartItemId}",
                                                        "quantity": "${cartData.cartItems[index].quantity - 1}",
                                                        "coupon_code": couponCode,
                                                        "cartid": cartId,
                                                        "distance": "$shopDistance"
                                                      };
                                                      _cartItemsUpdateBloc.cartItemsUpdate(body);
                                                      cartChangeCheck = true;
                                                    },
                                                    child: Icon(
                                                      Icons.remove_circle_outline,
                                                      size: screenWidth * 0.065,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(width: screenWidth * .02),
                                                  Center(
                                                      child: Text(
                                                    "${cartData.cartItems[index].quantity}",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: screenWidth * .042, fontWeight: FontWeight.w400, color: orangeCol),
                                                  )),
                                                  SizedBox(width: screenWidth * .02),
                                                  InkWell(
                                                    onTap: () {
                                                      Map body = {
                                                        "cart_item_id": "${cartData.cartItems[index].cartItemId}",
                                                        "quantity": "${cartData.cartItems[index].quantity + 1}",
                                                        "coupon_code": couponCode,
                                                        "cartid": cartId,
                                                        "distance": "$shopDistance"
                                                      };
                                                      _cartItemsUpdateBloc.cartItemsUpdate(body);
                                                      cartChangeCheck = true;
                                                      // setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.add_circle_outline,
                                                      size: screenWidth * 0.065,
                                                      color: orangeCol,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        (couponCode == "")
                            ? Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.04, left: screenWidth * 0.04),
                                child: InkWell(
                                  onTap: () {
                                    (_userToken != "")
                                        ? Navigator.push(context, MaterialPageRoute(builder: (context) => PromoCodePage()))
                                        : Fluttertoast.showToast(
                                            msg: "Please Login First to apply Coupon",
                                            fontSize: 16,
                                            backgroundColor: Colors.white,
                                            textColor: darkThemeBlue,
                                            toastLength: Toast.LENGTH_LONG);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.red[600]),
                                    width: screenWidth * .92,
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: Colors.white,
                                          size: screenWidth * 0.05,
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.03,
                                        ),
                                        Text(
                                          "Add Promo Code",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white, fontSize: screenWidth * 0.04, fontWeight: FontWeight.w400),
                                        ),
                                        Spacer(),
                                        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: screenWidth * 0.05),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(right: screenWidth * 0.04, left: screenWidth * 0.04),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(17, 0, 15, 0),
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: darkThemeBlue.withOpacity(0.5)),
                                  width: screenWidth * .92,
                                  height: 50,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/icons/check.png",
                                        height: screenWidth * 0.06,
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.03,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Promo Code Applied",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white, fontSize: screenWidth * 0.04, fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            "${couponCode ?? "PROMO"}".toUpperCase(),
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: screenWidth * 0.03,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 1),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      InkWell(
                                          onTap: () {
                                            prefs.setString("coupon_code", "");
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPageNew()));
                                            Fluttertoast.showToast(
                                                msg: "Coupon Code Cleared Successfully",
                                                fontSize: 16,
                                                backgroundColor: Colors.white,
                                                textColor: darkThemeBlue,
                                                toastLength: Toast.LENGTH_LONG);
                                          },
                                          child: Image.asset(
                                            "assets/images/icons/cancel.png",
                                            height: screenWidth * 0.065,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.only(
                              top: screenHeight * .01,
                              right: screenWidth * 0.03,
                              left: screenWidth * 0.03,
                              bottom: screenHeight * 0.01),
                          margin: EdgeInsets.only(
                              top: screenHeight * .02,
                              right: screenWidth * 0.04,
                              left: screenWidth * 0.04,
                              bottom: screenHeight * 0.05),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Total Amount",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.037,
                                        color: lightThemeBlue,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "₹${cartData.cartTotalAmount}",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                    )
                                  ],
                                ),
                              ),
                              (cartData.totalAfterDiscount != null)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Discount Amount",
                                            style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                          ),
                                          Spacer(),
                                          Text(
                                            "[ - ] ₹${(double.parse(cartData.cartTotalAmount) - double.parse(cartData.totalAfterDiscount.replaceAll(",", ""))).toStringAsFixed(2)}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: Colors.green),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (cartData.totalAfterDiscount != null)
                                  ? Column(
                                      children: [
                                        Divider(
                                          thickness: 1,
                                          color: lightThemeBlue,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Amount After Discount",
                                                style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                              ),
                                              Spacer(),
                                              Text(
                                                "₹${cartData.totalAfterDiscount}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              (cartData.packingCharges != "0.00")
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Packaging charge",
                                            style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                          ),
                                          Spacer(),
                                          Text(
                                            "₹${cartData.packingCharges}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              (cartData.orderSurcharge != 0)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Order surcharge",
                                            style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                          ),
                                          Spacer(),
                                          Text(
                                            "₹${cartData.orderSurcharge}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "GST",
                                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                    ),
                                    Text(
                                      " (${cartData.gst}%)",
                                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.033, color: lightThemeBlue),
                                    ),
                                    Spacer(),
                                    Text(
                                      "₹${cartData.taxAmount}",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1.0, 3.0, 1.0, 3.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Delivery partner fee",
                                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                    ),
                                    Text(
                                      " (for $shopDistance Km)",
                                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.032, color: lightThemeBlue),
                                    ),
                                    Spacer(),
                                    Text(
                                      "₹${cartData.deliveryFee}",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.037, color: lightThemeBlue),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: lightThemeBlue,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Payable Amount",
                                      style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.04, color: lightThemeBlue, fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      "₹${cartData.totalIncludingTaxDelivery}",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.04, color: lightThemeBlue),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.15,
                        ),
                        Image.asset(
                          "assets/images/cart.png",
                          height: 150.0,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Your Cart is Empty",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: screenWidth * 0.05),
                        )
                      ],
                    );
                  }
                }
                else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("No Data Found");
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    heightFactor: 5,
                    widthFactor: 10,
                    child: CircularProgressIndicator(
                        backgroundColor: circularBGCol,
                        strokeWidth: strokeWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                  );
                } else
                  return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  modalSheetToLogin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Please Login to Proceed",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Theme(
                  data: new ThemeData(
                    primaryColor: orangeCol,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    validator: (value) => value.isEmpty
                        ? "*Phone Number Required"
                        : value.length < 10
                            ? "*Please Enter Proper Phone Number"
                            : null,
                    controller: _phoneNumberController,
                    decoration: new InputDecoration(
                        labelText: "Enter Mobile Number",
                        prefixText: "+91 ",
                        prefixStyle: GoogleFonts.poppins(fontSize: 13.0, color: orangeCol, fontWeight: FontWeight.w500),
                        labelStyle: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w400),
                        fillColor: Colors.white,
                        focusColor: orangeCol,
                        hoverColor: orangeCol),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.poppins(fontSize: 13.0, color: orangeCol, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: () {
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      print('Form is valid');
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return OtpVerificationPage(
                          phoneNumber: _phoneNumberController.text.trim(),
                          redirectPage: "cartPage",
                          cartId: cartId,
                        );
                      }));
                    } else {
                      print('Form is invalid');
                    }
                  },
                  child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.white70,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                      )),
                ),
                // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  modalSheetUserAddress() {
    Map _body = {"userid": "$userId"};
    _addressApi = _addressRepository.addressShowAll(_body, _userToken);
    bool blankAddressCheck = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 15.0),
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: lightThemeBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                ),
                child: Text(
                  "Choose a Delivery Address",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              FutureBuilder<AddressShowAllModel>(
                  future: _addressApi,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.data.isNotEmpty) {
                        return ListView.builder(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data.data[index].longitude != null && snapshot.data.data[index].longitude != "") {
                                blankAddressCheck = false;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  // padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0),
                                  margin: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                  // height: 160,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          print("tap on address Id ${snapshot.data.data[index].id}");
                                          prefs.setString("userAddressLat", snapshot.data.data[index].latitude);
                                          prefs.setString("userAddressLong", snapshot.data.data[index].longitude);
                                          prefs.setString("userAddress", snapshot.data.data[index].address);
                                          prefs.setString("userAddressId", snapshot.data.data[index].id.toString());
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPageNew()));
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                Icons.location_history,
                                                color: Colors.black,
                                                size: screenWidth * 0.08,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${snapshot.data.data[index].addressName}",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.lightBlue[700],
                                                        fontSize: screenWidth * 0.034,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                  Text(
                                                    "${snapshot.data.data[index].address}, ${snapshot.data.data[index].state} - ${snapshot.data.data[index].zip}",
                                                    style: GoogleFonts.poppins(
                                                        color: lightThemeBlue, fontSize: screenWidth * 0.03, fontWeight: FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    "${snapshot.data.data[index].landmark}",
                                                    style: GoogleFonts.poppins(
                                                        color: lightThemeBlue, fontSize: screenWidth * 0.03, fontWeight: FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      (index < snapshot.data.data.length - 1)
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(),
                                                ),
                                                Expanded(
                                                  flex: 8,
                                                  child: Divider(
                                                    color: Colors.black12,
                                                    thickness: 1,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    print("tap on ADD address");
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => MapAddressPick1(
                                                                  redirectPage: "cartPage",
                                                                )));
                                                  },
                                                  child: Container(
                                                    height: 40.0,
                                                    width: MediaQuery.of(context).size.width,
                                                    // padding: EdgeInsets.symmetric(vertical: 15),
                                                    margin: EdgeInsets.only(bottom: 15.0),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: Colors.white70,
                                                              // offset: Offset(2, 4),
                                                              blurRadius: 5,
                                                              spreadRadius: 2)
                                                        ],
                                                        gradient: LinearGradient(
                                                            begin: Alignment.centerLeft,
                                                            end: Alignment.centerRight,
                                                            colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                                                    child: Text(
                                                      'ADD ADDRESS',
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                );
                              } else if (blankAddressCheck && index == snapshot.data.data.length - 1) {
                                return Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/icons/addressSearching.png",
                                      height: screenHeight * 0.25,
                                    ),
                                    // Icon(Icons.home_work_outlined,
                                    //   color: Colors.black87,
                                    //   size: screenWidth*0.2,
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'YOU DON\'T HAVE ANY ADDRESS',
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print("tap on ADD address");
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MapAddressPick1(
                                                      redirectPage: "cartPage",
                                                    )));
                                      },
                                      child: Container(
                                        height: 40.0,
                                        width: MediaQuery.of(context).size.width,
                                        // padding: EdgeInsets.symmetric(vertical: 15),
                                        margin: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.white70,
                                                  // offset: Offset(2, 4),
                                                  blurRadius: 5,
                                                  spreadRadius: 2)
                                            ],
                                            gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                                        child: Text(
                                          'ADD ADDRESS',
                                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else
                                return Container();
                            });
                      } else {
                        return Column(
                          children: [
                            Image.asset(
                              "assets/images/icons/addressSearching.png",
                              height: screenHeight * 0.25,
                            ),
                            // Icon(Icons.home_work_outlined,
                            //   color: Colors.black87,
                            //   size: screenWidth*0.2,
                            // ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'YOU DON\'T HAVE ANY ADDRESS',
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                print("tap on ADD address");
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapAddressPick1(
                                              redirectPage: "cartPage",
                                            )));
                              },
                              child: Container(
                                height: 40.0,
                                width: MediaQuery.of(context).size.width,
                                // padding: EdgeInsets.symmetric(vertical: 15),
                                margin: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.white70,
                                          // offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                                child: Text(
                                  'ADD ADDRESS',
                                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("No Data Found");
                    } else
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return ListTileShimmer(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              margin: EdgeInsets.only(top: 30, bottom: 30),
                              height: 30,
                              isDisabledAvatar: false,
                              isRectBox: true,
                              colors: [Colors.white],
                            );
                          });
                  }),
            ],
          ),
        );
      },
    );
  }

  modalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Please Save Your Name to Proceed",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Theme(
                  data: new ThemeData(
                    primaryColor: orangeCol,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    validator: (value) => value.isEmpty ? "*Name Required" : null,
                    controller: _nameController,
                    decoration: new InputDecoration(
                        labelText: "Full Name",
                        labelStyle: GoogleFonts.poppins(fontSize: 14.0, color: Colors.black54, fontWeight: FontWeight.w400),
                        fillColor: Colors.white,
                        focusColor: orangeCol,
                        hoverColor: orangeCol),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.poppins(fontSize: 13.0, color: orangeCol, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: () {
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      print('Form is valid');
                      File imageFile1;
                      Map body;
                      {
                        body = {"name": "${_nameController.text.trim()}", "user_id": "$user_id"};
                        updateCheck = true;
                        _profileUpdateBloc.profileUpdate(body, imageFile1, _userToken);
                      }
                    } else {
                      print('Form is invalid');
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    // margin: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.white70,
                              // offset: Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                    child: StreamBuilder<ApiResponse<ProfileUpdateModel>>(
                      stream: _profileUpdateBloc.profileUpdateStream,
                      builder: (context, snapshot) {
                        if (updateCheck) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return CircularProgressIndicator(
                                    backgroundColor: circularBGCol,
                                    strokeWidth: strokeWidth,
                                    valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));
                                /*Loading(
                                loadingMessage: snapshot.data.message,
                              );*/
                                break;
                              case Status.COMPLETED:
                                if (snapshot.data.data.message == "Profile updated successfully") {
                                  print("complete");
                                  updateCheck = false;
                                  prefs.setString("name", "${snapshot.data.data.data.name}");
                                  name = snapshot.data.data.data.name;
                                  navToAttachList(context);
                                  Fluttertoast.showToast(
                                      msg: "Profile Updated",
                                      fontSize: 16,
                                      backgroundColor: Colors.white,
                                      textColor: darkThemeBlue,
                                      toastLength: Toast.LENGTH_SHORT);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "${snapshot.data.data.message}",
                                      fontSize: 16,
                                      backgroundColor: Colors.white,
                                      textColor: darkThemeBlue,
                                      toastLength: Toast.LENGTH_LONG);
                                }
                                break;
                              case Status.ERROR:
                                print(snapshot.error);
                                updateCheck = false;
                                Fluttertoast.showToast(
                                    msg: "Please try again!",
                                    fontSize: 16,
                                    backgroundColor: Colors.orange[100],
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);
                                //   Error(
                                //   errorMessage: snapshot.data.message,
                                // );
                                break;
                            }
                          } else if (snapshot.hasError) {
                            updateCheck = false;
                            print(snapshot.error);
                            Fluttertoast.showToast(
                                msg: "Please try again!",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          }
                        }
                        return Text(
                          'Continue',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}

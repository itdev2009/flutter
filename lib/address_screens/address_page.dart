import 'package:delivery_on_time/address_screens/model/addressByAddressIdModel.dart';
import 'package:delivery_on_time/address_screens/model/addressShowAllModel.dart';
import 'package:delivery_on_time/address_screens/repository/addressRepository.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/orderDetails_screen/oderDetails_page.dart';
import 'package:delivery_on_time/orderPlace_paymennt/RazorPayScreen.dart';
import 'package:delivery_on_time/orderPlace_paymennt/bloc/orderPlaceBloc.dart';
import 'package:delivery_on_time/orderPlace_paymennt/model/OrderPlaceResponseModel.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:delivery_on_time/walletScreen/model/walletBalanceModel.dart';
import 'package:delivery_on_time/walletScreen/repository/walletRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addressListPage.dart';

class AddressPage extends StatefulWidget {
  final String addressId;
  final double totalCartAmount;

  AddressPage({this.addressId,this.totalCartAmount});

  @override
  _AddressPageState createState() => _AddressPageState(addressId,totalCartAmount);
}

class _AddressPageState extends State<AddressPage> {
  final String addressId;
  double totalCartAmount;

  _AddressPageState(this.addressId, this.totalCartAmount);

  String _paymentMode;
  bool _orderplaced = false;
  double shopDistance;

  Future<AddressByAddressIdModel> _addressFetchApi;
  WalletRepository _walletRepository;
  Future<WalletBalanceModel> _futureWalletBalance;


  AddressRepository _addressRepository;
  Map _response;
  OrderPlaceBloc _orderPlaceBloc;

  String _name;
  String cartId;
  String userId;
  String userToken;
  String userPhone = "";
  String coupon_code;
  Map body;
  SharedPreferences prefs;
  bool walletCheckedValue = false;
  double payableAmount;
  double walletBalance;
  double payViaWalletAmount=0.0;
  bool paymentModeVisibility=true;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getString("name"));
    _name = prefs.getString("name");
    userToken = prefs.getString("user_token");
    userPhone = prefs.getString("user_phone");
    cartId = prefs.getString("cart_id");
    userId = prefs.getString("user_id");
    totalCartAmount = totalCartAmount??double.parse(prefs.getString("Total_cart_amount").replaceAll(",", ""));
    payableAmount=totalCartAmount;
    coupon_code = prefs.getString("coupon_code");
    shopDistance = prefs.getDouble("shopDistance") ?? 0;

    body = {"addressid": "$addressId"};
    _addressFetchApi = _addressRepository.addressByAddressId(body, userToken);
    Map _walletBody={
      "user_id":"$userId"
    };
    _futureWalletBalance=_walletRepository.walletBalance(_walletBody,userToken);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _addressRepository = new AddressRepository();
    _walletRepository=new WalletRepository();
    createSharedPref();
    _orderPlaceBloc = OrderPlaceBloc();
    // _getLocation();
  }

  navToAttachList(context, OrderPlaceResponseModel data) async {
    Future.delayed(Duration.zero, () {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return RazorPayScreen(
          snapshotData: data,
          userToken: userToken,
          totalCartAmount: totalCartAmount.toString(),
        );
      }));
      _orderplaced = false;
    });
  }

  String address = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            height: 55,
            child: FloatingActionButton.extended(
              backgroundColor: darkOrangeCol,
              /*onPressed: () {
            },*/
              label: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: darkOrangeCol),
                width: screenWidth * .80,
                height: 50,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Payable Amount",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14,
                            fontWeight: FontWeight.w400),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Rs.$payableAmount",
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    StreamBuilder<ApiResponse<OrderPlaceResponseModel>>(
                      stream: _orderPlaceBloc.orderPlaceStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data.status) {
                            case Status.LOADING:
                              return CircularProgressIndicator(
                                  backgroundColor: circularBGCol,
                                  strokeWidth: strokeWidth,
                                  valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));

                              break;
                            case Status.COMPLETED:
                              // if (snapshot.data.data.success != null)
                              {
                                if(snapshot.data.data.message=="Success"){
                                  print("complete");
                                  if ((snapshot.data.data.data.paymentType == "cod" || snapshot.data.data.data.paymentType == "ewallet") &&
                                      snapshot.data.data.message == "Success" &&
                                      _orderplaced) {
                                    Future.delayed(Duration.zero, () {
                                      prefs.setString("cart_id", "");
                                      prefs.setString("cart_item_number", "");
                                      prefs.setString("coupon_code", "");
                                      /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return OrderDetailsPage();
                                  }));*/
                                      // Navigator.of(context).pushAndRemoveUntil(
                                      //     MaterialPageRoute(
                                      //         builder: (context) => OrderDetailsPage()),ModalRoute.withName("/HomeController"));
                                      // Navigator.of(context).pushAndRemoveUntil(
                                      //     MaterialPageRoute(
                                      //         builder: (context) => OrderDetailsPage()),ModalRoute.withName('/HomeController'));

                                      // Navigator.of(context).pushNamedAndRemoveUntil('/orderDetails', ModalRoute.withName('/home'));
                                      Navigator.of(context).pushNamedAndRemoveUntil('/orderConfirm', ModalRoute.withName('/home'));
                                    });
                                    _orderplaced = false;
                                    Fluttertoast.showToast(
                                        msg: "Order has been Placed Successfully",
                                        fontSize: 14,
                                        backgroundColor: Colors.orange[100],
                                        textColor: darkThemeBlue,
                                        toastLength: Toast.LENGTH_LONG);
                                  } else if (snapshot.data.data.data.paymentType == "online" && _orderplaced) {
                                    // managedSharedPref(snapshot.data.data);
                                    navToAttachList(context, snapshot.data.data);
                                    Fluttertoast.showToast(
                                        msg: "You are Redirecting to Payment Gateway",
                                        fontSize: 14,
                                        backgroundColor: Colors.orange[100],
                                        textColor: darkThemeBlue,
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                }
                                else if(snapshot.data.data.message.toString().contains("Token has been expired"))
                                {
                                  print('token expired');
                                  //  modalSheetToLogin();

                                  //  Navigator.pop(context);


                                  userLogin=false;
                                  prefs.clear();
                                  // signOutUser();
                                  // logout();
                                  // Navigator.pushReplacement(context,
                                  //     MaterialPageRoute(builder: (BuildContext context) {
                                  //       return Login();

                                  //     }));

                                  Fluttertoast.showToast(
                                      msg: "Your login session has expired, please re-login!",
                                      fontSize: 14,
                                      backgroundColor: Colors.orange[100],
                                      textColor: darkThemeBlue,
                                      toastLength: Toast.LENGTH_LONG);

                                  //Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                                  // Navigator.pop(context);

                                  Future.delayed(Duration.zero, () {
                                    //  Navigator. ...

                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginByMobilePage() ), ModalRoute.withName('/home'));
                                  });


                                }

                                else{
                                  Fluttertoast.showToast(
                                      msg: "Something is wrong!! Please try again..",
                                      fontSize: 16,
                                      backgroundColor: Colors.orange[100],
                                      textColor: darkThemeBlue,
                                      toastLength: Toast.LENGTH_LONG);
                                }

                              }
                              break;
                            case Status.ERROR:
                              Fluttertoast.showToast(
                                  msg: "${snapshot.data.message}",
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
                          print("error");
                        }

                        return InkWell(
                          onTap: () {
                            if(payViaWalletAmount==totalCartAmount){
                              _orderplaced = true;
                              Map _body = {
                                "order_remarks": '$orderremarks',
                                "image_location": '$baseImage2',
                                "custom_date": '$dateAndTime2',
                                "userid": "$userId",
                                "cartid": "$cartId",
                                "addressid": "$addressId",
                                "payment_type": "ewallet",
                                "coupon_code": coupon_code,
                                "distance": "$shopDistance"
                              };
                              print(_body);
                              _orderPlaceBloc.orderPlace(_body, userToken);
                            }else{
                              if(payViaWalletAmount==0 || payViaWalletAmount==null){
                                if (_paymentMode != null) {
                                  _orderplaced = true;
                                  Map _body = {
                                    "order_remarks": '$orderremarks',
                                    "image_location": '$baseImage2',
                                    "custom_date": '$dateAndTime2',
                                    "userid": "$userId",
                                    "cartid": "$cartId",
                                    "addressid": "$addressId",
                                    "payment_type": "$_paymentMode",
                                    "coupon_code": coupon_code,
                                    "distance": "$shopDistance"
                                  };
                                  print(_body);
                                  _orderPlaceBloc.orderPlace(_body, userToken);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Select Payment Mode",
                                      fontSize: 16,
                                      backgroundColor: Colors.orange[100],
                                      textColor: darkThemeBlue,
                                      toastLength: Toast.LENGTH_LONG);
                                }
                              }
                              else{
                                if (_paymentMode != null) {
                                  _orderplaced = true;
                                  Map _body = {
                                    "order_remarks": '$orderremarks',
                                    "image_location": '$baseImage2',
                                    "custom_date": '$dateAndTime2',
                                    "userid": "$userId",
                                    "cartid": "$cartId",
                                    "addressid": "$addressId",
                                    "payment_type": "$_paymentMode",
                                    "ewallet_amount": "$payViaWalletAmount",
                                    "coupon_code": coupon_code,
                                    "distance": "$shopDistance"
                                  };
                                  print(_body);
                                  _orderPlaceBloc.orderPlace(_body, userToken);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please Select Payment Mode",
                                      fontSize: 16,
                                      backgroundColor: Colors.orange[100],
                                      textColor: darkThemeBlue,
                                      toastLength: Toast.LENGTH_LONG);
                                }
                              }



                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Text(
                                  " Checkout",
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10.0, left: 3),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: lightThemeBlue,

          //App Bar...
          appBar: AppBar(
              backgroundColor: lightThemeBlue,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: Center(
                  child: Text(
                "PROCEED TO CHECKOUT".toUpperCase(),
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
              )),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 0,
                  ),
                ),
              ]),
          body: //Main body Margined Container...
              Padding(
            padding: EdgeInsets.all(screenHeight * 0.015),
            child: FutureBuilder<AddressByAddressIdModel>(
              future: _addressFetchApi,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      //Add Address Text...
                      Text(" Delivery Address Details",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                          )),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),

                      // Address, Name, Phone and others Container...
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(screenHeight * 0.025, screenHeight * 0.015, screenHeight * 0.015, screenHeight * 0.020),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: darkThemeBlue),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //First Row...
                            Text(
                              "$_name",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.042,
                                color: Colors.white
                              ),
                            ),
                            SizedBox(height: 10,),
                            //Second Row...
                            Text(
                              "${snapshot.data.data[0].address}, ${snapshot.data.data[0].landmark}, ${snapshot.data.data[0].city}, ${snapshot.data.data[0].state}, ${snapshot.data.data[0].zip}",
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.poppins(fontSize: screenWidth * 0.035, color: Colors.white70),
                            ),
                            SizedBox(height: 10,),

                            //Third Row...
                            Row(
                              children: [
                                // Phone Number and Icon...
                                Row(
                                  children: [
                                    Icon(Icons.phone_iphone, color: Colors.white70, size: screenWidth * 0.05),
                                    Text(
                                      "  $userPhone",
                                      style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: screenHeight * 0.02,
                      ),

                      //Add Shippng Address Row Text and Icon...
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                      //       return AddressListPage();
                      //     }));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         Icons.add_circle_outline,
                      //         color: Colors.deepOrange,
                      //         size: screenWidth * 0.045,
                      //       ),
                      //       Text(
                      //         " Add Shipping Address",
                      //         style: GoogleFonts.poppins(fontSize: screenWidth * 0.037, color: Colors.deepOrange),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(
                        height: 20,
                      ),

                      FutureBuilder<WalletBalanceModel>(
                        future: _futureWalletBalance,
                        builder: (context, snapshot){

                          if(snapshot.hasData){
                            walletBalance=double.parse(snapshot.data.data.ewalletBalance);
                            if(walletBalance>=1.0){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Wallet Details",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.04,
                                      )),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),

                                  // Wallet data

                                  Container(
                                    decoration: BoxDecoration(
                                      color: darkThemeBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                                    // height: 50.0,
                                    width: screenWidth,
                                    child: Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Colors.white70, // Your color
                                      ),
                                      child: CheckboxListTile(
                                        activeColor: darkOrangeCol,
                                        title: Text(
                                          "Your Wallet Balance",
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth*0.04,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Rs. $walletBalance",
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth*0.04,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: walletCheckedValue,
                                        onChanged: (newValue) {
                                            walletCheckedValue = newValue;
                                            if(newValue){
                                              if(walletBalance>totalCartAmount){
                                                print("only wallet payment");
                                                paymentModeVisibility=false;
                                                payableAmount=0.0;
                                                payViaWalletAmount=totalCartAmount;
                                              }else{
                                                print("both payment");

                                                paymentModeVisibility=true;
                                                payableAmount=double.parse((totalCartAmount-walletBalance).toStringAsFixed(2));
                                                payViaWalletAmount=walletBalance;
                                              }
                                            }else{
                                              print("only cod or online payment");

                                              paymentModeVisibility=true;
                                              payableAmount=totalCartAmount;
                                              payViaWalletAmount=0.0;
                                            }
                                            setState(() {
                                            });
                                          print("total cart amount: $totalCartAmount");
                                          print("wallet balance: $walletBalance");
                                          print("wallet payment use balance: $payViaWalletAmount");
                                          print("payable amount: $payableAmount");
                                        },
                                        controlAffinity: ListTileControlAffinity.trailing, //  <-- leading Checkbox
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }else
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(" Wallet Details",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.04,
                                      )),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),

                                  // Wallet data

                                  Container(
                                    decoration: BoxDecoration(
                                      color: darkThemeBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                                    // height: 50.0,
                                    width: screenWidth,
                                    child: CheckboxListTile(
                                      title: Text(
                                        "Your Wallet Balance",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth*0.04,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Rs. $walletBalance",
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth*0.04,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      value: walletCheckedValue,
                                      onChanged: (newValue) {
                                        Fluttertoast.showToast(
                                            msg: "Please reload your wallet to use",
                                            fontSize: 16,
                                            backgroundColor: Colors.orange[100],
                                            textColor: darkThemeBlue,
                                            toastLength: Toast.LENGTH_LONG);
                                      },
                                      controlAffinity: ListTileControlAffinity.trailing, //  <-- leading Checkbox
                                    ),
                                  ),
                                ],
                              );

                          }else if(snapshot.hasError){
                            print(snapshot.error);
                            return Text("");
                          }else
                            return ListTileShimmer(
                              padding: EdgeInsets.all(5.0),
                              colors: [
                                Colors.white
                              ],
                            );
                        },

                      ),


                      Visibility(
                        visible: paymentModeVisibility,

                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" Select Payment Mode",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: screenWidth * 0.04,
                              )),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: darkThemeBlue,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            // padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
                            // margin: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                            // height: 90.0,
                            width: screenWidth,
                            child: Column(
                              children: [
                                Visibility(
                                  visible: true,
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.white70, // Your color
                                    ),
                                    child: RadioListTile(
                                      activeColor: darkOrangeCol,
                                      title: Text(
                                        "Cash on Delivery",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      value: "cod",
                                      groupValue: _paymentMode,
                                      onChanged: (value) {
                                        setState(() {
                                          _paymentMode = value;
                                          print(_paymentMode);
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.white70, // Your color
                                  ),
                                  child: RadioListTile(
                                    activeColor: darkOrangeCol,
                                    title: Text(
                                      "Online Payment",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    value: "online",
                                    groupValue: _paymentMode,
                                    onChanged: (value) {
                                      setState(() {
                                        _paymentMode = value;
                                        print(_paymentMode);
                                      });
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 10,left:5),
                          //   child: Text(
                          //     "Due to contact-less delivery, we are accepting only Online Payment",
                          //     style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14,
                          //         fontWeight: FontWeight.w400),
                          //   ),),

                        ],
                      )),




                      // COD and Online Payment Radio Button..

                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(12)),
                      //   ),
                      //   padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 15.0),
                      //   // margin: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                      //   height: 90.0,
                      //   width: screenWidth,
                      //   child: Column(
                      //     children: [
                      //       Expanded(
                      //         flex: 1,
                      //         child: Container(
                      //           // height: 20.0,
                      //           width: screenWidth,
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Expanded(
                      //                 flex: 1,
                      //                 child: Radio(
                      //                   value: "cod",
                      //                   groupValue: _paymentMode,
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       _paymentMode = value;
                      //                       print(_paymentMode);
                      //                     });
                      //                   },
                      //                 ),
                      //               ),
                      //               Expanded(
                      //                 flex: 8,
                      //                 child: Padding(
                      //                   padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      //                   child: Text(
                      //                     "Cash On Delivery",
                      //                     style: GoogleFonts.poppins(color: Colors.lightBlue[900], fontSize: 16.0, fontWeight: FontWeight.w600),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       Expanded(
                      //         flex: 1,
                      //         child: Container(
                      //           // height: 20.0,
                      //           width: screenWidth,
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Expanded(
                      //                 flex: 1,
                      //                 child: Radio(
                      //                   value: "online",
                      //                   groupValue: _paymentMode,
                      //                   onChanged: (value) {
                      //                     setState(() {
                      //                       _paymentMode = value;
                      //                       print(_paymentMode);
                      //                     });
                      //                   },
                      //                 ),
                      //               ),
                      //               Expanded(
                      //                 flex: 8,
                      //                 child: Padding(
                      //                   padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      //                   child: Text(
                      //                     "Online Payment",
                      //                     style: GoogleFonts.poppins(color: Colors.lightBlue[900], fontSize: 16.0, fontWeight: FontWeight.w600),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),



                      // COD and Online Payment Radio Button..


                      //Home and Office Button Container
                      /*Row(
                          children: [

                            // Home Container...
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  screenHeight * 0.020,
                                  screenHeight * 0.010,
                                  screenHeight * 0.020,
                                  screenHeight * 0.010),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                                  color: orangeCol),
                              child: Text(
                                "Home",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05,),

                            // Office Container...
                            Container(
                              padding: EdgeInsets.fromLTRB(
                                  screenHeight * 0.020,
                                  screenHeight * 0.010,
                                  screenHeight * 0.020,
                                  screenHeight * 0.010),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                border: Border.all(color: lightTextBlue),
                              ),
                              child: Text(
                                "Office",
                                style: GoogleFonts.poppins(
                                  color: lightTextBlue,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),*/

                      //Total Amount Price Container
                      /*Padding(
                          padding: EdgeInsets.only(top: screenWidth * .09),
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * .025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: orangeCol),
                            width: screenWidth * .94,
                            height: screenHeight * .10,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        " Total Amount",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.04
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Rs.$totalCartAmount",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.bold),

                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                StreamBuilder<ApiResponse<OrderPlaceResponseModel>>(
                                  stream: _orderPlaceBloc.orderPlaceStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      switch (snapshot.data.status) {
                                        case Status.LOADING:
                                          return CircularProgressIndicator(
                                              backgroundColor: Colors.blue[700],
                                              strokeWidth: 7,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[200])
                                          );

                                          break;
                                        case Status.COMPLETED:
                                          // if (snapshot.data.data.success != null)
                                          {
                                            print("complete");
                                            // managedSharedPref(snapshot.data.data);
                                            navToAttachList(context,snapshot.data.data);
                                            Fluttertoast.showToast(
                                                msg: "${snapshot.data.data.data.name} You are Redirecting to Payment Gateway",
                                                fontSize: 14,
                                                backgroundColor: Colors.white,
                                                textColor: darkThemeBlue,
                                                toastLength: Toast.LENGTH_LONG);
                                          }
                                          break;
                                        case Status.ERROR:
                                          Fluttertoast.showToast(
                                              msg: "${snapshot.data.message}",
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
                                      print("error");
                                    }

                                    return InkWell(
                                      onTap: (){
                                        Map _body={
                                          "userid":"$userId",
                                          "cartid":"$cartId",
                                          "addressid":"$addressId"
                                        };
                                        _orderPlaceBloc.orderPlace(_body, userToken);
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 0.0),
                                            child: Text(
                                              " Checkout",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10.0),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),


                              ],
                            ),
                          ),
                        ),*/
                      SizedBox(height: screenHeight * .2)
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("No Data Found");
                } else
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index){
                      return ListTileShimmer(
                        padding: EdgeInsets.all(5.0),
                        colors: [
                          Colors.white
                        ],
                      );
                    }
                  );



                  //   Center(
                  //   heightFactor: 5,
                  //   widthFactor: 10,
                  //   child: CircularProgressIndicator(
                  //       backgroundColor: circularBGCol, strokeWidth: 4, valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                  // );
              },
            ),
          )),
    );
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    address = "${first.featureName} : ${first.addressLine}";
    print("${first.featureName} : ${first.addressLine}");
    setState(() {});
  }
}

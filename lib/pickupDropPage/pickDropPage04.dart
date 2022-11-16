import 'dart:convert';

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropConfirmPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/bloc/pickupDropBloc.dart';
//import 'package:delivery_on_time/pickup_drop_screen/model/multiplePickupmodel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/pickupOrderDetails_page.dart';
import 'package:delivery_on_time/tracking_screen/newMapTrackingPickDropPage.dart';
import 'package:delivery_on_time/walletScreen/model/walletBalanceModel.dart' as wallet;
import 'package:delivery_on_time/walletScreen/repository/walletRepository.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../customAlertDialog.dart';
import 'RazorPayPickDropScreen.dart';

class PickDropPage04 extends StatefulWidget {
  final double distance;
  final double deliveryCharge;

  const PickDropPage04({Key key, this.distance, this.deliveryCharge}) : super(key: key);

  @override
  _PickDropPage04State createState() => _PickDropPage04State(this.distance, this.deliveryCharge);
}

class _PickDropPage04State extends State<PickDropPage04> {
  final double distance;
  final double deliveryCharge;

  _PickDropPage04State(this.distance, this.deliveryCharge);

  GoogleMapController mapController;

  // double _originLatitude = 22.586721999999998, _originLongitude = 88.39889199999999;
  // double _destLatitude = 22.587207, _destLongitude = 88.39868299999999;
  double _originLatitude = pickUpLat, _originLongitude = pickUpLong;
  double _destLatitude = dropLat, _destLongitude = droplong;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = mapAPIKey;
  PickupDropBloc _pickupDropBloc;
  SharedPreferences prefs;
  String senderToken = "";
  String userId = "";
  double walletBalance;
  double payViaWalletAmount = 0.0;
  double payableAmount;
  double exactPayableAmount;
  bool walletCheckedValue = false;
  WalletRepository _walletRepository;
  Future<wallet.WalletBalanceModel> _futureWalletBalance;
  bool onlinePayment = (paymentType == "Online Payment") ? true : false;
  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();
  Map _response;
  Map _body;

  @override
  void initState() {
    super.initState();
    print('Payment type :');
    print(paymentType);
    _pickupDropBloc = new PickupDropBloc();
    _walletRepository = new WalletRepository();
    if (productPrice != null && productPrice != "") {
      payableAmount = deliveryCharge + double.parse(productPrice);
      exactPayableAmount = deliveryCharge + double.parse(productPrice);
    } else {
      payableAmount = deliveryCharge;
      exactPayableAmount = deliveryCharge;
    }
    createSharedPref();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarkerWithHue(90));

    /// destination marker

      for(int i=0; i< numberOfReceivers; i++)
        {
          print('destination${i}');
          _addMarker(LatLng(dropLatList[i], droplongList[i]), "destination${i}", BitmapDescriptor.defaultMarker);
        }


    for(int i =0; i<numberOfReceivers; i++)
    {
      _getPolyline(copydropLatList[i], copydroplongList[i],copydropLatList[i+1], copydroplongList[i+1] );

    }




    totalDistanceInM = 0;
    finalPrice = 0.0;
    totalpriceList.clear();
    distanceList.clear();
    totalDistanceusingGoogle = 0;



  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    senderToken = prefs.getString("user_token");
    userId = prefs.getString("user_id");

    Map _walletBody = {"user_id": "$userId"};
    _futureWalletBalance = _walletRepository.walletBalance(_walletBody, senderToken);
  }

  navToAttachList(context, Data data) async {
    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => PickupOrderDetailsPage()),
      //         (Route<dynamic> route) => route is HomePage
      //     // ModalRoute.withName("/HomePage")
      // );

      if (onlinePayment && double.parse(data.payableAmount.toString()) > double.parse(data.ewalletAmount??"0.0")) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
          return RazorPayPickDropScreen(
            snapshotData: data,
          );
        }));
      } else {
        if(onlinePayment && double.parse(data.payableAmount.toString()) == double.parse(data.ewalletAmount??"0.0")){
          _eWalletPaymentSuccess(data);
        }
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (BuildContext context) => NewMapTrackingPickDropPage(pickupId: data.id)), ModalRoute.withName('/home'));
      }
    });
  }

  Future<void> _eWalletPaymentSuccess(Data snapshotData) async {

    Map _body = {
      "id":"${snapshotData.id}",
      "transaction_status":"Success" // Failed if not Successful
    };
    _response = await _apiBaseHelper.postWithHeader(
        "pickup/status-update", _body, "Bearer $senderToken");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 55,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.orange[700].withOpacity(0.9),
          /*onPressed: () {
            },*/
          onPressed: () {

            String receiver_name ='';
            String receiver_mobile ='';

            receiver_name = receivernameControllerList[0].text;
            receiver_mobile = receiverphoneControllerList[0].text;

            String _vehicleType = "2W";
            String _paymentMode = "COD";

            if (vehicleType == "Four-Wheeler") _vehicleType = "4W";
            _paymentMode = (payViaWalletAmount == deliveryCharge)
                ? "EWALLET"
                : (paymentType == "Cash Payment")
                    ? "COD"
                    : "ONLINE";

             _body = {
              "expected_delivery_time": "$dateAndTime",
              "payment_method": "$_paymentMode",
              "ewallet_amount": "${payViaWalletAmount != 0.0 ? payViaWalletAmount : ""}",
              "payer": "${paymentUser.toUpperCase()}",
              "item_type": (extraPersonRequired) ? "Extra Person Required" : "",
              "product_name": "$productName",
              "product_remarks": "$productRemarks",
              "weight": "",
              "distance": "$distance",
              "cost_per_km": "15",
              "sender_name": "$sName",
              "sender_mobile": "+91$sPhone",
              "sender_address": "$pickupAddress",
              "sender_pin": "",
              "sender_landmark": "$pickupLandMark",
              "sender_latitude": "$pickUpLat",
              "sender_longitude": "$pickUpLong",
               "receiver_name": "$receiver_name",
              "receiver_mobile": "+91$receiver_mobile",
              "receiver_address": "$destinationAddress",
              "receiver_pin": "",
              "receiver_landmark": "$destinationLandMark",
              "receiver_latitude": "$dropLat",
              "receiver_longitude": "$droplong",
             "vehicle_type": "$_vehicleType",
              "product_amount": "$productPrice",
              "delivery_charge": "$deliveryCharge",
              "payable_amount": "$exactPayableAmount",
              "extra_person_charge": (extraPersonRequired) ? "$deliveryCharge" : "",
              "product_image" : "$baseImage",

            };




            // "product_amount_type": productPaymentRequired?"POSTPAID":"PREPAID",
            // "product_amount_payer": "${productPaymentUser.toUpperCase()}"



            _body['receiver_details'] = {};

            for(int i=0; i<numberOfReceivers; i++)
            {
              String receiver_name ='';
              String receiver_mobile ='';
              String receiver_address ='';
              String receiver_landmark ='';
              double receiver_latitudeD =0.0;
              String receiver_latitude = '';
              String receiver_longitude = '';
              double receiver_longitudeeD =0.0;
              String product_name = '';
              String remarks = '';
              String baseImage = '';


              receiver_name = receivernameControllerList[i].text;
              receiver_mobile = receiverphoneControllerList[i].text;
              receiver_address = receiverdestinationTextControllerList[i].text;
              receiver_landmark = destinationLandmarkList[i];
              receiver_latitudeD = dropLatList[i];
              receiver_longitudeeD = droplongList[i];
              receiver_latitude = receiver_latitudeD.toString();
              receiver_longitude = receiver_longitudeeD.toString();
              product_name = productNameController[i].text;
              remarks = remarksController[i].text;
              baseImage = baseImageList[i];




              _body['receiver_details']['[$i]'] = {

                "receiver_name": "$receiver_name",
                "receiver_mobile" :"$receiver_mobile",
                "receiver_address" : "$receiver_address",
                "receiver_landmark" : "$receiver_landmark",
                "receiver_latitude" : "$receiver_latitude",
                "receiver_longitude" : "$receiver_longitude",
               // "product_name" : "$product_name",
                "remarks" : "$remarks",
                "image" : "$baseImage"


              };




            }

            print(_body);
            print(jsonEncode(_body));
           // print('>>>>>>>>>>${jsonEncode(_body)}');
             _pickupDropBloc.pickupDropRequest(senderToken, _body);


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
                                valueColor:
                                AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                          ),
                        ),
                      ),
                    );
                  });
            });






          },
          label: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Color.fromRGBO(255, 255, 255, 0)),
            width: screenWidth * .80,
            height: 50,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Payable Amount",
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Rs.$payableAmount",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
                Spacer(),
                StreamBuilder<ApiResponse<PickupDropModel>>(
                  stream: _pickupDropBloc.pickupDropStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          // streamCheck = false;
                          /*return CircularProgressIndicator(
                            backgroundColor: circularBGCol,
                            strokeWidth: strokeWidth,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                circularStrokeCol));*/
                          /*Loading(
                            loadingMessage: snapshot.data.message,
                          );*/

                          print('waiting');
                          break;
                        case Status.COMPLETED:
                          // managedSharedPref(snapshot.data.data);

                       // print(snapshot.data.data.message);

                        print('data received');

                        if(snapshot.data.data.message.toString().contains('no driver found') ){

                          print('No driver was found');


                          Fluttertoast.showToast(
                              msg: "No driver was found",
                              fontSize: 16,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);

                          Navigator.pop(context);
                        }

                         else if (snapshot.data.data.success != null) {
                            print("complete piickup Drop");

                            navToAttachList(context, snapshot.data.data.data);

                            pickupAddress = userAddress;
                            destinationAddress = "";
                            pickUpLat = userLat;
                            pickUpLong = userLong;
                            dropLat = 0;
                            droplong = 0;
                            sName = userName;
                            sPhone = userPhone;
                            rName = "";
                            rPhone = "";
                            productName = "";
                            productRemarks = "";
                            productWeight = "";
                            productPrice = "";
                            vehicleType = "Two-Wheeler";
                            vehicleIndex = 0;
                            paymentType = "Cash Payment";
                            productNameVisibility1 = false;
                            extraPersonRequired = false;
                            productPaymentRequired = false;
                            paymentUserIndex = 0;
                            paymentUser = "Sender";
                            productPaymentUser = "Sender";
                            productPaymentUserIndex = 0;
                            dateAndTime = "";
                            dateAndTimeFormated = "";

                            Fluttertoast.showToast(
                                msg: "Pickup Drop Successfully Placed",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
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

                          else {
                            print("Failed piickup Drop");
                            Fluttertoast.showToast(
                                msg: "Pickup Drop Order Failed",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          }
                          break;
                        case Status.ERROR:
                          Navigator.pop(context);
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
                      Navigator.pop(context);
                      print("error");
                    }

                    return Text(
                      "Confirm Pickup >",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: lightThemeBlue,
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.27,
            width: screenWidth,
            child: Stack(
              //overflow: Overflow.visible,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  width: screenWidth,
                  height: screenHeight * 0.27,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng((_originLatitude + _destLatitude) / 2, (_originLongitude + _originLongitude) / 2),
                        zoom: (distance < 4)
                            ? 14
                            : (distance < 10)
                                ? 11
                                : (distance < 20)
                                    ? 10
                                    : (distance < 40)
                                        ? 9
                                        : (distance < 75)
                                            ? 8
                                            : (distance < 140)
                                                ? 7
                                                : (distance < 350)
                                                    ? 6
                                                    : (distance < 825)
                                                        ? 5
                                                        : 4),
                    myLocationEnabled: false,
                    tiltGesturesEnabled: false,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    mapType: MapType.normal,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: _onMapCreated,
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
                ),
                Positioned(
                    top: 1,
                    left: 3,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);




                      },
                      splashColor: darkThemeBlue,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: darkThemeBlue,
                        size: 25,
                      ),
                    )),
                Positioned(
                  right: 0,
                  top: screenHeight * 0.240,
                  child: Container(
                    width: 200,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: darkThemeBlue,
                      boxShadow: [
                        BoxShadow(
                          color: darkThemeBlue,
                          blurRadius: 3.0,
                        ),
                      ],
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(50.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.white70,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Distance",
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "$distance",
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " km",
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(12.0, 3.0, 12.0, 10.0),
              children: [
                //Sender Details...
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 12.0),
                  child: Text("Sender Details",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15.5, color: Colors.white70)),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: darkThemeBlue,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$sName",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "$pickupAddress",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                      Visibility(
                        visible: pickupLandMark.length>1,
                        child: SizedBox(
                          height: 5,
                        ),
                      ),
                      Visibility(
                        visible: pickupLandMark.length>1,
                        child: Text(
                          "Landmark: $pickupLandMark",
                          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "+91 $sPhone",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),

                //Receiver Details...
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 12.0),
                  child: Text("Receiver Details",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15.5, color: Colors.white70)),
                ),

                SizedBox(
                  height: screenHeight*0.2,
                  width: screenWidth*1,
                  child: ListView.builder(

                      itemCount: numberOfReceivers,

                      itemBuilder: (context,n)
                      {
                         String landmark = '';
                         landmark = destinationLandmarkList[n];

                       return Container(
                          width: screenWidth,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: darkThemeBlue,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                 receivernameControllerList[n].text,
                                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  destinationAddressList[n],
                                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                              Visibility(
                                visible: destinationLandMark.length>1,
                                child: SizedBox(
                                  height: 5,
                                ),
                              ),
                              Visibility(
                                visible: destinationLandMark.length>1,
                                child: Text(
                                  "Landmark: $landmark",
                                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                                ),
                              ),

                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "+91 ${receiverphoneControllerList[n].text}",
                                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        );


                      }


                  ),
                ),


                //Product Details...
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 12.0),
                  child: Text("Product Name",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15.5, color: Colors.white70)),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: darkThemeBlue,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/icons/pickup_icons/${(productName == "Grocery") ? "grocery.png" : (productName == "Food") ? "food.png" : (productName == "Cake") ? "cake.png" : (productName == "Documents") ? "documents.png" : (productName == "Medicines") ? "medicines.png" : "others.png"}",
                        height: 28,
                        width: 28,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "    $productName",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                //Vehicle Details...
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 12.0),
                  child: Text("Vehicle Type",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15.5, color: Colors.white70)),
                ),
                Container(
                    width: screenWidth,
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: darkThemeBlue,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    child: (vehicleType == "Two-Wheeler")
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icons/pickup_icons/two_wheeler.png",
                                    height: 30,
                                    width: 30,
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    "    Two-Wheeler",
                                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "100% SAFE DELIVERY",
                                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                  (extraPersonRequired)
                                      ? Icon(
                                          Icons.check_circle,
                                          size: 18,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.clear_outlined,
                                          size: 18,
                                          color: Colors.red,
                                        )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Image.asset(
                                "assets/images/icons/pickup_icons/four_wheeler.png",
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                "    Four-Wheeler",
                                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),

                //Delivery Date and Time Details...
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 12.0),
                  child: Text("Delivery Date and Time",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15.5, color: Colors.white70)),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: darkThemeBlue,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$dateAndTimeFormated",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                // wallet Details
                (paymentUser.toUpperCase() == "SENDER")
                    ? FutureBuilder<wallet.WalletBalanceModel>(
                        future: _futureWalletBalance,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            walletBalance = double.parse(snapshot.data.data.ewalletBalance);
                            if (walletBalance >= 1.0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(" Wallet Details",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.5,
                                        color: Colors.white70,
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
                                    // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
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
                                            color: Colors.white54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Rs. $walletBalance",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: walletCheckedValue,
                                        onChanged: (newValue) {
                                          walletCheckedValue = newValue;
                                          if (newValue) {
                                            if (walletBalance > exactPayableAmount) {
                                              print("only wallet payment");
                                              payableAmount = 0.0;
                                              payViaWalletAmount = exactPayableAmount;
                                            } else {
                                              print("both payment");
                                              payableAmount = double.parse((exactPayableAmount - walletBalance).toStringAsFixed(2));
                                              payViaWalletAmount = walletBalance;
                                            }
                                          } else {
                                            print("only cod or online payment");

                                            payableAmount = exactPayableAmount;
                                            payViaWalletAmount = 0.0;
                                          }
                                          setState(() {});
                                          print("total cart amount: $deliveryCharge");
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
                            } else
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(" Wallet Details",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.5,
                                        color: Colors.white70,
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
                                    // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                                    // height: 50.0,
                                    width: screenWidth,
                                    child: CheckboxListTile(
                                      title: Text(
                                        "Your Wallet Balance",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Rs. $walletBalance",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white54,
                                          fontSize: 14,
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
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text("");
                          } else
                            return ListTileShimmer(
                              padding: EdgeInsets.all(5.0),
                              colors: [Colors.white],
                            );
                        },
                      )
                    : Container(),

                //Payment Details
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 20.0, 0.0, 12.0),
                  child: Text("Payment",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15.5, color: Colors.white70)),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: darkThemeBlue,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RichText(    // To Make Different Text Color in single line
                      //   textAlign: TextAlign.center,
                      //   text: TextSpan(
                      //       text: "Delivery Charge : ",
                      //       style: GoogleFonts.poppins(
                      //           color: Colors.white54,
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w400
                      //       ),
                      //       children: [
                      //         TextSpan(
                      //           text: "Rs. $deliveryCharge",
                      //           style: GoogleFonts.poppins(
                      //               color: Colors.white70,
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w500
                      //           ),
                      //         ),
                      //       ]
                      //   ),
                      // ),
                      //
                      // SizedBox(
                      //   height: 5,
                      // ),
                      (paymentUser == "Receiver")
                          ? Text(
                              "$paymentType by Receiver",
                              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          : Text(
                              "$paymentType by Sender",
                              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Delivery Charge Rs. $deliveryCharge",
                        style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      (productPrice != null && productPrice != "")?
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Product Price Rs. $productPrice",
                          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ):Container(),

                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                ),

                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 25, 0 ,20),
                //   child: ButtonTheme(
                //     /*__To Enlarge Button Size__*/
                //     height: 50.0,
                //     child: RaisedButton(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       onPressed: () {
                //         Navigator.push(context,
                //             MaterialPageRoute(builder: (BuildContext context) {
                //               return PickDropPage04();
                //             }));
                //       },
                //       color: orangeCol,
                //       textColor: Colors.white,
                //       child: Text("Confirm Pickup", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                //       // },
                //       // ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ))
        ],
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {

    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }


  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: orangeCol, points: polylineCoordinates, width: 3);
    polylines[id] = polyline;
    setState(() {});
  }


  _getPolyline(double copydropLatList, double copydroplongList, double copydropLatList1, double copydroplongList1) async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapAPIKey, PointLatLng(copydropLatList, copydroplongList), PointLatLng(copydropLatList1, copydroplongList1),
        travelMode: TravelMode.walking, wayPoints: [PolylineWayPoint(location: "",stopOver: true)]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();

  }

}

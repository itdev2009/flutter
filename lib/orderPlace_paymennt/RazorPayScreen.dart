import 'dart:convert';

import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/orderDetails_screen/oderDetails_page.dart';
import 'package:delivery_on_time/orderPlace_paymennt/model/OrderPlaceResponseModel.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:mydoc/appointmentbooking/BookingSuccessAppointment.dart';
// import 'package:mydoc/bloc/paymentsuccessBloc/payment_bloc.dart';
// import 'package:mydoc/model/bookmodel.dart';
// import 'package:mydoc/pages/index.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class RazorPayScreen extends StatefulWidget {
  final OrderPlaceResponseModel snapshotData;
  final String userToken;
  final String totalCartAmount;

  const RazorPayScreen(
      {Key key, this.snapshotData, this.userToken, this.totalCartAmount})
      : super(key: key);

  @override
  _RazorPayScreenState createState() => _RazorPayScreenState();
}

class _RazorPayScreenState extends State<RazorPayScreen> {
  static const platform = const MethodChannel("razorpay_flutter");

  // String _baseUrl = "http://demo.ewinfotech.com/bookingapp/public/api/";

  Razorpay _razorpay;

  SharedPreferences prefs;

  String userPhone;
  String userEmail;

  ApiBaseHelper _apiBaseHelper = new ApiBaseHelper();
  Map _response;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: darkThemeBlue,
        appBar: AppBar(
            backgroundColor: lightThemeBlue,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            /* title: Center(child: CircleAvatar(
          backgroundImage: AssetImage("assets/logos/foreground.png"),
        )),*/
            title: Center(
              child: Text(
                "DELIVERY ON TIME",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.payment,
                  color: Colors.white,
                ),
              ),
            ]),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Image.asset(
                'assets/images/logos/delivery_icon.png',
                fit: BoxFit.cover,
                height: screenHeight * 0.3,
              ),
              SizedBox(
                height: 60.0,
              ),
              RaisedButton(
                  color: orangeCol,
                  onPressed: openCheckout,
                  child: Text(
                    '  Pay Using RazorPay  ',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ))
            ])),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    createSharedPref();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userPhone = prefs.getString("user_phone");
    userEmail = prefs.getString("email");
    /*setState(() {});*/
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      // 'key': 'rzp_test_BgJqsaZuDQ01OE',
      'key': 'rzp_live_Qlnsflmh2iRcN0',
       'amount': double.parse(widget.snapshotData.data.onlineAmount)*100,
      'name': 'Delivery On Time',
      'description': 'DOT Order Payment',
      // "image":
      //     "https://www.google.com/url?sa=i&url=https%3A%2F%2Ftimesofindia.indiatimes.com%2Flife-style%2Ffood-news%2Fcoronaeffect-restros-food-aggregators-step-up-their-game-to-ensure-safe-delivery-and-pickup-of-food%2Farticleshow%2F75891020.cms&psig=AOvVaw0_DmeL0vcWqQtop0stSsvg&ust=1605856153360000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKDcgr-Gju0CFQAAAAAdAAAAABAI",
      'order_id': widget.snapshotData.data.orderid.toString(),
      'prefill': {
        'contact': '${widget.snapshotData.data.phone}',
        'email': '${widget.snapshotData.data.email}',
        'name': '${widget.snapshotData.data.name}'
      },
      'external': {
        'wallets': ['amazonpay']
        // 'wallets' : ['amazonoay']
      },
      "theme": {"color": "#e36126"}
    };
    print(options);
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Map _body = {
      "orderid": "${widget.snapshotData.data.id}",
      "transid": "${widget.snapshotData.data.transactionId}",
      "status": "Success"
    };
    _response = await _apiBaseHelper.postWithHeader(
        "order/status/update", _body, "Bearer ${widget.userToken}");
    prefs.setString("cart_id", "");
    prefs.setString("coupon_code", "");
    print("cart id at payment success 1 == ${prefs.getString("cart_id")}");

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => OrderDetailsPage()),
    //     ModalRoute.withName("/HomePage"));
    // Navigator.of(context).pushNamedAndRemoveUntil('/orderDetails', ModalRoute.withName('/home'));
    Navigator.of(context).pushNamedAndRemoveUntil('/orderConfirm', ModalRoute.withName('/home'));

    // builder: (context) =>LoginScreen(title: 'MyDoc')));
    //  builder: (context) =>MyApp()));
    // builder: (context) =>IndexPage(channelName: 'AriDoc')));
    ///////////
    prefs.setString("cart_id", "");
    prefs.setString("coupon_code", "");
    print("cart id at payment success 2 == ${prefs.getString("cart_id")}");

    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print(response.message);
    Map _body = {
      "orderid": "${widget.snapshotData.data.id}",
      "transid": "${widget.snapshotData.data.transactionId}",
      "status": "Failed"
    };
    _response = await _apiBaseHelper.postWithHeader(
        "order/status/update", _body, "Bearer ${widget.userToken}");
    prefs.setString("cart_id", "");
    prefs.setString("coupon_code", "");
    print("cart id at payment success 2 == ${prefs.getString("cart_id")}");
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
    print("ERROR: " + response.code.toString() + " - " + response.message);
    prefs.setString("cart_id", "");
    prefs.setString("coupon_code", "");

    print("cart id at payment success 2 == ${prefs.getString("cart_id")}");
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => HomePage()));
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => IndexPage()));
  }
}

// print(widget.snapshotData.data.transactionId.toString()+"here is the Transaction iiiiidddd");
// double price=double.parse(widget.totalCartAmount);
// print("$price+ amount in double ");
// // print(int.parse(widget.totalCartAmount));
// price=price*100;
// print("$price+ amount in double *100 ");
// int price1=price.toInt();
// print("$price1+ amount in double price1 ");

import 'dart:convert';

import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropConfirmPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class RazorPayPickDropScreen extends StatefulWidget {
  final Data snapshotData;

  const RazorPayPickDropScreen(
      {Key key, this.snapshotData})
      : super(key: key);

  @override
  _RazorPayScreenState createState() => _RazorPayScreenState();
}

class _RazorPayScreenState extends State<RazorPayPickDropScreen> {
  static const platform = const MethodChannel("razorpay_flutter");

  // String _baseUrl = "http://demo.ewinfotech.com/bookingapp/public/api/";

  Razorpay _razorpay;

  SharedPreferences prefs;

  String userName;
  String userPhone;
  String userEmail;
  String userToken;

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

  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();

    userPhone = prefs.getString("user_phone");
    userEmail = prefs.getString("email");
    userName = prefs.getString("name");
    userToken = prefs.getString("user_token");
    openCheckout();
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
      //  'amount': 100,
      'name': 'Delivery On Time',
      'description': 'DOT Pickup Payment',
      'order_id': widget.snapshotData.orderId,
      'prefill': {
        'contact': '$userPhone',
        'email': '$userEmail',
        'name': '$userName'
      },
      'external': {
        'wallets': ['amazonpay']
      },
      "theme": {"color": "#e36126"}
    };
    print(options);
    try {
      _razorpay.open(options);    } catch (e) {

      debugPrint(e);
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Map _body = {
      "id":"${widget.snapshotData.id}",
      "transaction_status":"Success" // Failed if not Successful
    };
    _response = await _apiBaseHelper.postWithHeader(
        "pickup/status-update", _body, "Bearer $userToken");

    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => OrderDetailsPage()),
    //     ModalRoute.withName("/HomePage"));
    // Navigator.of(context).pushNamedAndRemoveUntil('/orderDetails', ModalRoute.withName('/home'));
    // Navigator.of(context).pushNamedAndRemoveUntil('/walletAddConfirm', ModalRoute.withName('/home'));
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => PickDropConfirmPage()),
        ModalRoute.withName('/home')
    );
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print(response.message);
    Map _body = {
      "id":"${widget.snapshotData.id}",
      "transaction_status":"Failed" // Failed if not Successful
    };

    _response = await _apiBaseHelper.postWithHeader(
        "pickup/status-update", _body, "Bearer $userToken");

    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIosWeb: 4);
    print("ERROR: " + response.code.toString() + " - " + response.message);

    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => IndexPage()));
  }
}


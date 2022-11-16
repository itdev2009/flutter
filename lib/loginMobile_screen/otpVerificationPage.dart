import 'dart:async';

import 'package:delivery_on_time/cart_screen/cartPage.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/registration_otp_screens/registrationPage.dart';
import 'package:delivery_on_time/screens/homeStartingPage.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_count_down/otp_count_down.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:delivery_on_time/loginMobile_screen/bloc/loginByMobileBloc.dart';
import 'package:delivery_on_time/loginMobile_screen/model/loginByMobileModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String cartId;
  final String redirectPage;


  OtpVerificationPage({this.phoneNumber, this.cartId="", this.redirectPage=""});

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<OtpVerificationPage>{
  var onTapRecognizer;
  String referral_code;
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  String _countDown="00:30";
  OTPCountDown _otpCountDown; // create instance
  final int _otpTimeInMS = 1000 * 1 * 30;  // time in milliseconds for count down

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String codeVerificationId;
  int codeResendToken;
  FirebaseAuth _auth;

  SharedPreferences prefs;
  String DeviceID="";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';
  // bool otpSentCheck = false;
  bool loginCheck=false;

  LoginByMobileBloc _loginByMobileBloc=new LoginByMobileBloc();
  _PinCodeVerificationScreenState();

  void _startCountDown() {
    _otpCountDown = OTPCountDown.startOTPTimer(
      timeInMS: _otpTimeInMS,
      currentCountDown: (String countDown) {
        _countDown = countDown;
        setState(() {});
      },
      onFinish: () {
        print("Count down finished!");
      },
    );
  }

  _register() async {
    //_firebaseMessaging.getToken().then((token) => print(token));
    var tokenFirebase="";
    _firebaseMessaging.getToken().then((token) async {
      tokenFirebase=token;
      print(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("device_id",tokenFirebase);
      DeviceID=tokenFirebase;
      print("sf");
      String device_id = prefs.getString("device_id");
      print(device_id);
    });
  }

  void getMessage(){
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          setState(() => _message = message["notification"]["title"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();

    referral_code=prefs.getString("referral_code");
    print("6>>>$referral_code");
    /*Fluttertoast.showToast(
        msg: "referral code!$referral_code",
        fontSize: 16,
        backgroundColor: Colors.orange[100],
        textColor: darkThemeBlue,
        toastLength: Toast.LENGTH_LONG);*/
    // DeviceID="";
  }

  Future<void> managedSharedPref(LoginByMobileModel data) async {

    print('manage shared prefs called in otp page');


    prefs.setString("user_address", "${data.data.address}");
    prefs.setString("user_latitude", "${data.data.latitude}");
    prefs.setString("user_longitude", "${data.data.longitude}");

    prefs.setString("coupon_code", "");
    prefs.setString("cart_id", "${data.cartId??""}");
    prefs.setString("user_id", "${data.data.id}");
    prefs.setString("name", "${data.data.name??""}");
    prefs.setString("user_photo", "${data.data.profilePic}");
    // userName=data.data.name;
    print("${data.data.name??""}");
    prefs.setBool("user_login", true);
    prefs.setString("email", "${data.data.email??""}");
    prefs.setString("user_token", "${data.success.token}");
    prefs.setString("user_phone", "${data.data.mobileNumber}");
    prefs.setString("user_wallet_id", "${data.ewalletId}");
    prefs.setDouble("shopLat", double.parse(data.cartVendorDetails.latitude));
    prefs.setDouble("shopLong", double.parse(data.cartVendorDetails.longitude));
    


    prefs.setString("vendor_id", "${data.cartVendorDetails.id??""}");
    prefs.setString("parent_category_id", "${data.cartVendorDetails.categoryId??""}");

    if(data.userAddress.longitude!=null && data.userAddress.latitude!=null){
      prefs.setString("userAddressLat",data.userAddress.latitude);
      prefs.setString("userAddressLong",data.userAddress.longitude);
      prefs.setString("userAddress",data.userAddress.address);
      prefs.setString("userAddressName",data.userAddress.addressName);
      prefs.setString("userAddressId",data.userAddress.id.toString());
    }


    userName = prefs.getString("name");
    try{
      userPhone = prefs.getString("user_phone").substring(3);
    }catch(ex){
      print(ex);
    }
    userLogin=true;
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      print("2");
      Navigator.pop(context);
      if(widget.redirectPage=="pickDrop"){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeController(currentIndex: 4,)));
      }else if(widget.redirectPage=="bikeRide"){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeController(currentIndex: 0,)));
      }else if(widget.redirectPage=="cartPage"){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CartPageNew()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
          return HomeStartingPage();
        }));
      }

    });
  }

  @override
  void initState() {
    _firebaseMessaging.requestNotificationPermissions();
    _register();
    getMessage();
    createSharedPref();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _startCountDown();
        otpVerify(context,token: codeResendToken);
      };
    _auth = FirebaseAuth.instance;
    _startCountDown();
    otpVerify(context);
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    setState(() {

    });
  }

  @override
  void dispose() {
    errorController.close();
    _otpCountDown.cancelTimer();
    super.dispose();
  }


  void _login() {
    print("login push");
    loginCheck=true;
    print(loginCheck);
    showAlertDialog(context);
    Map body = {
      "mobile_number":"+91${widget.phoneNumber.trim()}",
      "deviceid" : "$DeviceID",
      "cartid":"${widget.cartId}",
      "referral_code" : "${prefs.getString("referral_code")}",
    };
    Future.delayed(Duration(seconds: 1), () {
      print("-1");
      print(body);
      _loginByMobileBloc.loginByMobile(body);
      setState(() {

      });
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text("Loading"),
            )
          ],
        ));

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  otpVerification() async{
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: codeVerificationId, smsCode: currentText);
      User user = (await _auth.signInWithCredential(credential)).user;

      if (user != null) {
        print("successfully verify manually");
        _login();
      } else {
        print("Error");
        Fluttertoast.showToast(
            msg: "Please Try Again!",
            fontSize: 16,
            backgroundColor: Colors.orange[100],
            textColor: darkThemeBlue,
            toastLength: Toast.LENGTH_LONG);
      }
    } catch (PlatformException) {
      print("keno dibi ex $PlatformException");
      if(PlatformException.toString().contains("The sms code has expired")){
        Fluttertoast.showToast(
            msg: "OTP code has been expired",
            fontSize: 16,
            backgroundColor: Colors.orange[100],
            textColor: darkThemeBlue,
            toastLength: Toast.LENGTH_LONG);
      }else if(PlatformException.toString().contains("The sms verification code used to create the phone auth credential is invalid")){
        errorController.add(ErrorAnimationType
            .shake); // Triggering error shake animation
        setState(() {
          hasError = true;
        });
        Fluttertoast.showToast(
            msg: "Please Enter Correct OTP",
            fontSize: 16,
            backgroundColor: Colors.orange[100],
            textColor: darkThemeBlue,
            toastLength: Toast.LENGTH_LONG);
      }else{
        Fluttertoast.showToast(
            msg: "Please try again!",
            fontSize: 16,
            backgroundColor: Colors.orange[100],
            textColor: darkThemeBlue,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  Future<void> otpVerify(BuildContext context,{int token}) async {
    // print("dhuke ge6e");
    print("OTP Sent");
    print("here 1st codeResend token : $token");

    _auth.verifyPhoneNumber(
      forceResendingToken: token,
        phoneNumber: "+91${widget.phoneNumber}",
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {
          User user = (await _auth.signInWithCredential(credential)).user;
          if (user != null) {
            print("login success via firebase otp auto");
            _login();
            Fluttertoast.showToast(
                msg: "OTP successfully verified",
                fontSize: 16,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print("error di6666eee $exception");
          print("error di66e otp te");
          if(exception.message.contains("interrupted connection or unreachable host")){
            Fluttertoast.showToast(
                msg: "Oops! Please Check Your Internet Connectivity.",
                fontSize: 16,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);
          }else if(exception.message.contains("The format of the phone number provided is incorrect")){
            Fluttertoast.showToast(
                msg: "Please Enter a Correct and New Phone Number.",
                fontSize: 16,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);
          }else{
            Fluttertoast.showToast(
                msg: "Please Try Again With a New Phone Number",
                fontSize: 16,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);
          }

        },
        codeSent: (String verificationId, int forceResendingToken) async {
          // otpSentCheck = false;
          final code = currentText.trim();
          codeVerificationId = verificationId;
          codeResendToken=forceResendingToken;
          print("here is codeResend token : $codeResendToken");
          /*try {
            AuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: code);
            User user = (await _auth.signInWithCredential(credential)).user;

            if (user != null) {
              print("successfully verify manually");
              if (cartId == null) {
                cartId = "";
              }
            } else {
              print("Error");
            }
          } catch (PlatformException) {
            print("keno dibi ex $PlatformException");
          }*/
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        key: scaffoldKey,
        body: GestureDetector(
          onTap: () {},
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                ListView(
                  children: <Widget>[
                    SizedBox(height: screenHeight*0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: screenWidth*0.05),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios,color: Colors.white70,size: screenWidth*0.048,),
                              Text("Back",style: TextStyle(color: Colors.white70,fontSize: screenWidth*0.04,fontWeight: FontWeight.w400),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.03),

                    Container(
                      height: MediaQuery.of(context).size.height *0.2,
                      child: Image.asset(
                        "assets/images/icons/smartphone_orange.png",height: MediaQuery.of(context).size.height *0.2,
                      )/*FlareActor(
                        "assets/OTP.flr",
                        animation: "otp",
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.center,
                      ),*/
                    ),
                    SizedBox(height: screenHeight*0.06),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Phone Number Verification',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth*0.065, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                      child: RichText(
                        text: TextSpan(
                            text: "Enter the code sent to : ",
                            children: [
                              TextSpan(
                                  text: widget.phoneNumber,
                                  style: TextStyle(
                                    letterSpacing: 1,
                                      color: Colors.deepOrange[400],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                            ],
                            style: TextStyle(color: Colors.white, fontSize: 15)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          child: PinCodeTextField(
                            errorTextSpace: 0,
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: false,
                            obscuringCharacter: '*',
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v.length < 3) {
                                return "";
                                // return "Please Enter All Fields";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.underline,
                              // borderRadius: BorderRadius.circular(5),
                              fieldHeight: screenWidth*0.12,
                              fieldWidth: screenWidth*0.11,
                              activeFillColor: lightThemeBlue,
                              activeColor: hasError ? Colors.red : Colors.amber,
                              selectedFillColor: darkThemeBlue,
                              inactiveFillColor: darkThemeBlue,
                              inactiveColor: Colors.orange[200],
                              selectedColor: Colors.white70,
                            ),
                            cursorColor: Colors.white70,
                            animationDuration: Duration(milliseconds: 300),
                            textStyle: TextStyle(fontSize: screenWidth*0.05, height: 1.6,color: Colors.white),
                            backgroundColor: darkThemeBlue,
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: textEditingController,
                            keyboardType: TextInputType.number,
                            boxShadows: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                              print("Completed");
                            },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                hasError=false;
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? "*Please Enter Correct OTP" : "",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (_countDown=="00:00")?
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Didn't receive the code? ",
                          style: TextStyle(color: Colors.white70, fontSize: screenWidth*0.037),
                          children: [
                            TextSpan(
                                text: " RESEND",
                                recognizer: onTapRecognizer,
                                style: TextStyle(
                                    color: orangeCol,
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth*0.037))
                          ]),
                    )
                        :
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "OTP Auto Verified In ",
                          style: TextStyle(color: Colors.white70, fontSize: screenWidth*0.037),
                          children: [
                            TextSpan(
                                text: "$_countDown",
                                style: TextStyle(
                                    color: orangeCol,
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth*0.037))
                          ]),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    InkWell(
                      onTap: (){
                        formKey.currentState.validate();
                        // conditions for validating
                        if (currentText.length != 6) {
                          errorController.add(ErrorAnimationType
                              .shake); // Triggering error shake animation
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          setState(() {
                            hasError = false;
                            otpVerification();
                            // scaffoldKey.currentState.showSnackBar(SnackBar(
                            //   content: Text("Aye!!"),
                            //   duration: Duration(seconds: 2),
                            // ));
                          });
                        }
                      },
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
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
                          'VERIFY',
                          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                (loginCheck)?
                StreamBuilder<ApiResponse<LoginByMobileModel>>(
                  stream: _loginByMobileBloc.loginByMobileStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("0");
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          print("loading");
                          break;
                        case Status.COMPLETED:
                          print("1");
                          loginCheck=false;
                          if (snapshot.data.data.success != null)
                          {
                            print("complete");
                            managedSharedPref(snapshot.data.data);
                            navToAttachList(context);
                            Fluttertoast.showToast(
                                msg: "Welcome ${snapshot.data.data.data.name??""}",
                                fontSize: 16,
                                backgroundColor: Colors.white,
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          }
                          else if(snapshot.data.data.message.contains("This mobile number already registered as Seller")){
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "${snapshot.data.data.message}",
                                    fontSize: 16,
                                    backgroundColor: Colors.orange[100],
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);
                              }
                          else{
                            loginCheck=false;
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: "Please try again!",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          }
                          break;
                        case Status.ERROR:
                          loginCheck=false;
                          print("error01");
                          print(snapshot.error);
                          Navigator.pop(context);
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
                      loginCheck=false;
                      Navigator.pop(context);
                      print("error02");
                      print(snapshot.error);
                      Fluttertoast.showToast(
                          msg: "Oops! Please Try Again!",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }

                    return Container();
                  },
                )
                    :
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

// class OtpPage extends StatefulWidget {
//   @override
//   _OtpPageState createState() => _OtpPageState();
// }
//
// class _OtpPageState extends State<OtpPage> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: darkThemeBlue,
//         body: ListView(
//           shrinkWrap: true,
//           children: [
//             // Delivery Logo.....
//
//             Container(
//               height: screenHeight * 0.23,
//               margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
//               child: Image.asset("assets/images/logos/delivery_icon.png"),
//             ),
//
//             // Heading Text.....
//
//             Text(
//               "DELIVERY ON TIME",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: textCol,
//                   fontSize: screenWidth * 0.05,
//                   fontWeight: font_bold),
//             ),
//
//             // Welcome Text.....
//
//             /*Padding(
//               padding: const EdgeInsets.fromLTRB(0, 60, 0, 10),
//               child: Text(
//                 "Welcome",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: screenWidth * 0.08,
//                   fontWeight: font_bold,
//                 ),
//               ),
//             ),*/
//
//             // Sign in or up Text.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//               child: Text(
//                 "Please Enter Your OTP Below!!!",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: screenWidth * 0.04,
//                   fontWeight: font_bold,
//                 ),
//               ),
//             ),
//
//             // Email Text Field.....
//
//             Container(
//               height: 165.0,
//               alignment: Alignment.topCenter,
//               margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: TextField(
//                       controller: _phoneNumberController,
//                       keyboardType: TextInputType.number,
//                       maxLength: 10,
//                       style: TextStyle(fontSize: 14.0),
//                       // textAlignVertical: TextAlignVertical.top,
//                       decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.phone),
//                           hintText: "Enter Your Phone number",
//                           hintStyle: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14.0,
//                           ),
//                           border: InputBorder.none),
//                     ),
//                   ),
//
//                   //Sign In Button.....
//
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
//                     child: ButtonTheme(
//                       /*__To Enlarge Button Size__*/
//                       height: 50.0,
//                       minWidth: screenWidth,
//                       child: RaisedButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         onPressed: () {
//                           Map body;
//                           if (_phoneNumberController.text == "") {
//                             Fluttertoast.showToast(
//                                 msg: "Please Enter Your Number",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                           } else if (_phoneNumberController.text.length != 10) {
//                             Fluttertoast.showToast(
//                                 msg: "Please Enter 10 Digit Valid Number",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                           } else if (_phoneNumberController.text.length == 10) {
//                             otpSentCheck = true;
//                             otpVerify(context);
//                             setState(() {
//                               print("arriibbaasssssss");
//                               // otpSentCheck = true;
//                             });
//                           }
//                         },
//                         color: orangeCol,
//                         textColor: Colors.white,
//                         child: (!otpSentCheck)
//                             ? Text("Get OTP",
//                             style: TextStyle(
//                                 fontSize: 17, fontWeight: FontWeight.bold))
//                             : CircularProgressIndicator(
//                             backgroundColor: circularBGCol,
//                             strokeWidth: strokeWidth,
//                             valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

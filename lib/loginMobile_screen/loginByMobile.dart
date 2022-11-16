import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/loginMobile_screen/otpVerificationPage.dart';
import 'package:delivery_on_time/screens/homeStartingPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ClipPainter extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height );
    path.lineTo(size.width , height);
    path.lineTo(size.width , 0);

    /// [Top Left corner]
    var secondControlPoint =  Offset(0  ,0);
    var secondEndPoint = Offset(width * .2  , height *.3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



    /// [Left Middle]
    var fifthControlPoint =  Offset(width * .3  ,height * .5);
    var fiftEndPoint = Offset(  width * .23, height *.6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);


    /// [Bottom Left corner]
    var thirdControlPoint =  Offset(0  ,height);
    var thirdEndPoint = Offset(width , height  );
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);



    path.lineTo(0, size.height  );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: -pi / 3.5,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffe4944f),Color(0xffe36126)]
                  )
              ),
            ),
          ),
        )
    );
  }
}

class LoginByMobilePage extends StatefulWidget {
  final String cartId;
  const LoginByMobilePage({Key key, this.cartId=""}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(cartId);
}

class _LoginPageState extends State<LoginByMobilePage> {
  SharedPreferences prefs;
  final String cartId;
  _LoginPageState(this.cartId);

  TextEditingController _phoneNumberController=new TextEditingController();
  RegExp regExp = new RegExp(r"^[0-9]{10}$");
  ConnectivityResult connectivityResult;
  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          /*if (deepLink != null) {
            handleSuccessLinkData(dynamicLink);
          }*/
          if(deepLink!=null){
            var isRefer=deepLink.pathSegments.contains("refer");
            if(isRefer){
              var code = deepLink.queryParameters["referralCode"];
              if(code!=null){
                print(">>>>$code");
                //var referral_code=code;
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString("referral_code","$code");
                  print("2>>>${prefs.getString("referral_code")}");
                });

              }
            }
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    }
    );
  }
  Future<void> handleSuccessLinkData(PendingDynamicLinkData dynamicLinkData) async {
    final Uri deepLink = dynamicLinkData.link;
    print(">>>>>>>>>>>$deepLink");
    if(deepLink!=null){
      var isRefer=deepLink.pathSegments.contains("refer");
      if(isRefer){
        var code = deepLink.queryParameters["referralCode"];
        if(code!=null){
          print(">>>>$code");
          //var referral_code=code;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("referral_code","${deepLink.queryParameters["referralCode"]}");
          print("2>>>${prefs.getString("referral_code")}");
        }
      }
    }
  }
  Future<String> generateLink(String reffer_code) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://apps.deliveryontime.me',
        link: Uri.parse(
            'https://apps.deliveryontime.me/refer?referralCode=$reffer_code'),
        androidParameters: AndroidParameters(
          packageName: 'com.inceptory.delivery_on_time',
          minimumVersion: 0,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "Refer A Friend",
            description: "Refer And Earn",
            imageUrl: Uri.parse("https://www.istockphoto.com/vector/people-making-money-from-referral-refer-a-friend-or-referral-marketing-concept-gm1224324620-359947285")
        )
    );
    final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
    await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    final Uri shortUrl = shortenedLink.shortUrl;
    String link = "${shortUrl.toString()}";
    print("ShortLink${shortUrl.toString()}", );
    /*await Share.share("Refer a friend $link",
      subject: "Refer And Earn",
    );
*/
    return "https://apps.deliveryontime.me" + shortUrl.path;
  }
  @override
  void initState() {
    super.initState();
    //createSharedPref();
    initDynamicLinks();
    setState(() {

    });

  }

  connectivityCheck() async{
    connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          msg: "Oops! Please Check Your Internet Connectivity.",
          fontSize: 14,
          backgroundColor: Colors.orange[100],
          textColor: darkThemeBlue,
          toastLength: Toast.LENGTH_LONG);
    } else {
      //generateLink("11111");
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return OtpVerificationPage(cartId: cartId,
                phoneNumber: _phoneNumberController.text.trim());

          }));
    }
  }



  Widget _entryField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 45.0,
            alignment: Alignment.topCenter,
            // margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(10),
              ],
              // maxLength: 10,
              // maxLengthEnforced: true,
              style: TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: "Enter Your Phone number",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  border: InputBorder.none),
            ),
          ),

        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: (){
        if(regExp.hasMatch(_phoneNumberController.text.trim())){
          print("matched");
          connectivityCheck();
          // if (connectivityResult == ConnectivityResult.none) {
          //   Fluttertoast.showToast(
          //       msg: "Oops! Please Check Your Internet Connectivity.",
          //       fontSize: 14,
          //       backgroundColor: Colors.white70,
          //       textColor: darkThemeBlue,
          //       toastLength: Toast.LENGTH_LONG);
          // } else {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (BuildContext context) {
          //         return OtpVerificationPage(cartId: cartId,
          //             phoneNumber: _phoneNumberController.text.trim());
          //
          //       }));
          // }

        }else{
          print("hobe naa");
          Fluttertoast.showToast(
              msg: "Please Enter a Proper Number",
              fontSize: 16,
              backgroundColor: Colors.orange[100],
              textColor: darkThemeBlue,
              toastLength: Toast.LENGTH_LONG);
        }

      },
      child: Container(
        height: 50.0,
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
          'Sign In',
          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          Text('or',
            style: TextStyle(color: Colors.white),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget _title() {
    return Column(
      children: [
        Container(
          height: screenHeight * 0.17,
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Image.asset("assets/images/logos/delivery_icon.png"),
        ),
        // Heading Text.....

        Text(
          "DELIVERY ON TIME",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textCol,
              fontSize: screenWidth * 0.035,
              fontWeight: font_bold),
        ),

        // Welcome Text.....

        Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
          child: Text(
            "Welcome",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: font_bold,
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    screenHeight= MediaQuery.of(context).size.height;
    screenWidth= MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          backgroundColor: darkThemeBlue,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: height*0.56,
                  child: Stack(
                    alignment: Alignment.center,
                    // overflow: Overflow.visible,
                    children: <Widget>[
                      // Positioned(
                      //     top: -height * .15,
                      //     right: -MediaQuery.of(context).size.width * .4,
                      //     child: BezierContainer()),
                      Container(
                        width: screenWidth,
                        margin: EdgeInsets.only(top: height*0.2),
                        child: Center(child: _title()),
                      )
                      // Positioned(top: 40, left: 0, child: _backButton()),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.0,0.0,20.0,20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      _entryField("Mobile Number"),
                      SizedBox(height: 10),
                      _submitButton(),
                      /*
                      _divider(),
                      SizedBox(height: 00),
                      InkWell(
                        onTap: (){

                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return HomeStartingPage();
                              }));

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                          child:  Text(
                            "Skip Sign In for now >>>",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: textCol,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),


                       */
                    ],
                  ),
                ),

              ],
            ),
          )),
    );
  }
}









// import 'package:delivery_on_time/constants.dart';
// import 'package:delivery_on_time/forgetPassword_screen/forgetPasswordOtpPage.dart';
// import 'package:delivery_on_time/help/api_response.dart';
// import 'package:delivery_on_time/loginMobile_screen/bloc/loginByMobileBloc.dart';
// import 'package:delivery_on_time/loginMobile_screen/model/loginByMobileModel.dart';
// import 'package:delivery_on_time/login_screen/bloc/profileUpdateBloc.dart';
// import 'package:delivery_on_time/login_screen/bloc/loginByMailBloc.dart';
// import 'package:delivery_on_time/login_screen/model/loginByMailModel.dart';
// import 'package:delivery_on_time/login_screen/model/loginModel.dart';
// import 'package:delivery_on_time/registration_otp_screens/mobileNumberPage.dart';
// import 'package:delivery_on_time/screens/home.dart';
// import 'package:delivery_on_time/screens/homeStartingPage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as JSON;
//
// import '../customAlertDialog.dart';
//
// class LoginByMobile extends StatefulWidget {
//
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<LoginByMobile> {
//
//   SharedPreferences prefs;
//   String DeviceID="";
//   final gooleSignIn = GoogleSignIn();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final facebookLogin = FacebookLogin();
//
//
//
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   String _message = '';
//   bool otpSentCheck = false;
//
//   TextEditingController _phoneNumberController = new TextEditingController();
//   TextEditingController _codeController = new TextEditingController();
//
//
//   LoginByMobileBloc _loginByMobileBloc=new LoginByMobileBloc();
//   LoginByMailBloc _loginByMailBloc=new LoginByMailBloc();
//
//
//   _register() async {
//     //_firebaseMessaging.getToken().then((token) => print(token));
//     var tokenFirebase="";
//     _firebaseMessaging.getToken().then((token) async {
//       tokenFirebase=token;
//       print(token);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("device_id",tokenFirebase);
//       DeviceID=tokenFirebase;
//       print("sf");
//       String device_id = prefs.getString("device_id");
//       print(device_id);
//     });
//   }
//
//   void getMessage(){
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print('on message $message');
//           setState(() => _message = message["notification"]["title"]);
//         }, onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }
//
//
//   Future<void> createSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     // DeviceID=prefs.getString("device_id");
//     // DeviceID="";
//   }
//   Future<void> managedSharedPref(LoginByMobileModel data) async {
//
//     prefs.setString("coupon_code", "");
//     prefs.setString("cart_id", "${data.cartId}");
//     prefs.setString("user_id", "${data.data.id}");
//     prefs.setString("name", "${data.data.name}");
//     // userName=data.data.name;
//     print("${data.data.name}");
//     prefs.setBool("user_login", true);
//     prefs.setString("email", "${data.data.email}");
//     prefs.setString("user_token", "${data.success.token}");
//     prefs.setString("user_phone", "${data.data.mobileNumber}");
//     prefs.setString("user_wallet_id", "${data.ewalletId}");
//     userLogin=true;
//   }
//   Future<void> managedSharedPrefLoginByMail(LoginByMailModel data) async {
//
//     prefs.setString("coupon_code", "");
//     prefs.setString("cart_id", "");
//     prefs.setString("user_id", "${data.data.data.id}");
//     prefs.setString("name", "${data.data.data.name}");
//     // userName=data.data.name;
//     print("${data.data.data.name}");
//     print("${data.data.data.email}");
//     prefs.setBool("user_login", true);
//     prefs.setString("email", "${data.data.data.email}");
//     prefs.setString("user_token", "${data.data.token}");
//     prefs.setString("user_phone", "${(data.data.data.mobileNumber)??""}");
//     userLogin=true;
//   }
//   navToAttachList(context) async {
//     Future.delayed(Duration.zero, () {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
//         return HomePage();
//       }));
//     });
//   }
//
//   Future<void> otpVerify(BuildContext context) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;
//     print("dhuke ge6e");
//
//     _auth.verifyPhoneNumber(
//         phoneNumber: "+91${_phoneNumberController.text.trim()}",
//         timeout: Duration(seconds: 120),
//         verificationCompleted: (AuthCredential credential) async {
//           User user = (await _auth.signInWithCredential(credential)).user;
//           if (user != null) {
//             print("login success via firebase otp auto");
//             _login();
//             Fluttertoast.showToast(
//                 msg: "OTP successfully verified",
//                 fontSize: 16,
//                 backgroundColor: Colors.orange[100],
//                 textColor: darkThemeBlue,
//                 toastLength: Toast.LENGTH_LONG);
//             // Navigator.pushReplacement(context,
//             //     MaterialPageRoute(builder: (BuildContext context) {
//             //       return RegistrationPage(
//             //         phoneNumber: _phoneNumberController.text,
//             //       );
//             //     }));
//           }
//         },
//         verificationFailed: (FirebaseAuthException exception) {
//           print("error di6666eee $exception");
//           print("error di66e otp te");
//           Fluttertoast.showToast(
//               msg: "Please Enter a Correct and New Phone Number",
//               fontSize: 16,
//               backgroundColor: Colors.orange[100],
//               textColor: darkThemeBlue,
//               toastLength: Toast.LENGTH_LONG);
//         },
//         codeSent: (String verificationId, [int forceResendingToken]) {
//           otpSentCheck = false;
//           showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) {
//                 return AlertDialog(
//                   // title: Text("Give the code?"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Image.asset(
//                         "assets/images/logos/orange_tick.png",
//                         height: 60.0,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Text(
//                           "Code Sent Successfully",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       )
//                     ],
//                   ),
//                   actions: [
//                     new FlatButton(
//                         child: const Text("Enter OTP Manually",
//                           style: TextStyle(
//                               color: Colors.blueGrey,
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold),),
//                         onPressed: (){
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   title: Text("Give the code?"),
//                                   content: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       TextField(
//                                         keyboardType: TextInputType.number,
//                                         maxLength: 6,
//                                         controller: _codeController,
//                                         decoration: InputDecoration(
//                                             prefixIcon: Icon(Icons.code),
//                                             hintText: "Unique Code",
//                                             hintStyle: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 14.0,
//                                             ),
//                                             border: InputBorder.none),
//                                       ),
//                                     ],
//                                   ),
//                                   actions: <Widget>[
//                                     FlatButton(
//                                       child: Text("Confirm"),
//                                       textColor: Colors.white,
//                                       color: orangeCol,
//                                       onPressed: () async {
//                                         final code = _codeController.text.trim();
//                                         if (_codeController.text.length == 6) {
//                                           try {
//                                             AuthCredential credential =
//                                             PhoneAuthProvider.credential(
//                                                 verificationId: verificationId,
//                                                 smsCode: code);
//                                             User user = (await _auth.signInWithCredential(credential)).user;
//
//                                             if (user != null) {
//                                               _login();
//
//                                               print("successfully verify manually");
//                                               Fluttertoast.showToast(
//                                                   msg: "OTP successfully verified",
//                                                   fontSize: 16,
//                                                   backgroundColor: Colors.orange[100],
//                                                   textColor: darkThemeBlue,
//                                                   toastLength: Toast.LENGTH_LONG);
//                                             } else {
//                                               print("Error");
//                                             }
//                                           } catch (PlatformException) {
//                                             print("keno dibi ex $PlatformException");
//                                             Fluttertoast.showToast(
//                                                 msg: "Please Enter Correct OTP",
//                                                 fontSize: 16,
//                                                 backgroundColor: Colors.orange[100],
//                                                 textColor: darkThemeBlue,
//                                                 toastLength: Toast.LENGTH_LONG);
//                                           }
//                                         } else if (_codeController.text.length < 6) {
//                                           Fluttertoast.showToast(
//                                               msg: "Please Enter 6 Digit OTP",
//                                               fontSize: 16,
//                                               backgroundColor: Colors.orange[100],
//                                               textColor: darkThemeBlue,
//                                               toastLength: Toast.LENGTH_LONG);
//                                         }
//                                       },
//                                     )
//                                   ],
//                                 );
//                               });
//                         }
//                     ),
//                   ],
//                 );
//               });
//
//         },
//         codeAutoRetrievalTimeout: (String verificationId)
//         {
//           verificationId = verificationId;
//           print(verificationId);
//           print("Timout");
//         });
//   }
//
//   void _login() {
//     print("login push");
//     showAlertDialog(context);
//     Map body = {
//       "mobile_number":"+91${_phoneNumberController.text.trim()}",
//       "deviceid" : "$DeviceID",
//       "cartid":""
//     };
//     Future.delayed(Duration(seconds: 1), () {
//     _loginByMobileBloc.loginByMobile(body);
//     });
//   }
//
//   showAlertDialog(BuildContext context) {
//     AlertDialog alert = AlertDialog(
//         content: Row(
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 20),
//               child: Text("Loading"),
//             )
//           ],
//         ));
//
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _register();
//     getMessage();
//     createSharedPref();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     screenHeight= MediaQuery.of(context).size.height;
//     screenWidth= MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: darkThemeBlue,
//         body: ListView(
//           shrinkWrap: true,
//           physics: ScrollPhysics(),
//           children: [
//
//
//             // details fetch StreamBuilder
//
//             StreamBuilder<ApiResponse<LoginByMobileModel>>(
//               stream: _loginByMobileBloc.loginByMobileStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   switch (snapshot.data.status) {
//                     case Status.LOADING:
//                       print("loading");
//                       break;
//                     case Status.COMPLETED:
//                       if (snapshot.data.data.success != null)
//                       {
//                         print("complete");
//                         managedSharedPref(snapshot.data.data);
//                         navToAttachList(context);
//                         Fluttertoast.showToast(
//                             msg: "Welcome ${snapshot.data.data.data.name}",
//                             fontSize: 16,
//                             backgroundColor: Colors.white,
//                             textColor: darkThemeBlue,
//                             toastLength: Toast.LENGTH_LONG);
//                       }
//                       break;
//                     case Status.ERROR:
//                       Fluttertoast.showToast(
//                           msg: "Please Enter Correct Email ID and Password",
//                           fontSize: 16,
//                           backgroundColor: Colors.orange[100],
//                           textColor: darkThemeBlue,
//                           toastLength: Toast.LENGTH_LONG);
//                       //   Error(
//                       //   errorMessage: snapshot.data.message,
//                       // );
//                       break;
//                   }
//                 } else if (snapshot.hasError) {
//                   print("error");
//                 }
//
//                 return Container();
//               },
//             ),
//
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
//             Padding(
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
//             ),
//
//
//             // Sign in or up Text.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//               child: Text(
//                 "Please Enter Your Phone Number to continue",
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
//                   //Get Otp Button.....
//
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
//                     child: ButtonTheme(
//                       /*__To Enlarge Button Size__*/
//                       height: 50.0,
//                       minWidth: screenWidth,
//                       child: RaisedButton(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           onPressed: () {
//                             Map body;
//                             if (_phoneNumberController.text == "") {
//                               Fluttertoast.showToast(
//                                   msg: "Please Enter Your Number",
//                                   fontSize: 16,
//                                   backgroundColor: Colors.orange[100],
//                                   textColor: darkThemeBlue,
//                                   toastLength: Toast.LENGTH_LONG);
//                             } else if (_phoneNumberController.text.length != 10) {
//                               Fluttertoast.showToast(
//                                   msg: "Please Enter 10 Digit Valid Number",
//                                   fontSize: 16,
//                                   backgroundColor: Colors.orange[100],
//                                   textColor: darkThemeBlue,
//                                   toastLength: Toast.LENGTH_LONG);
//                             } else if (_phoneNumberController.text.length == 10) {
//                               otpSentCheck = true;
//                               otpVerify(context);
//                               // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
//                               //   return PinCodeVerificationScreen(_phoneNumberController.text);
//                               // }));
//                               setState(() {
//                                 print("arriibbaasssssss");
//                                 // otpSentCheck = true;
//                               });
//                             }
//                           },
//                           color: orangeCol,
//                           textColor: Colors.white,
//                           child:Text("Get OTP",
//                               style: TextStyle(
//                                   fontSize: 17, fontWeight: FontWeight.bold))
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//             InkWell(
//               onTap: (){
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (BuildContext context) {
//                       return HomeStartingPage();
//                     }));
//               },
//               child: Padding(
//               padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
//               child:  Text(
//                   "Skip Sign In for now >>>",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: textCol,
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold
//                   ),
//                 ),
//               ),
//             ),
//
//             // Forgot Password Text.....
//
//             // Padding(
//             //   padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
//             //   child: InkWell(
//             //     onTap: (){
//             //       /*Navigator.push(context,
//             //           MaterialPageRoute(builder: (BuildContext context) {
//             //             return MapHomePage();
//             //             // return MyAppMap();
//             //           }));*/
//             //     },
//             //     child: InkWell(
//             //       onTap: (){
//             //         Navigator.push(context,
//             //             MaterialPageRoute(builder: (BuildContext context) {
//             //               return ForgetPasswordOtpPage();
//             //             }));
//             //       },
//             //       child: Padding(
//             //         padding: const EdgeInsets.all(8.0),
//             //         child: Text(
//             //           "Forgot Password?",
//             //           textAlign: TextAlign.center,
//             //           style: TextStyle(
//             //               color: textCol,
//             //               fontSize: 13,
//             //               fontWeight: FontWeight.bold
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//
//             // New Sign up Text.....
//
//             // InkWell(
//             //   onTap: (){
//             //     Navigator.push(context,
//             //         MaterialPageRoute(builder: (BuildContext context) {
//             //           return MobileNumberPage();
//             //         }));
//             //   },
//             //   child: Padding(
//             //       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//             //       child: RichText(    // To Make Different Text Color in single line
//             //         textAlign: TextAlign.center,
//             //         text: TextSpan(
//             //             text: "Don't have an account?",
//             //             style: TextStyle(
//             //                 color: textCol,
//             //                 fontSize: 13,
//             //                 fontWeight: FontWeight.bold
//             //             ),
//             //             children: [
//             //               TextSpan(
//             //                 text: " Sign Up",
//             //                 style: TextStyle(
//             //                     color: orangeCol,
//             //                     fontSize: 13,
//             //                     fontWeight: FontWeight.bold
//             //                 ),
//             //               ),
//             //             ]
//             //         ),
//             //       )
//             //   ),
//             // ),
//
//             // or connect with Text.....
//
//             // Padding(
//             //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
//             //   child: Text(
//             //     "or connect with",
//             //     textAlign: TextAlign.center,
//             //     style: TextStyle(
//             //         color: textCol,
//             //         fontSize: 13,
//             //         fontWeight: FontWeight.bold
//             //     ),
//             //   ),
//             // ),
//             //
//             // // fb and google logo.....
//             //
//             // Center(
//             //   child: Container(
//             //     height: 40.0,
//             //     width: 100.0,
//             //     child: Row(
//             //       children: [
//             //         InkWell(
//             //             onTap: (){
//             //               Fluttertoast.showToast(
//             //                   msg: "Facebook Login Coming soon",
//             //                   fontSize: 16,
//             //                   backgroundColor: Colors.white,
//             //                   textColor: darkThemeBlue,
//             //                   toastLength: Toast.LENGTH_LONG);
//             //               // loginWithFB();
//             //               // signOutUser();
//             //               // initiateFacebookLogin();
//             //             },
//             //             child: Image.asset("assets/images/logos/facebook.png")),
//             //         SizedBox(width: 20.0,),
//             //         InkWell(
//             //             onTap: (){
//             //               // Fluttertoast.showToast(
//             //               //     msg: "Google login Coming soon",
//             //               //     fontSize: 16,
//             //               //     backgroundColor: Colors.white,
//             //               //     textColor: darkThemeBlue,
//             //               //     toastLength: Toast.LENGTH_LONG);
//             //               // googleSignIn(context);
//             //               // logout();
//             //             },
//             //             child: Image.asset("assets/images/logos/google-plus.png")),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             //
//             // SizedBox(height: 50.0,),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
// }


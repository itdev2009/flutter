import 'dart:async';

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/registration_otp_screens/registrationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  PinCodeVerificationScreen(this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String codeVerificationId;
  FirebaseAuth _auth;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    _auth = FirebaseAuth.instance;
    otpVerify(context);
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  Future<void> otpVerify(BuildContext context) async {
    print("dhuke ge6e");

    _auth.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          User user = (await _auth.signInWithCredential(credential)).user;
          if (user != null) {
            print("login success via firebase otp auto");
            Fluttertoast.showToast(
                msg: "OTP successfully verified",
                fontSize: 16,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return RegistrationPage(phoneNumber: widget.phoneNumber,
              );
            }));
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print("error di6666eee $exception");
          print("error di66e otp te");
          Fluttertoast.showToast(
              msg: "Please Enter a Correct and New Phone Number",
              fontSize: 16,
              backgroundColor: Colors.orange[100],
              textColor: darkThemeBlue,
              toastLength: Toast.LENGTH_LONG);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          // otpSentCheck = false;
          final code = currentText.trim();
          codeVerificationId = verificationId;
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
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: FlareActor(
                  "assets/otp.flr",
                  animation: "otp",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
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
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 50,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      backgroundColor: Colors.blue.shade50,
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
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Color(0xFF91D3B3),
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
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
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Aye!!"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  ),
                  FlatButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      textEditingController.text = "123456";
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  otpVerification() async{
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: codeVerificationId, smsCode: currentText);
      User user = (await _auth.signInWithCredential(credential)).user;

      if (user != null) {
        print("successfully verify manually");
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return RegistrationPage(phoneNumber: widget.phoneNumber);
        }));
      } else {
        print("Error");
      }
    } catch (PlatformException) {
      print("keno dibi ex $PlatformException");
    }
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

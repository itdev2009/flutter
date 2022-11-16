import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/registration_otp_screens/otpPage.dart';
import 'package:delivery_on_time/registration_otp_screens/registrationPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MobileNumberPage extends StatefulWidget {


  @override
  _MobileNumberPageState createState() => _MobileNumberPageState();
}

class _MobileNumberPageState extends State<MobileNumberPage> {
  bool otpSentCheck = false;


  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();

  Future<void> otpVerify(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    print("dhuke ge6e");

    _auth.verifyPhoneNumber(
        phoneNumber: "+91${_phoneNumberController.text}",
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
              return RegistrationPage(
                phoneNumber: _phoneNumberController.text,
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
        codeSent: (String verificationId, [int forceResendingToken]) {
          otpSentCheck = false;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  // title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/logos/orange_tick.png",
                        height: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Code Sent Successfully",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  actions: [
                    new FlatButton(
                      child: const Text("Enter OTP Manually",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),),
                      onPressed: (){
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {

                              return AlertDialog(
                                title: Text("Give the code?"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      controller: _codeController,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.code),
                                          hintText: "Unique Code",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                          ),
                                          border: InputBorder.none),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Confirm"),
                                    textColor: Colors.white,
                                    color: orangeCol,
                                    onPressed: () async {
                                      final code = _codeController.text.trim();
                                      if (_codeController.text.length == 6) {
                                        try {
                                          AuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode: code);
                                          User user = (await _auth.signInWithCredential(credential)).user;

                                          if (user != null) {
                                            print("successfully verify manually");
                                            Fluttertoast.showToast(
                                                msg: "OTP successfully verified",
                                                fontSize: 16,
                                                backgroundColor: Colors.orange[100],
                                                textColor: darkThemeBlue,
                                                toastLength: Toast.LENGTH_LONG);
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      return RegistrationPage(
                                                        phoneNumber: _phoneNumberController.text,
                                                      );
                                                    }));
                                          } else {
                                            print("Error");
                                          }
                                        } catch (PlatformException) {
                                          print("keno dibi ex $PlatformException");
                                          Fluttertoast.showToast(
                                              msg: "Please Enter Correct OTP",
                                              fontSize: 16,
                                              backgroundColor: Colors.orange[100],
                                              textColor: darkThemeBlue,
                                              toastLength: Toast.LENGTH_LONG);
                                        }
                                      } else if (_codeController.text.length < 6) {
                                        Fluttertoast.showToast(
                                            msg: "Please Enter 6 Digit OTP",
                                            fontSize: 16,
                                            backgroundColor: Colors.orange[100],
                                            textColor: darkThemeBlue,
                                            toastLength: Toast.LENGTH_LONG);
                                      }
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    ),
                  ],
                );
              });

        },
        codeAutoRetrievalTimeout: (String verificationId)
        {
          verificationId = verificationId;
          print(verificationId);
          print("Timout");
        });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          children: [
            // Delivery Logo.....

            Container(
              height: screenHeight * 0.23,
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Image.asset("assets/images/logos/delivery_icon.png"),
            ),

            // Heading Text.....

            Text(
              "DELIVERY ON TIME",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textCol,
                  fontSize: screenWidth * 0.05,
                  fontWeight: font_bold),
            ),

            // Welcome Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 60, 0, 10),
              child: Text(
                "Welcome",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08,
                  fontWeight: font_bold,
                ),
              ),
            ),

            // Sign in or up Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "Please Enter Your Phone Number to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                  fontWeight: font_bold,
                ),
              ),
            ),

            // Email Text Field.....

            Container(
              height: 165.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      style: TextStyle(fontSize: 14.0),
                      // textAlignVertical: TextAlignVertical.top,
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

                  //Sign In Button.....

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                    child: ButtonTheme(
                      /*__To Enlarge Button Size__*/
                      height: 50.0,
                      minWidth: screenWidth,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () {
                          Map body;
                          if (_phoneNumberController.text == "") {
                            Fluttertoast.showToast(
                                msg: "Please Enter Your Number",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_phoneNumberController.text.length != 10) {
                            Fluttertoast.showToast(
                                msg: "Please Enter 10 Digit Valid Number",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          } else if (_phoneNumberController.text.length == 10) {
                            otpSentCheck = true;
                            otpVerify(context);
                            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            //   return PinCodeVerificationScreen(_phoneNumberController.text);
                            // }));
                            setState(() {
                              print("arriibbaasssssss");
                              // otpSentCheck = true;
                            });
                          }
                        },
                        color: orangeCol,
                        textColor: Colors.white,
                        child:Text("Get OTP",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold))
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      print("push");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return OtpPage(_phoneNumberController.text,userId,name);
          }));
    });
  }*/

/*Future<void> managedSharedPref(RegistrationModel data) async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setString("user_id", "${data.success.id}");
    prefs.setString('token', data.success.token);
    // prefs.setString('name', data.success.name);
    // prefs.setBool('login_app', true);
  }*/

/*Widget registerStreamFunc() {
    return StreamBuilder<ApiResponse<RegistrationModel>>(
      stream: _registrationBloc.registrationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
              break;
            case Status.COMPLETED:
              */ /*if(snapshot.data.data.success.name!=null){
              print("complete");
              managedSharedPref(snapshot.data.data);
              navToAttachList(context);
            }
            else*/ /*
              {
                Fluttertoast.showToast(
                    msg: "Please Enter Proper Details",
                    fontSize: 14,
                    backgroundColor: Colors.white,
                    textColor: darkThemeBlue,
                    toastLength: Toast.LENGTH_LONG);
              }

              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
              );
              break;
          }
        } else if (snapshot.hasError) {
          print("error");
        }
        return Container();
      },
    );
  }*/

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/login_screen/login.dart';
import 'package:delivery_on_time/registration_otp_screens/bloc/registraionBloc.dart';
import 'package:delivery_on_time/registration_otp_screens/model/registrationModel.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  final String phoneNumber;

  RegistrationPage({this.phoneNumber});

  @override
  _RegistrationPageState createState() =>
      _RegistrationPageState(phoneNumber);
}

class _RegistrationPageState extends State<RegistrationPage> {
  String phoneNumber;

  _RegistrationPageState(this.phoneNumber);

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

  RegistraionBloc _registrationBloc = RegistraionBloc();

  SharedPreferences prefs;
  String cartId="";
  String DeviceID="";


  @override
  void initState() {
    super.initState();
    createSharedPref();

  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    cartId=prefs.getString("cart_id");
    DeviceID=prefs.getString("device_id");

    // DeviceID=prefs.getString("device_id");
    // DeviceID="";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            // Delivery Logo.....

            Container(
              height: 85,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Image.asset("assets/images/logos/delivery_icon.png"),
            ),

            // Heading Text.....

            Text(
              "DELIVERY ON TIME",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textCol, fontSize: 12, fontWeight: font_bold),
            ),

            // Welcome Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
              child: Text(
                "Registration",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: font_bold,
                ),
              ),
            ),

            // Sign in or up Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "Please Sign Up to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  // fontWeight: font_bold,
                ),
              ),
            ),

            // Full Name Text Field.....

            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: _nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: "Full Name",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),

            // Email Text Field.....

            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email ID",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),

            //Password Text Field.....

            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),

            //Confirm Password Text Field.....

            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: _confirmPasswordController,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),

            //Sign Up Button.....

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
              child: ButtonTheme(
                /*__To Enlarge Button Size__*/
                height: 45.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    if (_nameController.text == "" ||
                        _emailController.text == "" ||
                        _passwordController.text == "" ||
                        _confirmPasswordController.text == "") {
                      Fluttertoast.showToast(
                          msg: "Please Fill All Required Field",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else if (!EmailValidator.validate(
                        _emailController.text)) {
                      Fluttertoast.showToast(
                          msg: "Please Enter Correct Email ID",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else if (!(_passwordController.text ==
                        _confirmPasswordController.text)) {
                      Fluttertoast.showToast(
                          msg: "Password and Confirm Password Does Not Match",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else {
                      Map body = {
                        "name": "${_nameController.text}",
                        "email": "${_emailController.text}",
                        "password": "${_passwordController.text}",
                        "confirm_password":
                            "${_confirmPasswordController.text}",
                        "mobile_number": "+91$phoneNumber",
                        "deviceid" : "$DeviceID",
                      "cart_id": "$cartId"
                      };
                      _registrationBloc.Register(body);
                    }
                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child: StreamBuilder<ApiResponse<RegistrationModel>>(
                    stream: _registrationBloc.registrationStream,
                    builder: (context, snapshot) {
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
                            // if (snapshot.data.data.success.name != null)
                            {
                              print("complete");

                              if (snapshot.data.data.success != null) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Thank You ${_nameController.text} For Registering With Us",
                                    fontSize: 14,
                                    backgroundColor: Colors.orange[100],
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);

                                navToAttachList(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "The Email Id : ${_emailController.text} has Already Been Taken",
                                    fontSize: 12,
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
                            /*return Error(
                                      errorMessage: snapshot.data.message,
                                    );*/
                            break;
                        }
                      } else if (snapshot.hasError) {
                        print("error");
                      }

                      return Text("Sign Up",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold));
                    },
                  ),
                ),
              ),
            ),

            // New Sign up Text.....

            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return LoginByMobilePage();
                    }));
                  },
                  child: RichText(
                    // To Make Different Text Color in single line
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                            color: textCol,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: " Sign In",
                            style: TextStyle(
                                color: orangeCol,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                )),

            // or connect with Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
              child: Text(
                "or connect with",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textCol, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),

            // fb and google logo.....

            Center(
              child: Container(
                height: 40.0,
                width: 100.0,
                child: Row(
                  children: [
                    Image.asset("assets/images/logos/facebook.png"),
                    SizedBox(
                      width: 20.0,
                    ),
                    Image.asset("assets/images/logos/google-plus.png"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      print("push");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginByMobilePage();
      }));
    });
  }
}

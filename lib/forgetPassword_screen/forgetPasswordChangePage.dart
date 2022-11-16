import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/forgetPassword_screen/bloc/forgetPasswordBloc.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/login_screen/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/forgetPasswordModel.dart';

class ForgetPasswordChangePage extends StatefulWidget {

  final String email;

  const ForgetPasswordChangePage({Key key, this.email}) : super(key: key);


  @override
  _ForgetPasswordChangePageState createState() => _ForgetPasswordChangePageState(email);
}

class _ForgetPasswordChangePageState extends State<ForgetPasswordChangePage> {

  final String email;
  _ForgetPasswordChangePageState(this.email);


  TextEditingController _passwordController=new TextEditingController();
  TextEditingController _confirmPasswordController=new TextEditingController();
  TextEditingController _otpController=new TextEditingController();

  ForgetPasswordBloc _forgetPasswordBloc;



  @override
  void initState() {
    super.initState();
    _forgetPasswordBloc =new ForgetPasswordBloc();
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
        return LoginByMobilePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        appBar: AppBar(
            backgroundColor: lightThemeBlue,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Center(
                child: Text(
                  "Forget Password Change",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045),
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
        body: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [

            // Delivery Logo.....

            Container(
              height: 95,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Image.asset("assets/images/logos/delivery_icon.png"),
            ),

            // Heading Text.....

            Text(
              "DELIVERY ON TIME",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textCol, fontSize: 13, fontWeight: font_bold),
            ),


            SizedBox(
              height: screenHeight*0.1,
            ),

            // Sign in or up Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text(
                "Please Enter OTP Sent to $email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  // fontWeight: font_bold,
                ),
              ),
            ),





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
                controller: _otpController,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: "One Time Password ( OTP )",
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
              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: _passwordController,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                obscureText: true,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "New Password",
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
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),

            //sent OTP Button.....

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: ButtonTheme(   /*__To Enlarge Button Size__*/
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    if(_otpController.text=="" ||
                        _passwordController.text=="" ||
                        _confirmPasswordController.text=="")
                    {
                      Fluttertoast.showToast(
                          msg: "Please Enter Your Email ID",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_passwordController.text!=_confirmPasswordController.text){
                      Fluttertoast.showToast(
                          msg: "Password and Confirm Password is Different",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);

                  }else{
                      Map body;
                      body = {
                        "email": "$email",
                        "otp": "${_otpController.text}",
                        "password": "${_passwordController.text}",
                        "confirm_password": "${_confirmPasswordController.text}"
                      };

                      _forgetPasswordBloc.passwordChange(body);
                    }

                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child:  StreamBuilder<ApiResponse<ForgetPasswordModel>>(
                    stream: _forgetPasswordBloc.forgetPasswordStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return CircularProgressIndicator(
                                backgroundColor: circularBGCol,
                                strokeWidth: strokeWidth,
                                valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
                            );
                            /*Loading(
                              loadingMessage: snapshot.data.message,
                            );*/
                            break;
                          case Status.COMPLETED:
                            if (snapshot.data.data.success != false)
                            {
                              print("complete");
                              navToAttachList(context);
                              Fluttertoast.showToast(
                                  msg: "${snapshot.data.data.message}",
                                  fontSize: 16,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            }else{
                              Fluttertoast.showToast(
                                  msg: "${snapshot.data.data.message}, \n OTP is Wrong",
                                  fontSize: 16,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                            break;
                          case Status.ERROR:
                            Fluttertoast.showToast(
                                msg: "Wrong OTP Entered",
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

                      return Text("Change Password",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ));
                    },
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}

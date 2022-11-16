import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/forgetPassword_screen/bloc/forgetPasswordOtpBloc.dart';
import 'package:delivery_on_time/forgetPassword_screen/forgetPasswordChangePage.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/forgetPasswordOtpModel.dart';

class ForgetPasswordOtpPage extends StatefulWidget {
  @override
  _ForgetPasswordOtpPageState createState() => _ForgetPasswordOtpPageState();
}

class _ForgetPasswordOtpPageState extends State<ForgetPasswordOtpPage> {

  TextEditingController _emailController=new TextEditingController();

  ForgetPasswordOtpBloc _forgetPasswordOtpBloc;


  @override
  void initState() {
    super.initState();
    _forgetPasswordOtpBloc =new ForgetPasswordOtpBloc();
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
        return ForgetPasswordChangePage(email: _emailController.text.trim());
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
                  "Forget Password",
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
              margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
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
              height: screenHeight*0.2,
            ),

            // Sign in or up Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                "Please Enter Your E-Mail ID to Send OTP",
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
                controller: _emailController,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: "User Email Id",
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
                    if(_emailController.text.trim()=="")
                    {
                      Fluttertoast.showToast(
                          msg: "Please Enter Your Email ID",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if(!EmailValidator.validate(_emailController.text)){
                      Fluttertoast.showToast(
                          msg: "Please Enter Correct Email ID",
                          fontSize: 16,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else{
                      Map body;
                      body = {
                        "email" : "${_emailController.text.trim()}",

                      };

                      _forgetPasswordOtpBloc.otp(body);
                      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      //   return ForgetPasswordChangePage(email: _emailController.text.trim());
                      // }));
                    }

                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child:  StreamBuilder<ApiResponse<ForgetPasswordOtpModel>>(
                    stream: _forgetPasswordOtpBloc.forgetPasswordOtpStream,
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
                                  backgroundColor: Colors.white,
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Invalid Email ID",
                                  fontSize: 16,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                            break;
                          case Status.ERROR:
                            Fluttertoast.showToast(
                                msg: "Your Entered Email ID is Invalid",
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

                      return Text("SEND OTP",
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

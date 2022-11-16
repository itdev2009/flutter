import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/login_screen/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/changePasswordBloc.dart';
import 'model/changePasswordModel.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {

  TextEditingController _oldPasswordText = new TextEditingController();
  TextEditingController _newPasswordText = new TextEditingController();
  TextEditingController _newConfirmPasswordText = new TextEditingController();
  ChangePasswordBloc _changePasswordBloc;
  String userToken = "";
  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    createSharedPref();
    _changePasswordBloc = new ChangePasswordBloc();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    print(userToken);
    print(prefs.getString("user_token"));
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      print("push");
      prefs.setString("cart_id", "");
      prefs.setString("user_id", "");
      prefs.setString("token", "");
      prefs.setString("name", "");
      prefs.setString("email", "");
      prefs.setString("user_token", "");
      prefs.setBool("user_login", false);
      userLogin=false;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return LoginByMobilePage();
          }));

    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  "Password Change Panel".toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04),
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
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [

            // Address Text.....

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Change Your Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: font_bold,
                    ),
                  ),

                ],
              ),
            ),


            // Old Password Text Field.....

            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                obscuringCharacter: "*",
                obscureText: true,
                controller: _oldPasswordText,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open_rounded),
                    hintText: "Old Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),
            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                obscuringCharacter: "*",
                obscureText: true,
                controller: _newPasswordText,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintText: "New Password",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    border: InputBorder.none),
              ),
            ),
            Container(
              height: 45.0,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: TextField(
                obscuringCharacter: "*",
                obscureText: true,
                controller: _newConfirmPasswordText,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14.0),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_rounded),
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
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {

                    if(_oldPasswordText.text=="" ||
                    _newPasswordText.text=="" ||
                    _newConfirmPasswordText.text==""){
                      Fluttertoast.showToast(
                          msg: "Please Fill all Required Field",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_newPasswordText.text != _newConfirmPasswordText.text){
                      Fluttertoast.showToast(
                          msg: "New Password and Confirm Password is Different",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else{
                      Map body={
                        "old_password": "${_oldPasswordText.text.trim()}",
                        "new_password": "${_newPasswordText.text.trim()}",
                        "confirm_password": "${_newConfirmPasswordText.text.trim()}"
                      };
                      _changePasswordBloc.changePassword(body, userToken);
                    }
                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child: StreamBuilder<ApiResponse<ChangePasswordModel>>(
                    stream: _changePasswordBloc.changePasswordAddStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return CircularProgressIndicator(
                                backgroundColor: circularBGCol,
                                strokeWidth: strokeWidth,
                                valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
                            );
                            break;
                          case Status.COMPLETED:
                            print("complete");
                            // managedSharedPref(snapshot.data.data);
                            if(snapshot.data.data.message.contains("Password updated successfully")){
                              navToAttachList(context);
                              Fluttertoast.showToast(
                                  msg: "Password Has Been Changed Successfully, Please Login Again With New Password",
                                  fontSize: 14,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            } else if(snapshot.data.data.message.contains("Please check your current password")){
                              // Please check your current password.
                              Fluttertoast.showToast(
                                  msg: "Please check your current password.",
                                  fontSize: 14,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                            }

                            break;
                          case Status.ERROR:
                            Fluttertoast.showToast(
                                msg: "Error : ${snapshot.data.message}",
                                fontSize: 14,
                                backgroundColor: Colors.white,
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                            break;
                        }
                      } else if (snapshot.hasError) {
                        print("error");
                      }

                      return Text("Change Password",
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
                    },
                  ),



                ),
              ),
            ),

            // New Sign up Text.....

            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

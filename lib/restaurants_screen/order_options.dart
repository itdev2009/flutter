import 'dart:io';

import 'package:delivery_on_time/cart_screen/cartPage.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';



class OrderOptions extends StatefulWidget {
  const OrderOptions({Key key}) : super(key: key);

  @override
  State<OrderOptions> createState() => _OrderOptionsState();
}

class _OrderOptionsState extends State<OrderOptions> {

  TextEditingController _deliveryDateTimeText;
  TextEditingController _remarksText = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  File file;

  final picker = ImagePicker();
  final Dio _dio = Dio();
  String userToken="";
  SharedPreferences prefs;


  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();

    userToken=prefs.getString("user_token");
  }

  @override
  void initState() {


    super.initState();
    dateAndTime2 = '';
    orderremarks = '';
    baseImage2 = '';
    createSharedPref();


  }

  Future<void> _showSelectionDialog1(BuildContext context) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery1(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        Addpicture(context);
                      },
                    )
                  ],
                ),
              ));
        });

  }



  void _openGallery1(BuildContext context) async{

    imageCache.maximumSize = 0;
    imageCache.clear();

    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery, preferredCameraDevice: CameraDevice.rear,imageQuality: 30);
      if (pickedFile.path == null) {
        print('IT IS NULL');
        return;

      }
      else {
        print('IT IS NOT NULL');
        file = File(pickedFile.path);
        //baseImage = await base64Encode(file.readAsBytesSync());
        //fileName = await file.path.split("/").last;
        //print(baseImage);
        //Navigator.of(context).pop();

        var filenames = await MultipartFile.fromFile(File(file.path).path,
            filename: file.path);

        FormData formData =
        FormData.fromMap({"filenames[]": filenames, "type": "order_image"});

        print(formData);
        Navigator.of(context).pop();

        //       setState(() {
        //      loading = true;
        //   });

        ProgressDialog pr = ProgressDialog(context);
        pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
        pr.style(message: 'Processing Image',insetAnimCurve: Curves.easeInOut);
        await pr.show();


        Response res = await _dio.post(ApiBaseHelper.baseUrl + "upload/image",
            data: formData,
            options: Options(headers: {"Authorization": "Bearer " + userToken}));


        //  setState(() {
        //    loading = false;
        //   });


        //Navigator.pop(context);
        // Navigator.pop(context);
        //  Navigator.of(context).pop();


        if(res!=null) {
          print('RES NOT NULL');
          print(res.data['message']);


          //loading == false?
          // Container()
          //    :
          // Center(child: CircularProgressIndicator()),
          // AlertDialog(
          // title: Text("From where do you want to take the photo?"),
          //     content: SingleChildScrollView(
          //     child: Center(child: CircularProgressIndicator()),
          //   ),

          //  ),
          // _showSelectionDialog2(context);

                  if(res.data['message'].toString().contains("Token has been expired"))
                    {

                      print('token expired');
                      //  modalSheetToLogin();

                      //  Navigator.pop(context);

                      await pr.hide();


                      userLogin=false;
                      prefs.clear();
                      // signOutUser();
                      // logout();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (BuildContext context) {
                      //       return Login();

                      //     }));

                      Fluttertoast.showToast(
                          msg: "Your login session has expired, please re-login!",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);

                      //Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                     //  Navigator.pop(context);

                    //  Future.delayed(Duration.zero, () {
                        //  Navigator. ...

                    //    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginByMobilePage() ), ModalRoute.withName('/home'));
                   //   });

                    //  BuildContext contxt1;
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushAndRemoveUntil(_scaffoldKey.currentContext, MaterialPageRoute(builder: (BuildContext context) => LoginByMobilePage() ), ModalRoute.withName('/home'));
                      });




                    }

                  else{


                    baseImage2 = res.data['data'].toString();
                    int n = baseImage2.length;
                    baseImage2 = baseImage2.substring(1, n - 1);
                    //  print(res.data);
                    // print(res.runtimeType);
                    // print(res.data['data']);

                    print(baseImage2);

                    print(res.data['data']);

                    print('to string:');
                    print(res.data['data'].toString());

                    await pr.hide();


                    Fluttertoast.showToast(
                        msg: "Image uploaded successfully",
                        fontSize: 16,
                        backgroundColor: Colors.orange[100],
                        textColor: darkThemeBlue,
                        toastLength: Toast.LENGTH_LONG);

                  }



        }


        //  setState(() {
        //       loading = false;
        //  });


        //Navigator.pop(context);
        //    Navigator.of(context).pop();
        //  Navigator.of(context).pop();


        //Navigator.of(context).pop();
        //  if(loading==true)
        //  {
        // setState(() {
        //    loading = false;
        //  });
        // Navigator.of(context).pop();
        //  }
      }
    }
    catch (e) {
      print(e.code);
    }


  }



  Addpicture(BuildContext context) async{

    imageCache.maximumSize = 0;
    imageCache.clear();

    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear,imageQuality: 30);
      if (pickedFile.path == null) {
        print('IT IS NULL');
        return;

      }
      else {
        print('IT IS NOT NULL');
        file = File(pickedFile.path);
        //baseImage = await base64Encode(file.readAsBytesSync());
        //fileName = await file.path.split("/").last;
        //print(baseImage);
        //Navigator.of(context).pop();

        var filenames = await MultipartFile.fromFile(File(file.path).path,
            filename: file.path);

        FormData formData =
        FormData.fromMap({"filenames[]": filenames, "type": "order_image"});

        print(formData);
        Navigator.of(context).pop();

        //       setState(() {
        //      loading = true;
        //   });

        ProgressDialog pr = ProgressDialog(context);
        pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
        pr.style(message: 'Processing Image',insetAnimCurve: Curves.easeInOut);
        await pr.show();


        Response res = await _dio.post(ApiBaseHelper.baseUrl + "upload/image",
            data: formData,
            options: Options(headers: {"Authorization": "Bearer " + userToken}));


        //  setState(() {
        //    loading = false;
        //   });


        //Navigator.pop(context);
        // Navigator.pop(context);
        //  Navigator.of(context).pop();


        if(res!=null) {
          print('RES NOT NULL');


          //loading == false?
          // Container()
          //    :
          // Center(child: CircularProgressIndicator()),
          // AlertDialog(
          // title: Text("From where do you want to take the photo?"),
          //     content: SingleChildScrollView(
          //     child: Center(child: CircularProgressIndicator()),
          //   ),

          //  ),
          // _showSelectionDialog2(context);



          if(res.data['message'].toString().contains("Token has been expired"))
          {

            print('token expired');
            //  modalSheetToLogin();

            //  Navigator.pop(context);

            await pr.hide();


            userLogin=false;
            prefs.clear();
            // signOutUser();
            // logout();
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (BuildContext context) {
            //       return Login();

            //     }));

            Fluttertoast.showToast(
                msg: "Your login session has expired, please re-login!",
                fontSize: 14,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);

            //Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

            //  Navigator.pop(context);

            //  Future.delayed(Duration.zero, () {
            //  Navigator. ...

            //    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginByMobilePage() ), ModalRoute.withName('/home'));
            //   });

            //  BuildContext contxt1;
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(_scaffoldKey.currentContext, MaterialPageRoute(builder: (BuildContext context) => LoginByMobilePage() ), ModalRoute.withName('/home'));
            });




          }



            else{

            baseImage2 = res.data['data'].toString();
            int n = baseImage2.length;
            baseImage2 = baseImage2.substring(1, n - 1);
            //  print(res.data);
            // print(res.runtimeType);
            // print(res.data['data']);

            print(baseImage2);
            print(res.data['data']);

            print('to string:');
            print(res.data['data'].toString());

            await pr.hide();


            Fluttertoast.showToast(
                msg: "Image uploaded successfully",
                fontSize: 16,
                backgroundColor: Colors.orange[100],
                textColor: darkThemeBlue,
                toastLength: Toast.LENGTH_LONG);

          }

          }



        //  setState(() {
        //       loading = false;
        //  });


        //Navigator.pop(context);
        //    Navigator.of(context).pop();
        //  Navigator.of(context).pop();


        //Navigator.of(context).pop();
        //  if(loading==true)
        //  {
        // setState(() {
        //    loading = false;
        //  });
        // Navigator.of(context).pop();
        //  }
      }
    }
    catch (e) {
      print(e.code);
    }

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightThemeBlue,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.deepOrange,
          onPressed: () {


                orderremarks = _remarksText.text;
                print('DETAILS:');
                print(orderremarks);
                print(baseImage2);
                print(dateAndTime2);

                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPageNew()
                          // AddressPage()
                          ));






            // else if(_userToken=="")
            // {
            //   if(_cartId==""){
            //     Fluttertoast.showToast(
            //         msg: "Please Add Items In Your Cart",
            //         fontSize: 16,
            //         backgroundColor: Colors.white,
            //         textColor: darkThemeBlue,
            //         toastLength: Toast.LENGTH_LONG);
            //   }else{
            //
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MobileNumberPage(cartId: _cartId,)
            //         // AddressPage()
            //       ));
            //   }
            // }
          },
          label: Container(
            width: 180,
            child: Row(
              children: [
                Text(
                  "Click Here to Proceed",
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
                Spacer(),
                /*SizedBox(
                    width: 5,
                  ),*/
                /*Text(
                    "Rs.150  ",
                    style: TextStyle(
                        fontSize: screenWidth * 0.037, color: Colors.white),
                  ),*/
                Icon(
                  Icons.arrow_forward,
                  size: 15,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),

      appBar: AppBar(
          backgroundColor: darkThemeBlue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Center(
              child: Text(
                "Select Your Order Options",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
              )),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                size: 0,
                color: Colors.white,
              ),
            ),
          ]),

      body: Visibility(
        visible: true,
        child: Column(
          children: [


            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10,left: 16,top: 25),
                child: Text(
                  "Message / Product Image",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14,color: Colors.white70),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10,left: 10, right: 10,),
              child: Container(
                height: 50.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 3,right: 12),
                decoration: BoxDecoration(
                  color: darkThemeBlue,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: _remarksText,
                  keyboardType: TextInputType.name,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  style: GoogleFonts.poppins(fontSize: 14.0,color: Colors.white70,fontWeight: FontWeight.w500),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: GestureDetector(
                          onTap: (){
                            _showSelectionDialog1(_scaffoldKey.currentContext);
                          },
                          child: Icon(Icons.camera_alt_rounded,
                            color: lightTextGrey,
                            size: 19,),
                        ),
                      ),
                      hintText: "Product Description or What You Want",
                      hintStyle: GoogleFonts.poppins(
                        color: lightTextGrey,
                        fontSize: 14.0,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),

            Container(
              height: 55.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only( left: 15),
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: darkThemeBlue,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: TextField(
                onTap: () {
                  DatePicker.showDateTimePicker(context,
                      theme: DatePickerTheme(
                          containerHeight: 250,
                          backgroundColor: darkThemeBlue,
                          itemStyle: TextStyle(color: Colors.white),
                          cancelStyle: TextStyle(color: Colors.red[900], fontWeight: FontWeight.w500),
                          doneStyle: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500),
                          headerColor: lightThemeBlue,
                          itemHeight: 45.0,
                          titleHeight: 45.0),
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 14), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                        // final String formatted = formatter.format(date);
                        // print(formatted);
                        dateAndTime2 = DateFormat.yMd().add_Hms().format(date);
                        print('THIS IS THE SELCTED TIME:');
                        print(dateAndTime2);
                        setState(() {
                          dateAndTime2;
                        });
                        dateAndTimeFormated2 = DateFormat.yMMMd().add_Hms().format(date);
                        _deliveryDateTimeText.text = dateAndTimeFormated2;
                        // print(DateFormat.yMMMMd().add_jm().format(date));
                        // print(DateFormat.yMd().add_Hms().format(date));
                        // print(DateFormat().parse(_dateAndTimeText.text, true).hour);

                      }, currentTime: DateTime.now(), locale: LocaleType.en);


                },
                textInputAction: TextInputAction.next,
                controller: _deliveryDateTimeText,
                readOnly: true,
                // maxLength: 10,
                // maxLengthEnforced: true,
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.038, color: Colors.white70, fontWeight: FontWeight.w500),
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ),
                    hintText:  dateAndTime2.length<2?"Select Delivery Date and Time": '${dateAndTime2}',
                    hintStyle: GoogleFonts.poppins(color: Colors.white30, fontSize: screenWidth * 0.039, fontWeight: FontWeight.w400),
                    border: InputBorder.none),
              ),
            ),



          ],
        ),
      ),
    );
  }
}

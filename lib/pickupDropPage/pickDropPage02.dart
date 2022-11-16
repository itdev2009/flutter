import 'dart:io';

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropPage01.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropPage03.dart';
import 'package:delivery_on_time/pickup_drop_screen/mapAddressPicker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'mapForPickDrop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickDropPage02 extends StatefulWidget {
  @override
  _PickDropPage02State createState() => _PickDropPage02State();
}

class _PickDropPage02State extends State<PickDropPage02> {
  TextEditingController _senderNameText;
  TextEditingController _senderPhoneNumberText;
  TextEditingController _receiverNameText;
  TextEditingController _receiverPhoneNumberText;

  // TextEditingController _productNameText = new TextEditingController();
  // TextEditingController _productWeightText = new TextEditingController();
  // TextEditingController _productPriceText = new TextEditingController();

  TextEditingController _destinationText;

  //List<TextEditingController> additionalReceiverNames =[];

  final ScrollController _scrollController = ScrollController();
  bool incompleteAddress = false;
  bool incompleteRName = false;
  bool incompleteRNumber = false;

  final picker = ImagePicker();
  final Dio _dio = Dio();
  File file;
  String userTokenforPickup = "";
  SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool one = false;
  bool two = false;

  RegExp regExp = new RegExp(r"^[0-9]{10}$");

  @override
  void initState() {
    super.initState();
    createSharedPref();
    _senderNameText = new TextEditingController(text: sName);
    _senderPhoneNumberText = new TextEditingController(text: sPhone);
    _receiverNameText = new TextEditingController(text: rName);
    _receiverPhoneNumberText = new TextEditingController(text: rPhone);
    // _startingPointText = new TextEditingController(text: pickupAddress);

    senderTextControllerList[0].text = pickupAddress;

    _destinationText = new TextEditingController(text: destinationAddress);

    if (receivernameControllerList.isEmpty) {
      print('empty');
    } else {
      print('not empty');
    }
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    // senderToken = prefs.getString("user_token");
    userTokenforPickup = prefs.getString("user_token");

    user_address = prefs.getString("user_address") == null? "" :  prefs.getString("user_address");
    user_lat = prefs.getString("user_latitude") == null? "" :  prefs.getString("user_latitude");
    user_long = prefs.getString("user_longitude") == null? "" : prefs.getString("user_longitude");


    if(user_address!=null)
      {
        senderTextControllerList[0].text = user_address;
        pickupAddress = user_address;
      }

    if(user_lat!=null)
      {
        pickUpLat = double.parse(user_lat);
      }

    if(user_long!=null)
    {
      pickUpLong = double.parse(user_long);
    }



  }

  // TextEditingController _dateAndTimeText = new TextEditingController();

  Future<void> _showSelectionDialog1(BuildContext context, int n) {
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
                        _openGallery1(context, n);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        Addpicture(context, n);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Addpicture(BuildContext context, int position) async {
    imageCache.maximumSize = 0;
    imageCache.clear();

    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
          imageQuality: 30);
      if (pickedFile.path == null) {
        print('IT IS NULL');
        return;
      } else {
        print('IT IS NOT NULL');
        file = File(pickedFile.path);
        //baseImage = await base64Encode(file.readAsBytesSync());
        //fileName = await file.path.split("/").last;
        //print(baseImage);
        //Navigator.of(context).pop();

        var filenames = await MultipartFile.fromFile(File(file.path).path,
            filename: file.path);

        FormData formData = FormData.fromMap(
            {"filenames[]": filenames, "type": "product_image"});

        print(formData);
        Navigator.of(context).pop();

        //       setState(() {
        //      loading = true;
        //   });

        ProgressDialog pr = ProgressDialog(context);
        pr = ProgressDialog(context,
            type: ProgressDialogType.Normal,
            isDismissible: false,
            showLogs: false);
        pr.style(message: 'Processing Image', insetAnimCurve: Curves.easeInOut);
        await pr.show();

        Response res = await _dio.post(ApiBaseHelper.baseUrl + "upload/image",
            data: formData,
            options: Options(
                headers: {"Authorization": "Bearer " + userTokenforPickup}));

        //  setState(() {
        //    loading = false;
        //   });

        //Navigator.pop(context);
        // Navigator.pop(context);
        //  Navigator.of(context).pop();

        if (res != null) {
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

          if (res.data['message']
              .toString()
              .contains("Token has been expired")) {
            print('token expired');
            //  modalSheetToLogin();

            //  Navigator.pop(context);

            await pr.hide();

            userLogin = false;
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
              Navigator.pushAndRemoveUntil(
                  _scaffoldKey.currentContext,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginByMobilePage()),
                  ModalRoute.withName('/home'));
            });
          } else {
            baseImage = res.data['data'].toString();
            int n = baseImage.length;
            baseImage = baseImage.substring(1, n - 1);

            baseImageList.insert(position,baseImage);
            //  print(res.data);
            // print(res.runtimeType);
            // print(res.data['data']);

            print(baseImage);
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
    } catch (e) {
      print(e.code);
    }
  }

  void _openGallery1(BuildContext context, int position) async {
    imageCache.maximumSize = 0;
    imageCache.clear();

    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.rear,
          imageQuality: 30);
      if (pickedFile.path == null) {
        print('IT IS NULL');
        return;
      } else {
        print('IT IS NOT NULL');
        file = File(pickedFile.path);
        //baseImage = await base64Encode(file.readAsBytesSync());
        //fileName = await file.path.split("/").last;
        //print(baseImage);
        //Navigator.of(context).pop();

        var filenames = await MultipartFile.fromFile(File(file.path).path,
            filename: file.path);

        FormData formData = FormData.fromMap(
            {"filenames[]": filenames, "type": "product_image"});

        print(formData);
        Navigator.of(context).pop();

        //       setState(() {
        //      loading = true;
        //   });

        ProgressDialog pr = ProgressDialog(context);
        pr = ProgressDialog(context,
            type: ProgressDialogType.Normal,
            isDismissible: false,
            showLogs: false);
        pr.style(message: 'Processing Image', insetAnimCurve: Curves.easeInOut);
        await pr.show();

        Response res = await _dio.post(ApiBaseHelper.baseUrl + "upload/image",
            data: formData,
            options: Options(
                headers: {"Authorization": "Bearer " + userTokenforPickup}));

        //  setState(() {
        //    loading = false;
        //   });

        //Navigator.pop(context);
        // Navigator.pop(context);
        //  Navigator.of(context).pop();

        if (res != null) {
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

          if (res.data['message']
              .toString()
              .contains("Token has been expired")) {
            print('token expired');
            //  modalSheetToLogin();

            //  Navigator.pop(context);

            await pr.hide();

            userLogin = false;
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
              Navigator.pushAndRemoveUntil(
                  _scaffoldKey.currentContext,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginByMobilePage()),
                  ModalRoute.withName('/home'));
            });
          } else {
            baseImage = res.data['data'].toString();
            int len = baseImage.length;
            baseImage = baseImage.substring(1, len - 1);

            baseImageList.insert(position,baseImage);
            //  print(res.data);
            // print(res.runtimeType);
            // print(res.data['data']);

            print(baseImage);
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
    } catch (e) {
      print(e.code);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context, int n) async {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(2),

            content: Container(
              color: lightThemeBlue,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6, top: 20),
                            child: Text(
                              "Receiver Name",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 7, top: 5),
                      child: Container(
                        //height: 55.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          top: 3,
                          right: 12,
                        ),
                        decoration: BoxDecoration(
                          color: darkThemeBlue,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: receivernameControllerList[n],
                          keyboardType: TextInputType.name,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Icon(
                                  Icons.person_outline,
                                  color: lightTextGrey,
                                  size: 19,
                                ),
                              ),
                              hintText: "Enter Receiver Name",
                              hintStyle: GoogleFonts.poppins(
                                color: lightTextGrey,
                                fontSize: 14.0,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6, top: 20),
                            child: Text(
                              "Receiver Mobile Number",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 10, top: 5),
                      child: Container(
                        // height: 55.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 3, right: 12),
                        decoration: BoxDecoration(
                          color: darkThemeBlue,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: TextFormField(
                          onChanged: (v) {
                            if (_receiverPhoneNumberText.text.length == 0) {
                              setState(() {
                                one = false;
                              });
                            } else {
                              setState(() {
                                one = true;
                              });
                            }
                          },

                          textInputAction: TextInputAction.next,
                          controller: receiverphoneControllerList[n],
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          // maxLengthEnforced: true,
                          style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12, left: 13),
                                /*
                          child: Icon(
                              Icons.call_outlined,
                              color: lightTextGrey,
                              size: 19,
                          ),



                           */

                                child: one == false
                                    ? Text(
                                        '+91',
                                        style: GoogleFonts.poppins(
                                            color: lightTextGrey, fontSize: 14),
                                      )
                                    : Text(
                                        '+91',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white70, fontSize: 14),
                                      ),
                              ),
                              hintText: "Enter Receiver Mobile Number",
                              hintStyle: GoogleFonts.poppins(
                                color: lightTextGrey,
                                fontSize: 14.0,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 12, left: 18, top: 24),
                      child: Row(
                        children: [
                          Text(
                            "Receiver Address",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white70),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              rName = _receiverNameText.text.trim();
                              rPhone = _receiverPhoneNumberText.text.trim();
                              sName = _senderNameText.text.trim();
                              sPhone = _senderPhoneNumberText.text.trim();

                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MapPickDropPage(
                                  adressType: "destination",
                                  index: n,
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Find on Map  ",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: orangeCol),
                                  ),
                                  Icon(
                                    Icons.my_location,
                                    size: 14,
                                    color: orangeCol,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
                      child: Container(
                        // height: 55.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 3, right: 12),
                        decoration: BoxDecoration(
                          color: darkThemeBlue,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: TextField(
                          onTap: () {
                            rName = _receiverNameText.text.trim();
                            rPhone = _receiverPhoneNumberText.text.trim();
                            sName = _senderNameText.text.trim();
                            sPhone = _senderPhoneNumberText.text.trim();

                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return MapPickDropPage(
                                adressType: "destination",
                                index: n,
                              );
                            }));
                          },
                          textInputAction: TextInputAction.next,
                          controller: receiverdestinationTextControllerList[n],
                          readOnly: true,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: lightTextGrey,
                                  size: 19,
                                ),
                              ),
                              hintText: "Find Receiver address from map",
                              hintStyle: GoogleFonts.poppins(
                                color: lightTextGrey,
                                fontSize: 14.0,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),

                    /*
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, left: 18, top: 10),
                          child: Text(
                            "Product Name",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white70),
                          ),
                        ),
                      ],
                    ),

                     */

                    /*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 3, right: 12),
                        decoration: BoxDecoration(
                          color: darkThemeBlue,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: productNameController[n],
                          keyboardType: TextInputType.name,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Icon(
                                  Icons.person_outline,
                                  color: lightTextGrey,
                                  size: 19,
                                ),
                              ),
                              hintText: "Enter Product Name",
                              hintStyle: GoogleFonts.poppins(
                                color: lightTextGrey,
                                fontSize: 14.0,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ),

                     */

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 1, left: 18, top: 25),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Remarks/Any Cash Collect/Product Image",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.white70),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 3, right: 12),
                            decoration: BoxDecoration(
                              color: darkThemeBlue,
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            ),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              controller: remarksController[n],
                              keyboardType: TextInputType.name,
                              // maxLength: 10,
                              // maxLengthEnforced: true,
                              style: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500),
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(bottom: 2),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showSelectionDialog1(context , n);
                                      },
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: lightTextGrey,
                                        size: 19,
                                      ),
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
                      ],
                    ),

                  ],
                ),
              ),
            ),

            actions: <Widget>[
              /*

              FlatButton(

                color: Colors.red,
                textColor: Colors.white,
                child: Text('BACK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),

               */

              FlatButton(
                color: orangeCol,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  if (receiverdestinationTextControllerList[n].text.length >
                          2 &&
                      receiverphoneControllerList[n].text.length == 10 &&
                      receivernameControllerList[n].text.length > 1) {
                    setState(() {
                      //codeDialog = valueText;

                      numberOfReceivers = numberOfReceivers + 1;

                      Future.delayed(Duration(milliseconds: 100), () {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                      });

                      Navigator.pop(context);
                    });
                  } else {
                    // Navigator.pop(context);

                    Fluttertoast.showToast(
                        msg: "Please fill all the fields",
                        fontSize: 14,
                        backgroundColor: Colors.orange[100],
                        textColor: darkThemeBlue,
                        toastLength: Toast.LENGTH_LONG);
                  }
                },
              ),
            ],
          );
        });
  }

  bool senderVisible = true;
  int n = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightThemeBlue,
      appBar: AppBar(
        backgroundColor: darkerThemeBlue,
        title: Text(
          "Fill Details",
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(13, 10, 13, 0),
          physics: ScrollPhysics(),
          children: [
            //sender name..

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    iconSize: 21,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: senderVisible == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: orangeCol,
                          )
                        : Icon(
                            Icons.arrow_circle_down_rounded,
                            color: orangeCol,
                          ),
                    onPressed: () {
                      setState(() {
                        n = n + 1;
                      });

                      if (n % 2 == 0) {
                        setState(() {
                          senderVisible = false;
                        });
                      } else {
                        setState(() {
                          senderVisible = true;
                        });
                      }
                    }),
              ],
            ),

            Visibility(
              visible: senderVisible,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 6),
                child: Text(
                  "Sender Name / Shop Name",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white70),
                ),
              ),
            ),

            Visibility(
              visible: senderVisible,
              child: Container(
                height: 55.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 3, right: 12),
                decoration: BoxDecoration(
                  color: darkThemeBlue,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: _senderNameText,
                  keyboardType: TextInputType.name,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.person_outline,
                          color: lightTextGrey,
                          size: 19,
                        ),
                      ),
                      hintText: "Enter Sender Name",
                      hintStyle: GoogleFonts.poppins(
                        color: lightTextGrey,
                        fontSize: 14.0,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),

            //sender phoneNumber...
            Visibility(
              visible: senderVisible,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 6, top: 20),
                child: Text(
                  "Sender Mobile Number / Shop Number",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white70),
                ),
              ),
            ),

            Visibility(
              visible: senderVisible,
              child: Container(
                height: 55.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 3, right: 12),
                decoration: BoxDecoration(
                  color: darkThemeBlue,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                child: TextFormField(
                  onChanged: (v) {
                    if (_senderPhoneNumberText.text.length == 0) {
                      setState(() {
                        two = false;
                      });
                    } else {
                      setState(() {
                        two = true;
                      });
                    }
                  },

                  textInputAction: TextInputAction.next,
                  controller: _senderPhoneNumberText,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 13),
                        /*
                        child: Icon(
                          Icons.call_outlined
                          color: lightTextGrey,
                          size: 19,
                        ),


                         */

                        child: two == false
                            ? Text(
                                '+91',
                                style: GoogleFonts.poppins(
                                    color: lightTextGrey, fontSize: 14),
                              )
                            : Text(
                                '+91',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 14),
                              ),
                      ),
                      hintText: "Enter Sender Mobile Number",
                      hintStyle: GoogleFonts.poppins(
                        color: lightTextGrey,
                        fontSize: 14.0,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),

            //sender Address from Map
            Visibility(
              visible: senderVisible,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 6, top: 20),
                child: Row(
                  children: [
                    Text(
                      "Sender Address / Shop Address",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white70),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        rName = _receiverNameText.text;
                        rPhone = _receiverPhoneNumberText.text;
                        sName = _senderNameText.text;
                        sPhone = _senderPhoneNumberText.text;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MapPickDropPage(
                            adressType: "pickup",
                            index: 0,
                          );
                        }));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Find on Map  ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: orangeCol),
                          ),
                          Icon(
                            Icons.my_location,
                            size: 14,
                            color: orangeCol,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            Visibility(
              visible: senderVisible,
              child: Container(
                height: 55.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 3, right: 12),
                decoration: BoxDecoration(
                  color: darkThemeBlue,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                child: TextField(
                  onTap: () {
                    rName = _receiverNameText.text;
                    rPhone = _receiverPhoneNumberText.text;
                    sName = _senderNameText.text;
                    sPhone = _senderPhoneNumberText.text;
                    // modalSheet();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MapPickDropPage(
                        adressType: "pickup",
                        index: 0,
                      );
                    }));
                  },
                  textInputAction: TextInputAction.next,
                  controller: senderTextControllerList[0],
                  readOnly: true,
                  // maxLength: 10,
                  // maxLengthEnforced: true,
                  style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.location_on_outlined,
                          color: lightTextGrey,
                          size: 19,
                        ),
                      ),
                      hintText: "Select sender address from map",
                      hintStyle: GoogleFonts.poppins(
                        color: lightTextGrey,
                        fontSize: 14.0,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),

            SizedBox(
              height: screenHeight * 0.40,
              width: screenWidth * 1,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: numberOfReceivers,
                  itemBuilder: (context, n) {
                    return Column(
                      children: [
                        InkWell(
                          /*
                              onTap: () {

                                setState(() {
                                  numberOfReceivers = numberOfReceivers+1;
                                });

                              },

                                 */

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 5, left: 6, top: 20),
                                child: Text(
                                  "Receiver Name",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.white70),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      // _displayTextInputDialog(context,n);

                                      print('entered delete loop');

                                      print('value of n');
                                      print(n);

                                      print('value of number of receivers');
                                      print(numberOfReceivers);

                                      print('start');

                                      print(receivernameControllerList);

                                      receivernameControllerList.removeAt(n);

                                      receiverphoneControllerList.removeAt(n);

                                      receiverdestinationTextControllerList
                                          .removeAt(n);

                                      destinationLandmarkList.removeAt(n);

                                      destinationAddressList.removeAt(n);

                                      dropLatList.removeAt(n);

                                      droplongList.removeAt(n);

                                      rNameList.removeAt(n);

                                      rPhoneList.removeAt(n);

                                      baseImageList.removeAt(n);

                                      remarksController.removeAt(n);

                                      productNameController.removeAt(n);


                                      /*

                                        for(int i=n; i<numberOfReceivers; i++)
                                          {
                                            print(n);

                                            print(receivernameControllerList);

                                            receivernameControllerList.insert(i, receivernameControllerList.elementAt(i+1));



                                            receiverphoneControllerList.insert(n, receiverphoneControllerList.elementAt(n+1));

                                            receiverdestinationTextControllerList.insert(n, receiverdestinationTextControllerList.elementAt(n+1));
                                          }

                                         */

                                      print('end');

                                      print(receivernameControllerList);

                                      numberOfReceivers = numberOfReceivers - 1;

                                      /*

                                      else{

                                        print('value of n');
                                        print(n);
                                        print('value of number of receivers');
                                        print(numberOfReceivers);

                                        print('start');

                                        print(receivernameControllerList);

                                        receivernameControllerList.removeAt(n);
                                        receiverphoneControllerList.removeAt(n);
                                        receiverdestinationTextControllerList.removeAt(n);


                                        numberOfReceivers = numberOfReceivers-1;

                                        print('end');

                                        print(receivernameControllerList);

                                        print('value of n');
                                        print(n);


                                      }

                                      */
                                    });
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 5, top: 20),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Delete',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: orangeCol),
                                        ),
                                        Icon(
                                          Icons.delete_forever_rounded,
                                          color: orangeCol,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),

                        Container(
                          height: 55.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3, right: 12),
                          decoration: BoxDecoration(
                            color: darkThemeBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: TextField(
                            onChanged: (v) {
                              rNameList.insert(
                                  n, receivernameControllerList[n].text);
                            },

                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            controller: receivernameControllerList[n],
                            keyboardType: TextInputType.name,
                            // maxLength: 10,
                            // maxLengthEnforced: true,
                            style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: lightTextGrey,
                                    size: 19,
                                  ),
                                ),
                                hintText: "Enter Receiver Name",
                                hintStyle: GoogleFonts.poppins(
                                  color: lightTextGrey,
                                  fontSize: 14.0,
                                ),
                                border: InputBorder.none),
                          ),
                        ),

                        //Receiver phoneNumber...
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 6, top: 20),
                              child: Text(
                                "Receiver Mobile Number",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white70),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          height: 55.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3, right: 12),
                          decoration: BoxDecoration(
                            color: darkThemeBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: TextFormField(
                            onChanged: (v) {
                              if (_receiverPhoneNumberText.text.length == 0) {
                                setState(() {
                                  one = false;
                                });
                              } else {
                                setState(() {
                                  one = true;
                                });
                              }

                              rPhoneList.insert(
                                  n, receiverphoneControllerList[n].text);
                            },
                            readOnly: true,

                            textInputAction: TextInputAction.next,
                            controller: receiverphoneControllerList[n],
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            // maxLengthEnforced: true,
                            style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 12, left: 13),
                                  /*
                      child: Icon(
                        Icons.call_outlined,
                        color: lightTextGrey,
                        size: 19,
                      ),



                       */

                                  child: one == false
                                      ? Text(
                                          '+91',
                                          style: GoogleFonts.poppins(
                                              color: lightTextGrey,
                                              fontSize: 14),
                                        )
                                      : Text(
                                          '+91',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white70,
                                              fontSize: 14),
                                        ),
                                ),
                                hintText: "Enter Receiver Mobile Number",
                                hintStyle: GoogleFonts.poppins(
                                  color: lightTextGrey,
                                  fontSize: 14.0,
                                ),
                                border: InputBorder.none),
                          ),
                        ),

                        //sender Address from Map
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 6, top: 20),
                          child: Row(
                            children: [
                              Text(
                                "Receiver Address",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white70),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  /*
                                          rName = _receiverNameText.text.trim();
                                          rPhone = _receiverPhoneNumberText.text.trim();
                                          sName = _senderNameText.text.trim();
                                          sPhone = _senderPhoneNumberText.text.trim();

                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                            return MapPickDropPage(
                                              adressType: "destination",
                                              index:n,
                                            );
                                          }));

                                         */
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Find on Map  ",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: orangeCol),
                                    ),
                                    Icon(
                                      Icons.my_location,
                                      size: 14,
                                      color: orangeCol,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        Container(
                          height: 55.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3, right: 12),
                          decoration: BoxDecoration(
                            color: darkThemeBlue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: TextField(
                            onTap: () {
                              /*
                                                 rName = _receiverNameText.text.trim();
                                                 rPhone = _receiverPhoneNumberText.text.trim();
                                                 sName = _senderNameText.text.trim();
                                                 sPhone = _senderPhoneNumberText.text.trim();
                                                 Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                   return MapPickDropPage(
                                                     adressType: "destination",
                                                     index:n,
                                                   );
                                                 }));

                                               */
                            },

                            textInputAction: TextInputAction.next,
                            controller:
                                receiverdestinationTextControllerList[n],
                            readOnly: true,
                            // maxLength: 10,
                            // maxLengthEnforced: true,
                            style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: lightTextGrey,
                                    size: 19,
                                  ),
                                ),
                                hintText: "Find Receiver address from map",
                                hintStyle: GoogleFonts.poppins(
                                  color: lightTextGrey,
                                  fontSize: 14.0,
                                ),
                                border: InputBorder.none),
                          ),
                        ),

                      /*
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, left: 6, top: 10),
                              child: Text(
                                "Product Name",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white70),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3, right: 12),
                          decoration: BoxDecoration(
                            color: darkThemeBlue,
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: TextField(
                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            controller: productNameController[n],
                            keyboardType: TextInputType.name,
                            // maxLength: 10,
                            // maxLengthEnforced: true,
                            style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: lightTextGrey,
                                    size: 19,
                                  ),
                                ),
                                hintText: "Enter Product Name",
                                hintStyle: GoogleFonts.poppins(
                                  color: lightTextGrey,
                                  fontSize: 14.0,
                                ),
                                border: InputBorder.none),
                          ),
                        ),

                       */

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 5, left: 10, top: 10),
                              child: Text(
                                "Remarks/Any Cash Collect/Product Image",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.white70),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 3, right: 12),
                              decoration: BoxDecoration(
                                color: darkThemeBlue,
                                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              ),
                              child: TextField(
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                controller: remarksController[n],
                                keyboardType: TextInputType.name,
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                style: GoogleFonts.poppins(
                                    fontSize: 14.0,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500),
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                         // _showSelectionDialog1(context);
                                        },
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: lightTextGrey,
                                          size: 19,
                                        ),
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
                          ],
                        ),



                      ],
                    );
                  }),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        /*
                        if(receiverdestinationTextControllerList[0].text.length<2 || receiverphoneControllerList[0].text.length<2 || receivernameControllerList[0].text.length<1 )
                        {

                          Fluttertoast.showToast(
                              msg: "Please fill the current field before proceeding to fill the next field",
                              fontSize: 14,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);

                        }

                         */

                        setState(() {
                          print(numberOfReceivers);
                          _displayTextInputDialog(context, numberOfReceivers);
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0, top: 10),
                        child: Row(
                          children: [
                            Text(
                              'Add Receivers',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: orangeCol),
                            ),
                            Icon(
                              Icons.add,
                              color: orangeCol,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 10),
              child: ButtonTheme(
                /*__To Enlarge Button Size__*/
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    /*
                    if (_senderNameText.text.trim() == "" ||
                        _senderPhoneNumberText.text.trim() == "" ||
                       // _startingPointText.text.trim() == "" ||
                        _receiverNameText.text.trim() == "" ||
                        _receiverPhoneNumberText.text.trim() == "" ||
                        _destinationText.text.trim() == "" )
                    {
                      Fluttertoast.showToast(
                          msg: "Please fill all fields",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else if(_senderPhoneNumberText.text.trim().length<10 ){
                      Fluttertoast.showToast(
                          msg: "Please enter proper sender phone number",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_receiverPhoneNumberText.text.trim().length<10 ){
                      Fluttertoast.showToast(
                          msg: "Please enter proper receiver phone number",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }

                     */

                    /*
                      rName = _receiverNameText.text.trim();
                      rNameList.add(_receiverNameText.text.trim());


                      rPhone = _receiverPhoneNumberText.text.trim();
                      rPhoneList.add(_receiverNameText.text.trim());



                      sName = _senderNameText.text.trim();
                      sPhone = _senderPhoneNumberText.text.trim();

                       */

                    print(receiverdestinationTextControllerList.length);
                    print(numberOfReceivers);

                    for (int i = 0; i < numberOfReceivers; i++) {
                      print('executes');

                      print(receiverdestinationTextControllerList[i].text);

                      if (receiverdestinationTextControllerList[i]
                              .text
                              .trim() ==
                          "") {
                        setState(() {
                          incompleteAddress = true;
                        });
                      } else {
                        setState(() {
                          incompleteAddress = false;
                        });
                      }

                      if (receivernameControllerList[i].text.trim() == "") {
                        setState(() {
                          incompleteRName = true;
                        });
                      } else {
                        setState(() {
                          incompleteRName = false;
                        });
                      }

                      if (receiverphoneControllerList[i].text.trim().length <
                          10) {
                        setState(() {
                          incompleteRNumber = true;
                        });
                      } else {
                        setState(() {
                          incompleteRNumber = false;
                        });
                      }
                    }

                    if (incompleteAddress == true) {
                      Fluttertoast.showToast(
                          msg: "Please fill all the address fields",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else if (incompleteRName == true) {
                      Fluttertoast.showToast(
                          msg: "Please fill all the receiver name fields",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else if (incompleteRNumber == true) {
                      Fluttertoast.showToast(
                          msg:
                              "Please fill all the receiver number fields properly",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }

                    else if (numberOfReceivers == 0) {
                      Fluttertoast.showToast(
                          msg:
                          "Please add a receiver",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }

                    else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return PickDropPage03();
                      }));
                    }
                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child: Text("NEXT",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  // },
                  // ),
                ),
              ),
            ),

            /*

            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
              child: ButtonTheme(
                /*__To Enlarge Button Size__*/
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {

                    if (_senderNameText.text.trim() == "" ||
                        _senderPhoneNumberText.text.trim() == "" ||
                        _startingPointText.text.trim() == "" ||
                        _receiverNameText.text.trim() == "" ||
                        _receiverPhoneNumberText.text.trim() == "" ||
                        _destinationText.text.trim() == "" )
                    {
                      Fluttertoast.showToast(
                          msg: "Please fill all fields",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    } else if(_senderPhoneNumberText.text.trim().length<10 ){
                      Fluttertoast.showToast(
                          msg: "Please enter proper sender phone number",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_receiverPhoneNumberText.text.trim().length<10 ){
                      Fluttertoast.showToast(
                          msg: "Please enter proper receiver phone number",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else {

                      rName = _receiverNameText.text.trim();
                      rNameList.add(_receiverNameText.text.trim());

                      rPhone = _receiverPhoneNumberText.text.trim();
                      rPhoneList.add(_receiverNameText.text.trim());

                      sName = _senderNameText.text.trim();
                      sPhone = _senderPhoneNumberText.text.trim();
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return PickDropPage01();
                      }));
                    }

                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child: Text("Select Another Pickup", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  // },
                  // ),
                ),
              ),
            ),

             */
          ],
        ),
      ),
    ));
  }

  modalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (BuildContext context) {
        return MapPickDropPage(
          adressType: "pickup",
        );
      },
    );
  }
}

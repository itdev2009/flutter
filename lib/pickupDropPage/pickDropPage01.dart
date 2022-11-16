import 'dart:convert';
import 'dart:io';

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/loginMobile_screen/otpVerificationPage.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropPage02.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PickAndDropPage extends StatefulWidget {
  @override
  _PickAndDropPageState createState() => _PickAndDropPageState();
}

class _PickAndDropPageState extends State<PickAndDropPage> {
  @override
  Widget build(BuildContext context) {
    pickupAddress = userAddress;
    destinationAddress = "";
    pickUpLat = userLat;
    pickUpLong = userLong;
    dropLat = 0;
    droplong = 0;
    sName = userName;
    sPhone = userPhone;
    rName = "";
    rPhone = "";
    productName = "";
    productRemarks = "";
    baseImage = "";
    fileName = "";
    productWeight = "";
    vehicleType = "Two-Wheeler";
    paymentUserIndex=0;
    productPaymentUserIndex=0;
    vehicleIndex=0;
    paymentType="Cash Payment";
    productNameVisibility1=false;
    extraPersonRequired=false;
    productPaymentRequired=false;
    paymentUser="Sender";
    productPaymentUser="Sender";
    dateAndTime="";
    dateAndTimeFormated="";
    print(sName);
    return PickDropPage01();
  }
}



class PickDropPage01 extends StatefulWidget {
  @override
  _PickDropPage01State createState() => _PickDropPage01State();
}

class _PickDropPage01State extends State<PickDropPage01> {

  List<RadioModelData> categoryRadioData = new List<RadioModelData>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController=new TextEditingController();
  File file;
  bool itscake = false;
  final picker = ImagePicker();
  final Dio _dio = Dio();
  String userToken="";



  List<String> categoryBuyingDetails = [
    "WE CAN BUY FOR YOU",
    "WE CAN BUY FOR YOU",
    "100% SAFE DELIVERY",
    "WE WILL PICK FOR YOU",
    "WE WILL PICK FOR YOU",
    "WE WILL PICK FOR YOU"
  ];

  List<String> categoryName = [
    "Grocery",
    "Food / Dry Cake",
    "Cake",
    "Documents",
    "Medicines",
    "Others"
  ];
  List<String> categoryLogo = [
    "grocery.png",
    "food.png",
    "cake.png",
    "documents.png",
    "medicines.png",
    "others.png"
  ];

  int index=-1;
  TextEditingController _productNameText = new TextEditingController();
  TextEditingController _remarksText = new TextEditingController();
  bool loading = false;
  SharedPreferences prefs;
  String senderToken = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences forcake;
  BuildContext ctx;
  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    senderToken = prefs.getString("user_token");
    userToken=prefs.getString("user_token");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createSharedPref();
    for(int i=0;i<categoryName.length;i++) categoryRadioData.add(new RadioModelData(false,categoryName[i]));

  }





  @override
  Widget build(BuildContext context) {
   // loading==true?
   // Future.delayed(Duration.zero, () => _showSelectionDialog2(context))
 //   :
  //  print('NOT LOADING');




    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: lightThemeBlue,
        appBar: AppBar(
          backgroundColor: darkerThemeBlue,
          title: Text(
            "Pickup and Drop",
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(11.0,0.0,11.0,0.0),
          physics: ScrollPhysics(),

          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
              child: Text("What are you sending?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth*0.05,
                      color: Colors.white70)),
            ),


            Padding(
              // height: screenHeight*0.7,
              padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,11.0),
              child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: categoryLogo.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 60 / 75,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async{
                      itscake = false;
                      categoryRadioData.forEach((element) => element.isSelected = false);
                      categoryRadioData[index].isSelected = true;
                      index == 2 ? itscake = false : itscake = false;
                      index == 2 ? print('CAKE SELECTED') : print('Not cake');
                      forcake = await SharedPreferences.getInstance();
                     forcake.setBool('cakeprefs', itscake);
                      this.index=index;
                      setState(() {});
                    },
                    child: Card(
                      color: darkThemeBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(17.0))),
                      elevation: 5,
                      shadowColor: darkThemeBlue,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 10,
                                    top: 0,
                                    child: Icon(Icons.check_circle,color: (categoryRadioData[index].isSelected)?orangeCol:Colors.white30,size: 21,)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Image.asset(
                            "assets/images/icons/pickup_icons/${categoryLogo[index]}",
                            height: screenWidth*0.2,
                            width: screenWidth*0.2,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(categoryName[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth*0.041,
                                  color: Colors.white70)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(categoryBuyingDetails[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth*0.032,
                                  color: Colors.white70)),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Visibility(
              visible: (categoryName[(index==-1)?0:index]=="Others"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5,left: 6,top: 10),
                    child: Text(
                      "Product Name",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13,color: Colors.white70),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 3,right: 12),
                    decoration: BoxDecoration(
                      color: darkThemeBlue,
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _productNameText,
                      keyboardType: TextInputType.name,
                      // maxLength: 10,
                      // maxLengthEnforced: true,
                      style: GoogleFonts.poppins(fontSize: 14.0,color: Colors.white70,fontWeight: FontWeight.w500),
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Icon(Icons.person_outline,
                              color: lightTextGrey,
                              size: 19,),
                          ),
                          hintText: "Enter Product Name",
                          hintStyle: GoogleFonts.poppins(
                            color: lightTextGrey,
                            fontSize: 14.0,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 6,top: 10),
                  child: Text(
                    "Remarks/Any Cash Collect/Product Image",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13,color: Colors.white70),
                  ),
                ),
                Container(
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
                              _showSelectionDialog1(context);
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
              ],
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0 ,20),
              child: ButtonTheme(
                /*__To Enlarge Button Size__*/
                height: 50.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: () {
                    if (senderToken == "" || senderToken==null) {
                      modalSheetToLogin();
                      // Fluttertoast.showToast(
                      //     msg: "Please Login First to Proceed",
                      //     fontSize: 16,
                      //     backgroundColor: Colors.orange[100],
                      //     textColor: darkThemeBlue,
                      //     toastLength: Toast.LENGTH_LONG);
                    }else{
                      if(index==-1){
                        Fluttertoast.showToast(
                            msg: "Please Select Product Category",
                            fontSize: 16,
                            backgroundColor: Colors.orange[100],
                            textColor: darkThemeBlue,
                            toastLength: Toast.LENGTH_LONG);
                      }else{
                        if(index==5){
                          if(_productNameText.text=="" || _productNameText.text==null){
                            Fluttertoast.showToast(
                                msg: "Please Enter Product Name",
                                fontSize: 16,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          }else{
                            print("ekhne others er jnno hbe");
                            productName=_productNameText.text;
                            productRemarks=_remarksText.text;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return PickDropPage02();
                                }));
                          }

                        }else{
                          print("ekhne call hbe");
                          productName=categoryName[index];
                          productRemarks=_remarksText.text;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return PickDropPage02();
                              }));
                        }
                      }
                    }

                  },
                  color: orangeCol,
                  textColor: Colors.white,
                  child: Text("NEXT", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  // },
                  // ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  modalSheetToLogin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0),),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Please Login to Proceed",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Theme(
                  data: new ThemeData(
                    primaryColor: orangeCol,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    validator: (value)=> value.isEmpty?"*Phone Number Required":value.length<10?"*Please Enter Proper Phone Number":null,
                    controller: _phoneNumberController,
                    decoration: new InputDecoration(
                        labelText: "Enter Mobile Number",
                        prefixText: "+91 ",
                        prefixStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            color: orangeCol,
                            fontWeight: FontWeight.w500
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ),
                        fillColor: Colors.white,
                        focusColor: orangeCol,
                        hoverColor: orangeCol
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.poppins(
                        fontSize: 13.0,
                        color: orangeCol,
                        fontWeight: FontWeight.w500
                    ),),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: (){
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      print('Form is valid');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return OtpVerificationPage(phoneNumber: _phoneNumberController.text.trim(),
                            redirectPage: "pickDrop",);

                          }));
                    } else {
                      print('Form is invalid');
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    // margin: EdgeInsets.all(2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.white70,
                              // offset: Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white),
                    )

                  ),
                ),
                // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
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

  Future<void> _showSelectionDialog2(BuildContext context) {

    if(loading==true) {
      return showDialog(
          context: context,
          useRootNavigator: false,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Processing image"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      //   GestureDetector(
                      //    child: Text("Gallery"),
                      //    onTap: () {
                      //        _openGallery1(context);
                      //      },
                      //   ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      //   GestureDetector(
                      //    child: Text("Camera"),
                      //    onTap: () {
                      //     Addpicture(context);
                      //  },
                      Center(child: CircularProgressIndicator()),


                    ],
                  ),
                ));
          });
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
        FormData.fromMap({"filenames[]": filenames, "type": "product_image"});

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


            baseImage = res.data['data'].toString();
            int n = baseImage.length;
            baseImage = baseImage.substring(1, n - 1);
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
    }
    catch (e) {
      print(e.code);
    }

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
        FormData.fromMap({"filenames[]": filenames, "type": "product_image"});

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

            baseImage = res.data['data'].toString();
            int n = baseImage.length;
            baseImage = baseImage.substring(1, n - 1);
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
    }
    catch (e) {
      print(e.code);
    }


  }

}


class RadioModelData {
  bool isSelected;
  final String text;

  RadioModelData(this.isSelected,this.text);

}


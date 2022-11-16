import 'dart:io';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/pickupDropPage/mapForPickDrop.dart';
import 'package:delivery_on_time/profile_screen/bloc/profileUpdateBloc.dart';
import 'package:delivery_on_time/profile_screen/model/profileUpdateModel.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ProfileManagePage extends StatefulWidget {
  @override
  _ProfileManagePageState createState() => _ProfileManagePageState();
}

class _ProfileManagePageState extends State<ProfileManagePage> {


  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;


  SharedPreferences prefs;
  String name="";
  String email="";
  String userId="";
  String userToken="";
  String userPhone="";
  String userPhoto="";




  File imageFile1;
  final Dio _dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProfileUpdateBloc _profileUpdateBloc;
  bool updateCheck=false;


  void initState() {
    super.initState();
    _profileUpdateBloc=new ProfileUpdateBloc();
    createSharedPref();
  }

  Future<void> createSharedPref() async {

    prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id");
    name=prefs.getString("name");
    email=prefs.getString("email");
    userToken=prefs.getString("user_token");
    userPhone=prefs.getString("user_phone");
    userPhoto=prefs.getString("user_photo");
    user_address = prefs.getString("user_address") == null? "" :  prefs.getString("user_address");
    user_lat = prefs.getString("user_latitude") == null? "" :  prefs.getString("user_latitude") ;
    user_long = prefs.getString("user_longitude") == null? "" : prefs.getString("user_longitude") ;
    print(prefs.getString("name"));
    _nameController=new TextEditingController(text: "$name");
    _emailController=new TextEditingController(text: "$email");
    _phoneController=new TextEditingController(text: "$userPhone");
    addressController=new TextEditingController(text: "$user_address");

    setState(() {});
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
        return HomeController(currentIndex: 5,);
      }));
    });
  }

  Future<void> managedSharedPref(ProfileUpdateModel data) async {

    prefs.setString("name", "${data.data.name??""}");
    prefs.setString("email", "${data.data.email??""}");
    prefs.setString("user_phone", "${data.data.mobileNumber}");
    prefs.setString("user_photo", "${data.data.profilePic}");

    prefs.setString("user_address", "${data.data.address}");
    prefs.setString("user_latitude", "${data.data.latitude}");
    prefs.setString("user_longitude", "${data.data.longitude}");

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              // height: screenHeight * 0.26,
              child: Column(
                children: [
                  //Upper Container with Address and icons....
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0,20),
                    child: Text(
                      "UPDATE PROFILE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 20),
                        padding: EdgeInsets.all(3),
                        height: 92,
                        width: 92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _buildImage1(),
                      ),
                      InkWell(
                        onTap: (){
                          _showSelectionDialog1(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 70, left: 75),
                          height: 31,
                          width: 31,
                          decoration:
                          BoxDecoration(color: orangeCol, shape: BoxShape.circle),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),
                ],
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: lightThemeBlue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
              ),
              // child: child,
            ),
            SizedBox(height: 20,),
            Card(
              margin: EdgeInsets.fromLTRB(12, 10, 12 ,10),
              // padding: EdgeInsets.all(10.0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Theme(
                        data: new ThemeData(
                          primaryColor: orangeCol,
                          primaryColorDark: Colors.black,
                        ),
                        child: TextFormField(
                          validator: (value)=> value.isEmpty?"*Name Required":null,
                          controller: _nameController,
                          decoration: new InputDecoration(
                            suffixIcon: Icon(Icons.edit_outlined,
                            size: 18,
                            color: orangeCol,),
                              labelText: "Full Name",
                              labelStyle: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400
                              ),
                              fillColor: Colors.white,
                              focusColor: orangeCol,
                              hoverColor: orangeCol
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              color: orangeCol,
                              height: 1,
                              fontWeight: FontWeight.w500
                          ),),
                      ),

                      SizedBox(height: 12,),

                      Theme(
                        data: new ThemeData(
                          primaryColor: orangeCol,
                          primaryColorDark: Colors.black,
                        ),
                        child: TextFormField(
                          // validator: (value)=> value.isEmpty?"*Email ID Required":null,
                          controller: _emailController,
                          decoration: new InputDecoration(
                              suffixIcon: Icon(Icons.edit_outlined,
                                size: 18,
                                color: orangeCol,),
                              labelText: "Email ID",
                              labelStyle: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400
                              ),
                              fillColor: Colors.white,
                              focusColor: orangeCol,
                              hoverColor: orangeCol
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              color: orangeCol,
                              height: 1,
                              fontWeight: FontWeight.w500
                          ),

                        ),
                      ),


                      SizedBox(height: 12,),


                      Theme(

                        data: new ThemeData(
                          primaryColor: orangeCol,
                          primaryColorDark: Colors.black,
                        ),
                        child: Container(
                          height: 55.0,
                         // alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 3, right: 4),
                          decoration: BoxDecoration(
                            //color: darkThemeBlue,
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                          child: TextFormField(
                            onTap: () {

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) {
                                    return MapPickDropPage(
                                      adressType: "user_settings",
                                      index: 0,
                                    );
                                  }));
                            },

                            textInputAction: TextInputAction.next,
                            controller: addressController,
                            readOnly: true,
                            // maxLength: 10,
                            // maxLengthEnforced: true,
                            style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                color: orangeCol,
                                //height: 1,
                                fontWeight: FontWeight.w500
                            ),

                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              //contentPadding: EdgeInsets.zero,

                              contentPadding: EdgeInsets.only(right: 10),

                                  labelText: "Your Address",

                              labelStyle: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400
                              ),

                                  fillColor: Colors.white,
                                  focusColor: orangeCol,
                                  hoverColor: orangeCol,

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(left:8.0),
                                  child: Icon(Icons.edit_outlined,
                                    size: 18,
                                    color: orangeCol,),
                                ),

                                hintText: "Select your address from map",
                                hintStyle: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    color: orangeCol,
                                    fontWeight: FontWeight.w400
                                ),

                               // border: InputBorder.none
                            ),
                          ),
                        ),
                      ),



                      SizedBox(height: 12,),

                      Theme(
                        data: new ThemeData(
                          primaryColor: orangeCol,
                          primaryColorDark: Colors.black,
                        ),
                        child: TextField(
                          controller: _phoneController,
                          readOnly: true,
                          decoration: new InputDecoration(
                              labelText: "Mobile No.",
                              labelStyle: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400
                              ),
                              fillColor: Colors.white,
                              // focusColor: orangeCol,
                              // hoverColor: orangeCol
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              color: orangeCol,
                              height: 0.8,
                              fontWeight: FontWeight.w500
                          ),),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12 ,10),
              child: InkWell(
                onTap: (){
                  final FormState form = _formKey.currentState;
                  if (form.validate()) {
                    print('Form is valid');
                    Map body;
                    if(email!=_emailController.text.trim()){
                      if(EmailValidator.validate(
                          _emailController.text.trim())){
                        body={
                          "name":"${_nameController.text.trim()}",
                          "email":"${_emailController.text.trim()}",
                          "user_id":"$userId",
                          "address":"$user_address",
                          "latitude":"$user_lat",
                          "longitude":"$user_long"

                                   };
                        updateCheck=true;
                        _profileUpdateBloc.profileUpdate(body, imageFile1, userToken);
                      }else{
                        Fluttertoast.showToast(
                            msg: "Please Enter Correct Email ID",
                            fontSize: 16,
                            backgroundColor: Colors.orange[100],
                            textColor: darkThemeBlue,
                            toastLength: Toast.LENGTH_LONG);
                      }

                    }else{
                      body={
                        "name":"${_nameController.text.trim()}",
                        "user_id":"$userId",
                        "address":"$user_address",
                        "latitude":"$user_lat",
                        "longitude":"$user_long"
                      };
                      updateCheck=true;
                      _profileUpdateBloc.profileUpdate(body, imageFile1, userToken);
                    }
                  } else {
                    print('Form is invalid');
                    Fluttertoast.showToast(
                        msg: "Please fill required fields",
                        fontSize: 16,
                        backgroundColor: Colors.orange[100],
                        textColor: darkThemeBlue,
                        toastLength: Toast.LENGTH_LONG);
                  }
                },
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(2),
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
                  child: StreamBuilder<ApiResponse<ProfileUpdateModel>>(
                    stream: _profileUpdateBloc.profileUpdateStream,
                    builder: (context, snapshot) {
                      if(updateCheck){
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
                              if (snapshot.data.data.message == "Profile updated successfully")
                              {
                                print("complete");
                                updateCheck=false;
                                managedSharedPref(snapshot.data.data);
                                navToAttachList(context);
                                Fluttertoast.showToast(
                                    msg: "Profile Updated",
                                    fontSize: 16,
                                    backgroundColor: Colors.white,
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "${snapshot.data.data.message}",
                                    fontSize: 16,
                                    backgroundColor: Colors.white,
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);
                              }
                              break;
                            case Status.ERROR:
                              print(snapshot.error);
                              updateCheck=false;
                              Fluttertoast.showToast(
                                  msg: "Please try again!",
                                  fontSize: 16,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                              //   Error(
                              //   errorMessage: snapshot.data.message,
                              // );
                              break;
                          }
                        }
                        else if (snapshot.hasError) {
                          updateCheck=false;
                          print(snapshot.error);
                          Fluttertoast.showToast(
                              msg: "Please try again!",
                              fontSize: 16,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);
                        }
                      }
                      return Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w500, color: Colors.white),
                      );
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
                        _openCamera1(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery1(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 30);

    this.setState(() {
      if (imageFile1 == null)
        print("img null");
      else
        print("img not null");
      imageFile1 = picture;
    });
    Navigator.of(context).pop();
  }

  void _openCamera1(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 30);
    this.setState(() {
      imageFile1 = picture;
    });
    Navigator.of(context).pop();
  }

  _buildImage1() {
    if (imageFile1 != null) {
      // uploadFile1(imageFile1);
      return Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
              child: Image.file(
                imageFile1,
                fit: BoxFit.cover,
              )));
    } else {
      return Container(
          height: 90,
          width: 90,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle),
          child: FadeInImage(
        height: 180.0,
        width: 130.0,
        image: NetworkImage(
          "${(userPhoto=="" || userPhoto=="null")?"${imageBaseURL}null":"$imageBaseURL$userPhoto"}",
        ),
        placeholder: AssetImage("assets/images/icons/profile.png"),
        fit: BoxFit.fill,
      ),
        // child: Image.asset("asset/blank-profile-picture-973460_1280.webp")
      );
    }
  }

  uploadFile1(File imageFile1) async {
    print(imageFile1.path);
    var filenames = await MultipartFile.fromFile(File(imageFile1.path).path,
        filename: imageFile1.path);

    FormData formData =
    FormData.fromMap({"filenames[]": filenames, "type": "category"});

    print(formData);

    Response res = await _dio.post(ApiBaseHelper.baseUrl + "upload/image",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer " + userToken}));

    //print(res.data);
   // print(res.runtimeType);
    print(res.data['data']);

    print('to string:');
    print(res.data[0].toString());
  }


}

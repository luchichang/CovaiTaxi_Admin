import 'package:admin_app/dashboard/dashHome.dart';
import 'package:admin_app/model/bookingModel.dart';
import 'package:admin_app/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:admin_app/model/driverDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email, password;

//by K
  TextEditingController emailC = TextEditingController(text: ''),
      passC = TextEditingController(text: '');

// by D
  TextEditingController uname_C = TextEditingController(text: ''),
      passwr_C = TextEditingController(text: '');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDoc();
  }

  Map<String, dynamic> data;

  DriverDetails driverDetails;

  List<DriverDetails> list = [];

  getDoc() {
    Firestore.instance
        .collection('UserDetails')
        // .where('docsUploaded', '==', true)
        .document('HLpZKdhMjCbpKUqu8FX3Qx5Ob1V2')
        .collection('bookings')
        .document('2021-03-15 16:30:24.513195')
        .get()
        .then((value) {
      if (!value.exists) {
        print('No Driver requested');
      } else {
        data = value.data;
        // print(json.encode(data));
        // print(value.data());

        BookingInfo bookingInfo = BookingInfo.fromJson(value.data);
        print(bookingInfo.carType);

        /*   setState(() {
          data = value.docs.first.data();
        }); */
      }
    });
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passC,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          /* removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError); */
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          // addError(error: kPassNullError);
          return "error";
        } else if (value.length < 8) {
          // addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailC,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          /*  removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError); */
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          print('errror');
          return "enter ";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width; //used by ka
    var defaultSize = height * 0.05;
    var defaultPadding = 16;

    // used by d
    var hei = screenSize.height;
    var wid = screenSize.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blueAccent.withOpacity(0.4)));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: buildGradientAppBar('Admin Panel'),
      // body: Padding(
      //   padding: const EdgeInsets.all(38.0),
      //   child: Container(
      //     padding: const EdgeInsets.all(28.0),
      //     height: height * 0.8,
      //     // color: Colors.indigoAccent.shade100,
      //     decoration: BoxDecoration(
      //         gradient: FlutterGradients.amourAmour(tileMode: TileMode.clamp),
      //         borderRadius: BorderRadius.circular(30)),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Center(
      //             child: Text(
      //               'Login.',
      //               style: title.copyWith(fontSize: 40, color: Colors.white),
      //             ),
      //           ),
      //           SizedBox(height: defaultSize),
      //           buildEmailFormField(),
      //           buildPasswordFormField(),
      //           SizedBox(height: defaultSize),
      //           Container(
      //               child: DefaultButton(
      //             onPressed: () {
      //               if (emailC.text.isEmpty || passC.text.isEmpty) {
      //                 Fluttertoast.showToast(
      //                     msg: 'Please enter correct password/username');
      //               } else {
      //                 Navigator.push(context,
      //                     MaterialPageRoute(builder: (context) => DashNewUI()));
      //               }
      //             },
      //             height: height,
      //             color: Colors.amberAccent,
      //             width: width,
      //             title: 'Next',
      //           ))
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      //  by D
      backgroundColor: Constants.primary_color,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: hei * 0.3,
            // we have to declare the width in the positioned widget also the reason is it will take the width as infinity
            width: wid,
            child: Container(
              height: hei * 0.47,
              width: wid,
              margin: EdgeInsets.only(left: wid * 0.1, right: wid * 0.1),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: hei * 0.05,
                  ),
                  // Custom_Text_field(),
                  TextFormField(
                    controller: uname_C,
                    decoration: InputDecoration(
                        hintText: 'for ex: Admin',
                        alignLabelWithHint: false,
                        labelText: 'Username',
                        labelStyle: subheading,
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        hintStyle: subheading2),
                    textAlignVertical: TextAlignVertical.top,
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: hei * 0.01,
                  ),
                  TextFormField(
                    style: label_text,
                    controller: passwr_C,
                    decoration: InputDecoration(
                        hintStyle: subheading2,
                        hintText: 'for ex: admin@123',
                        labelStyle: subheading,
                        suffixIcon: Icon(Icons.remove_red_eye),
                        labelText: 'Password'),
                    maxLength: 16,
                    maxLines: 1,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(
                    height: hei * 0.03,
                  ),
                  InkWell(
                    onTap: () {
                      if (uname_C.text.isEmpty || passwr_C.text.isEmpty) {
                        // Fluttertoast.showToast(msg: 'value is .empty');
                        Flushbar(
                          title: 'Error',
                          flushbarPosition: FlushbarPosition.BOTTOM,
                          icon: Icon(
                            Icons.warning,
                            color: Colors.amber,
                            size: 30.0,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          message: 'please enter a value',
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Navigating to home screen');

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashNewUI()));
                      }
                    },
                    child: Container(
                      height: hei * 0.08,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: FlutterGradients.morpheusDen()),
                      child: Row(
                        children: [
                          SizedBox(
                            width: wid * 0.27,
                          ),
                          Text(
                            'Login',
                            style: subheading.copyWith(
                                color: Colors.white, fontSize: 22.0),
                          ),
                          SizedBox(
                            width: wid * 0.09,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 28.0,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            height: 100,
            width: 100,
            left: wid * 0.38,
            top: hei * 0.2,
            child: CircleAvatar(
              //   backgroundImage: AssetImage(''),
              radius: 40.0,
            ),
          )
        ],
      ),
    );
  }
}

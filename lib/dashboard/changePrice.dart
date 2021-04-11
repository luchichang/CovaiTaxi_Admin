import 'package:admin_app/dashboard/dashHome.dart';
import 'package:admin_app/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class ChangeKmPrice extends StatefulWidget {
  @override
  _ChangeKmPriceState createState() => _ChangeKmPriceState();
}

class _ChangeKmPriceState extends State<ChangeKmPrice> {
  @override
  void initState() {
    super.initState();
    // setPrice();
    getPrice();
  }

  getPrice() async {
    await Firestore.instance
        .collection('carPrices')
        .document('price')
        .get()
        .then((value) {
      print(value.data);
      hatchPrice.text = value.data['hatchPrice'];
      sedanPrice.text = value.data['sedanPrice'];
      suvPrice.text = value.data['suvPrice'];
    });
  }

  setPrice() async {
    await Firestore.instance.collection('carPrices').document('price').setData({
      'sedanPrice': sedanPrice.text,
      'hatchPrice': hatchPrice.text,
      'suvPrice': suvPrice.text,
    }).then((value) {
      print('ss');
    });
  }

  TextEditingController sedanPrice = TextEditingController(text: '13'),
      hatchPrice = TextEditingController(text: '15'),
      suvPrice = TextEditingController(text: '17');
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;

    var hei = screenSize.height;
    var wid = screenSize.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildGradientAppBar('Price updation', Constants.primary_color),

      // by k

      /*  body: Container(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(28.0),
            color: Colors.cyan,
            height: height * 0.8,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Enter the amount to update in customer app',
                    textAlign: TextAlign.center,
                    style: title,
                  ),
                ),
                SizedBox(height: defaultSize),
                buildPriceField(hatchPrice, "Hatchback"),
                SizedBox(height: defaultSize),
                buildPriceField(sedanPrice, "Sedan"),
                SizedBox(height: defaultSize),
                buildPriceField(suvPrice, "SUV"),
                SizedBox(height: defaultSize),
                DefaultButton(
                  width: width,
                  height: height,
                  title: 'Submit',
                  color: Colors.amberAccent,
                  onPressed: () {
                    if (hatchPrice.text == '' ||
                        suvPrice.text == '' ||
                        sedanPrice.text == '') {
                      Fluttertoast.showToast(
                          msg: "Please enter the amount properly",
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white);
                    } else {
                      setPrice();

                      Fluttertoast.showToast(
                          msg: "Price Updated Success",
                          backgroundColor: Colors.green,
                          textColor: Colors.white);
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ); */

      // by D

      backgroundColor: Constants.primary_color,

      body: Container(
        height: hei,
        width: wid,
        child: Align(
          child: Container(
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            height: hei * 0.6,
            width: wid,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 80,
                      offset: Offset(0, 20),
                      spreadRadius: -50)
                ]),

                child: Column(
                  children: <Widget>[
                    
                    SizedBox(
                      height: hei*0.1,
                    ),
                    
                  ],
                ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPriceField(var controller, var titles) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      // onSaved: (newValue) => sedanPrice = newValue,
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
        labelText: "$titles",
        hintText: "Enter your $titles price",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

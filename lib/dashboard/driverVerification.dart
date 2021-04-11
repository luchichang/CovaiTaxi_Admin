import 'package:admin_app/dashboard/dashHome.dart';
import 'package:admin_app/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/driverDetail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'displayDriverProof.dart';

class DriverVerification extends StatefulWidget {
  // final Map<String, dynamic> data;
  final List<DriverDetails> driverDetails;

  const DriverVerification({Key key, this.driverDetails}) : super(key: key);

  @override
  _DriverVerificationState createState() => _DriverVerificationState();
}

class _DriverVerificationState extends State<DriverVerification> {
  // final List<DriverDetails> driver;

  // _DriverVerificationState(this.driver);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDrivers();
  }

  DriverDetails driverDetails;

  List<DriverDetails> driver = [];

  getDrivers() {
    Firestore.instance
        .collection('DriverDetails')
        .where('isAdminVerified', isEqualTo: false)
        .getDocuments()
        .then((value) {
      if (value.documents.isEmpty) {
        print('No Driver requested');
      } else {
        value.documents.forEach((element) {
          // print(element.data()['name']);
          setState(() {
            driverDetails = DriverDetails.fromJson(element.data);
            driver.add(driverDetails);
          });

          print(driverDetails.name);
          print(driver.length);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    print('driver data ${widget.driverDetails.length}');
    return Scaffold(
        appBar: buildGradientAppBar('New Drivers', Colors.amber),
        body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(20),
          child: ListView.separated(
              separatorBuilder: (c, i) => Divider(),
              itemCount: driver.length,
              itemBuilder: (c, i) {
                return Container(
                  height: height * 0.3,
                  width: width * 0.8,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xff0077FF),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // SizedBox(height: defaultSize),
                      Text(
                        'Proof'.toString().toUpperCase() ??
                            'GET STARTED'.toUpperCase(),
                        style: GoogleFonts.gothicA1(
                            letterSpacing: 5,
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage: driver[i].profileImage != null
                                  ? NetworkImage(driver[i].profileImage)
                                  : AssetImage('assets/images/logo.png')),
                          SizedBox(width: defaultSize),
                          Text(
                            driver[i].name.toUpperCase(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        "${driver[i].carName ?? ''} - " +
                            "${driver[i].carNumber ?? ''}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        driver[i].carType ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      DefaultButton(
                          width: width,
                          height: height,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DisplayProofs(
                                          driverDetails: driver[i],
                                        )));
                          },
                          title: 'Verify'),
                    ],
                  ),
                );
              }),
        ));
  }
}

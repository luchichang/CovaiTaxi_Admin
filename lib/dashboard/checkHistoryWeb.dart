import 'package:admin_app/dashboard/viewAllDetails.dart';
import 'package:admin_app/model/bookingModel.dart';
import 'package:admin_app/model/driverDetail.dart';
import 'package:admin_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';
import 'confrimBooking.dart';

class RideHistoryPage extends StatefulWidget {
  static final String routeName = "ride-history-page";

  @override
  _RideHistoryPageState createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  String from, to, phone;

  // BasicController basicController = Get.put(BasicController());

  /*  getDocuments() async {
   /*  var users = await controller.getCurrentUser();
    var docId = controller.getCurrentBookingInfo();
 */
    setState(() {
      user = users;
    });

    /* await Firestore.instance
        .collection('BookingDetails')
        .document('UserID')
        .get()
        .then((isAssigned) {
      setState(() {
        from = value.data['from'];
        to = value.data['to'];
        phone = value.data['phone'];
      });
    }); */

    await DatabaseService()
        .userDetailRef
        .document(users.uid)
        .collection("bookings")
        .orderBy('createdAt')
        .getDocuments()
        .then((value) {
      /* value.documents.forEach((element) {
            
          }) */
    });
  }

  var stream;
 */

  var driverLoc;

  List<DriverDetails> driversList = [];

  List<LatLng> latlngDriver = [
    LatLng(11.89, 78.123),
  ];

  getDatabase() async {
    // imageData = await getMarker();

    /*  await Firestore.instance
        .collection('BookingDetails')
        .orderBy('createdAt')
        .getDocuments()
        // .collection("bookings")

        // .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        BookingInfo it = BookingInfo.fromJson(element.data);

        setState(() {
          historyList.add(it);
        });
        print(historyList.length);
      });
    }); */

    await Firestore.instance
        .collection('DriverDetails')

        // .where('docsUploaded', '==', true)
        .getDocuments()
        .then((value) {
      if (value.documents.isEmpty) {
        print('no loc');
      } else {
        value.documents.forEach((element) {
          /* setState(() {
            driverLoc = element.data()['position']['geopoint'];
          }); */
          // print("driverLOCC" + driverLoc.latitude.toString());

          var data = DriverDetails.fromJson(element.data);

          print(data.location.latitude);

          setState(() {
            driversList.add(data);
            /* latlngDriver.add(LatLng(element.data()['location'].latitude,
                element.data()['location'].longitude)); */
          });

          print("LATLNG ${latlngDriver.length}");
          // print(element.data()['position']['geopoint'].latitude);
          // print(element.data()['name']);
/* 
          driverDetails = DriverDetails.fromJson(element.data());
          print(driverDetails.name);
          list.add(driverDetails);
          print(list.length); */
        });
        /*  setState(() {
          data = value.docs.first.data();
        }); */
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getDatabase();
  }

  List<BookingInfo> historyList = [];

  bool isAssigned = false;

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: Get.height * 0.1,
        // automaticallyImplyLeading: false,
        actions: [
          Switch(
              autofocus: true,
              inactiveTrackColor: Colors.blue,
              inactiveThumbColor: Colors.amberAccent,
              // activeColor: Colors.amberAccent,
              activeTrackColor: Colors.amberAccent,
              value: isAssigned,
              onChanged: (e) {
                setState(() {
                  isAssigned = !isAssigned;
                });
              })
        ],
        title: Text(
          isAssigned ? "Assigned Bookings" : "New Bookings",
          style: CustomStyles.cardBoldTextStyle
              .copyWith(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('BookingDetails')
              .where('isAssigned', isEqualTo: isAssigned)
              .orderBy('createdAt')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              historyList = [];

              print(snapshot.data.documents[0].data);

              var items = snapshot.data.documents;
              items.forEach((element) {
                BookingInfo it = BookingInfo.fromJson(element.data);

                historyList.add(it);
              });

              print(historyList.length);

              return Stack(
                children: <Widget>[
                  Container(
                    width: mQ.width,
                    height: mQ.height,
                    decoration: BoxDecoration(
                        gradient: FlutterGradients.happyFisher(
                            tileMode: TileMode.clamp,
                            startAngle: 425,
                            type: GradientType.linear,
                            center: Alignment.centerRight,
                            endAngle: 180)),
                  ),
                  // NoLogoHeaderWidget(height: mQ.height * 0.5),
                  Positioned(
                      top: mQ.height * 0.05,
                      left: 5,
                      right: 5,
                      child: Container(
                          height: mQ.height * 0.8,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RideHistoryWidget(
                                  from: historyList[index].from,
                                  to: historyList[index].to,
                                  phone: historyList[index].custPhone,
                                  date: historyList[index].bookedTime,
                                  bookingInfo: historyList[index],
                                  driverLoc: latlngDriver,
                                  driverList: driversList,
                                ),
                              );
                            },
                            itemCount: historyList.length,
                          ))),
                  /* Positioned(
                    top: 50.0,
                    left: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.white,
                          textColor: Colors.green,
                          child: Icon(
                            Icons.arrow_back,
                            size: 15,
                          ),
                          padding: EdgeInsets.all(6),
                          shape: CircleBorder(),
                        ),
                        Text(
                          isAssigned ? "Assigned Bookings" : "New Bookings",
                          style: CustomStyles.cardBoldTextStyle
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ), */
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(
                    child: Container(
                  child: Text(
                    'There is a problem while getting the database. Please try again later',
                    style: title,
                    textAlign: TextAlign.center,
                  ),
                )),
              );
            } else if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitThreeBounce(
                  color: Constants.primaryColor,
                ),
              );
            } else {
              return Center(
                child: SpinKitThreeBounce(
                  color: Constants.primaryColor,
                ),
              );
            }
          }),
    );
  }
}

class RideHistoryWidget extends StatelessWidget {
  final String from;
  final String to;
  final String phone;
  final String date;
  final List<LatLng> driverLoc;
  final List<DriverDetails> driverList;

  final BookingInfo bookingInfo;

  const RideHistoryWidget(
      {Key key,
      this.from,
      this.to,
      this.phone,
      this.date,
      this.bookingInfo,
      this.driverLoc,
      this.driverList})
      : super(key: key);
  _buildRideInfo(String point, String title, String subtitle, Color color,
      Size screenSize) {
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.solidDotCircle,
              size: 12,
              color: color,
            ),
          ],
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.65),

              // width: Get.width,
              child: Text('$point - $title',
                  overflow: TextOverflow.ellipsis,
                  style: CustomStyles.smallLightTextStyle),
            ),
            SizedBox(
              height: 3,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.68),
              child: Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: CustomStyles.normalTextStyle,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(RideDetailsPage.routeName);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmBookingScreen(
                    estimatedDistance: bookingInfo.estimatedDistance,
                    estimatedPrice: bookingInfo.totalAmount,
                    estimatedTime: bookingInfo.totalTravelingTime,
                    from: bookingInfo.from,
                    to: bookingInfo.to,
                    trip: bookingInfo.trip,
                    type: bookingInfo.carType,
                    kmPrice: bookingInfo.kmPrice,
                    bookedDate: bookingInfo.bookedTime,
                    noOfDays: bookingInfo.days,
                    docId: bookingInfo.docId)));
      },
      onLongPress: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RideDetailsPage(
                      bookingInfo: bookingInfo,
                      driverLocation: driverLoc,
                      drivers: driverList,
                    )));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                  child: _buildRideInfo(
                      "From",
                      "${from}",
                      "${from.substring(0, from.indexOf(','))}",
                      Colors.green,
                      screenSize),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5),
                    child: _buildRideInfo(
                        "To",
                        "${to}",
                        "${to.substring(0, to.indexOf(','))}",
                        Colors.red,
                        screenSize)),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.phone),
                    Text("$phone",
                        style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Constants.primaryColor)),
                    Text(
                      '$date',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        margin: EdgeInsets.only(left: 25, right: 25),
        height: 185,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0x33303030),
              offset: Offset(0, 5),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
      ),
    );
  }
}

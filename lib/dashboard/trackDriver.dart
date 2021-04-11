import 'dart:async';
import 'dart:typed_data';
import 'package:admin_app/constants.dart';
import 'package:admin_app/dashboard/confrimBooking.dart';
import 'package:admin_app/dashboard/dashHome.dart';
import 'package:admin_app/model/bookingModel.dart';
import 'package:admin_app/model/driverDetail.dart';
import 'package:admin_app/styles.dart';
import 'package:admin_app/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart' as url;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../money.dart';

class DriverTracking extends StatefulWidget {
  final BookingInfo bookingInfo;
  final List<LatLng> driverLocation;
  final List<DriverDetails> drivers;

  const DriverTracking(
      {Key key, this.bookingInfo, this.driverLocation, this.drivers})
      : super(key: key);
  @override
  _DriverTrackingState createState() =>
      _DriverTrackingState(drivers, bookingInfo);
}

class _DriverTrackingState extends State<DriverTracking> {
  var latlng = LatLng(11.004556, 77.861632);

  final BookingInfo bookingInfo;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  bool isMapCreated = false;
  final Key _mapKey = UniqueKey();
  Set<Marker> _markers = {};
  // LatLng _center = LatLng(23.63936, 68.14712);

  String _mapStyle;
  BitmapDescriptor _mylocation;
  BitmapDescriptor _taxilocation;
  BitmapDescriptor carLocation;
  LatLng _initialCameraPosition;
  LatLng _destinationPosition;

  LatLng myLocation;

  LatLngBounds bound;

  List<LatLng> latlngDriver = [
    LatLng(12.98, 76.123),
  ];

  var driverLoc;

  // List<LatLng> latlngDriver;
  final List<DriverDetails> drivers;

  _DriverTrackingState(this.drivers, this.bookingInfo);

  Firestore _firestore = Firestore.instance;
  Uint8List imageData;

  List<DriverDetails> driversList = [];

  BookingInfo updatedData;

  getDatabase() async {
    // imageData = await getMarker();

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
            print(driversList.first.name);
            /* latlngDriver.add(LatLng(element.data()['location'].latitude,
                element.data()['location'].longitude)); */
          });

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

  void _onMapCreated(GoogleMapController controller) {
    print("IN CREATED " + latlngDriver.toString());
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    mapController = controller;

    controller.setMapStyle(_mapStyle);
    setState(() {
      _markers.clear();
      /*  addMarker(
          LatLng(bookingInfo.fromLoc.latitude, bookingInfo.fromLoc.longitude),
          "PickUp",
          "${bookingInfo.from}",
          _taxilocation,
          false);
      addMarker(LatLng(bookingInfo.toLoc.latitude, bookingInfo.toLoc.longitude),
          "Destination", "${bookingInfo.to}", _mylocation, false); */

      // LatLng(latlng)

      driversList.forEach((element) {
        addDriverMarker(
            LatLng(element.location.latitude, element.location.longitude),
            "${element.name}",
            "${element.carNumber}\n${element.phoneNum}",
            carLocation,
            element);
      });

      /* addDriverMarker(LatLng(latlngDriver.latitude, latlngDriver.longitude),
          "Driver", "Ramesh Kumar\n+918271387483", carLocation, true); */

      /* _markers.add(Marker(
          markerId: MarkerId("home"),
          position: latlng,
          // rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Driver Name : Rajesh"),
                      content: Column(
                        children: <Widget>[
                          Text("Walllet balance : Rs.500"),
                          DefaultButton(
                            height: height,
                            width: width,
                          ),
                        ],
                      ),
                    ));
          },
          infoWindow:
              InfoWindow(snippet: 'Driver', title: 'Rajesh', onTap: () {}),
          visible: true,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData))); */
    });

    _controller.complete(controller);
  }

  /*  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/car_icon.png");

    setState(() {
      imageData = byteData.buffer.asUint8List();
    });
    return byteData.buffer.asUint8List();
  }
 */
  var rating = 9.1;

  bool isUpdated = false;

  updateBookingInfo(DriverDetails dr) async {
    await _firestore.runTransaction((transaction) async {
      DocumentReference userDocRef = _firestore
          .collection('UserDetails')
          .document(bookingInfo.custUID)
          .collection("bookings")
          .document(bookingInfo.docId);
      DocumentReference bookingDocRef =
          _firestore.collection('BookingDetails').document(bookingInfo.docId);

      await transaction.update(
        userDocRef,
        {
          'driverName': dr.name,
          'driverPhone': dr.phoneNum,
          'isAssigned': true,
          'driverRatings': dr.ratings,
          'driverLocation':
              GeoPoint(dr.location.latitude, dr.location.longitude),
        },
      );
      await transaction.update(
        bookingDocRef,
        {
          'driverName': dr.name,
          'driverPhone': dr.phoneNum,
          'isAssigned': true,
          'driverRatings': dr.ratings,
          'driverLocation':
              GeoPoint(dr.location.latitude, dr.location.longitude),
        },
      );
      setState(() {
        isUpdated = true;
        updatedData = BookingInfo(
          driverName: dr.name,
          isAssigned: true,
          driverPhone: dr.phoneNum,
          assignedTo: dr.name,
          carType: dr.carNumber,
          days: dr.profileImage,
          // currentLoc: GeoPoint(dr.location.latitude, dr.location.longitude),
          createdAt: DateTime.now().toIso8601String(),
          status: 'Driver Assigned',
        );
      });
      Fluttertoast.showToast(msg: 'SDJSADHDHKSD');
    });

    print("booking id${bookingInfo.custUID}");
    /*  Firestore.instance
        .collection('UserDetails')
        .document(bookingInfo.custUID)
        .collection("bookings")
        .document(bookingInfo.docId)
        .updateData(
      {
        'driverName': dr.name,
        'driverPhone': dr.phoneNum,
        'isAssigned': true,
        'driverRatings': dr.ratings,
        'driverLocation': GeoPoint(dr.location.latitude, dr.location.longitude),
      },
    ).then((value) {
      setState(() {
        isUpdated = true;
        updatedData = BookingInfo(
          driverName: dr.name,
          isAssigned: true,
          driverPhone: dr.phoneNum,
          assignedTo: dr.name,
          carType: dr.carNumber,
          days: dr.profileImage,
          // currentLoc: GeoPoint(dr.location.latitude, dr.location.longitude),
          createdAt: DateTime.now().toIso8601String(),
          status: 'Driver Assigned',
        );
      });
      Fluttertoast.showToast(msg: 'SDJSADHDHKSD');
    }); */
  }

  void addDriverMarker(LatLng mLatLng, String mTitle, String mDescription,
      BitmapDescriptor marker, DriverDetails driver) {
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    _markers.add(Marker(
      markerId:
          MarkerId((mTitle + "_" + _markers.length.toString()).toString()),
      position: mLatLng,
      infoWindow: InfoWindow(
        title: mTitle,
        snippet: mDescription,
      ),
      icon: marker,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Center(
                      child: Text(
                    "Driver Name : ${driver.name}",
                    style: title.copyWith(color: Colors.deepPurpleAccent),
                    textAlign: TextAlign.center,
                  )),
                  content: Container(
                    height: height * 0.7,
                    width: width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        /* Text(
                          // "Walllet balance : ${formatPrice(1235.09)}",
                          "",
                          style: title,
                        ), */
                        Text(
                          "Phone number : ${driver.phoneNum}",
                          style: title,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Online  : ${driver.isOnline.toString()}",
                          style: title,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          child: Image.network(
                              'https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg'),
                        ),
                        SmoothStarRating(
                          starCount: 5,
                          // onRatingChanged: (s) {
                          //   // print(s);
                          //   setState(() {
                          //     rating = s;
                          //   });
                          // },
                          allowHalfRating: true,
                          color: Colors.amberAccent,
                          rating: double.parse(driver.ratings ?? 4.0),
                          borderColor: Colors.amber,
                          size: 30,
                        ),
                        Text(
                          "Car number : ${driver.carNumber.toString()}",
                          textAlign: TextAlign.center,
                          style: title,
                        ),
                        Text(
                          "Car Type: ${driver.carType}",
                          textAlign: TextAlign.center,
                          style: title,
                        ),
                        /* DefaultButton(
                          height: height,
                          width: width * 0.8,
                          color: Colors.blue,
                          title: 'Assign',
                          onPressed: () {
                            Fluttertoast.showToast(
                                msg: 'Driver Ramesh assigned');

                            updateBookingInfo(driver);
                            Navigator.of(context).pop();
                          },
                        ), */
                      ],
                    ),
                  ),
                ));
      },
      visible: true,
      flat: true,
      anchor: Offset(0.5, 0.5),
    ));
  }

  void addMarker(LatLng mLatLng, String mTitle, String mDescription,
      BitmapDescriptor marker, bool isCar) {
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    _markers.add(Marker(
      markerId:
          MarkerId((mTitle + "_" + _markers.length.toString()).toString()),
      position: mLatLng,
      infoWindow: InfoWindow(
        title: mTitle,
        snippet: mDescription,
      ),
      icon: marker,
      visible: true,
      flat: true,
      anchor: Offset(0.5, 0.5),
    ));
  }

  LatLng _lastMapPosition;

  @override
  void initState() {
    getDatabase();

    latlngDriver = widget.driverLocation;

    myLocation = LatLng(latlng.latitude, latlng.longitude);

    /*_initialCameraPosition =
        LatLng(bookingInfo.fromLoc.latitude, bookingInfo.fromLoc.longitude);
    _destinationPosition =
        LatLng(bookingInfo.toLoc.latitude, bookingInfo.toLoc.longitude); */

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/mylocation.png')
        .then((onValue) {
      _taxilocation = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(
              devicePixelRatio: 2.5,
              size: Size(10, 10),
            ),
            'assets/images/car_icon.png')
        .then((onValue) {
      carLocation = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/mydestination.png')
        .then((onValue) {
      _mylocation = onValue;
    });

    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      _mapStyle = string;
    });

    // getLatLngBounds(_initialCameraPosition, _destinationPosition);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildGradientAppBar('Tracking', Colors.amber),
      body: Stack(
        children: [
          Container(
              color: Colors.cyan,
              // margin: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                key: _mapKey,
                mapType: MapType.normal,
                // zoomGesturesEnabled: true,

                markers: _markers,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: myLocation,
                  zoom: 7.0,
                ),
                // onCameraMove: _onCameraMove,
              )),
        ],
      ),
    );
  }
}

import 'package:admin_app/model/bookingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:admin_app/model/driverDetail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerBookings extends StatefulWidget {
  final BookingInfo bookingInfo;

  const CustomerBookings({Key key, this.bookingInfo}) : super(key: key);

  @override
  _CustomerBookingsState createState() => _CustomerBookingsState(bookingInfo);
}

class _CustomerBookingsState extends State<CustomerBookings> {
  final BookingInfo details;

  var driverLoc;

  LatLng latlngDriver = LatLng(11.89, 78.123);

  getDatabase() async {
    // imageData = await getMarker();

    await Firestore.instance
        .collection('locations')
        // .where('docsUploaded', '==', true)
        .getDocuments()
        .then((value) {
      if (value.documents == null) {
        print('no loc');
      } else {
        value.documents.forEach((element) {
          /* setState(() {
            driverLoc = element.data()['position']['geopoint'];
          }); */
          // print("driverLOCC" + driverLoc.latitude.toString());
          setState(() {
            latlngDriver = LatLng(element.data['position']['geopoint'].latitude,
                element.data['position']['geopoint'].longitude);
          });

          print("LATLNG $latlngDriver");
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

  _CustomerBookingsState(this.details);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDoc();
    getDatabase();
  }

  BookingInfo bookingInfo;

  Map<String, dynamic> data;

  DriverDetails driverDetails;

  List<DriverDetails> list = [];

  getDoc() {
    Firestore.instance
        .collection('BookingDetails')
        // .where('docsUploaded', '==', true)

        .getDocuments()
        .then((value) {
      if (value.documents.isEmpty) {
        print('No Driver requested');
      } else {
        data = value.documents[0].data;
        // print(json.encode(data));
        // print(value.data());

        setState(() {
          data = value.documents[0].data;
          bookingInfo = BookingInfo.fromJson(data);
        });
        print(bookingInfo.carType);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("asdhjkh" + latlngDriver.toString());

    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;

    return Scaffold(
      appBar: AppBar(
//TITLE GOES HERE
        title: Text('Booking Details'),
      ),
      body: data != null
          ? Container(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text('${bookingInfo.custName}'),
                  ),
                  Container(
                    child: Text('${bookingInfo.to}'),
                  ),
                  Container(
                    child: Text('${bookingInfo.from}'),
                  ),
                  Container(
                    child: Text('${bookingInfo.bookedTime}'),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

import 'package:admin_app/model/bookingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

import '../constants.dart';
import '../money.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final String estimatedPrice;
  final String estimatedTime;
  final String estimatedDistance;
  final String kmPrice;
  final String type;
  final String trip;
  final String from;
  final String to;
  final String bookedDate;
  final String docId;
  final String noOfDays;

  const ConfirmBookingScreen({
    Key key,
    this.estimatedPrice,
    this.kmPrice,
    this.type,
    this.trip,
    this.estimatedDistance,
    this.estimatedTime,
    this.from,
    this.to,
    this.bookedDate,
    this.noOfDays,
    this.docId,
  }) : super(key: key);

  @override
  _ConfirmBookingScreenState createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  bool loading = false;
  bool isCompleted = false;

  // BasicController basicController;

  String from, to, days;

  DateFormat dateFormat;

  FirebaseUser user;

  TimeOfDay time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // basicController = Get.put(BasicController());
    // databaseService = DatabaseService();
    if (widget.from != null && widget.to != null) {
      from = widget.from;
      to = widget.to;
    }
    if (widget.bookedDate != null && widget.noOfDays != null) {
      formattedDate = widget.bookedDate;
      days = widget.noOfDays;
    }
  }

  var date;

  var formattedDate = '';

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 30))))) {
      return true;
    }
    return false;
  }

  changeDate() async {
    final localizations = MaterialLocalizations.of(context);
    var formatedTime = '';
    var dates = await showDatePicker(
      selectableDayPredicate: _decideWhichDayToEnable,
      context: context,
      helpText: 'Select date for traveling'.toUpperCase(),
      confirmText: 'Next'.toUpperCase(),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (dates != null) {
      TimeOfDay selectedTime = await showTimePicker(
        context: context,
        initialTime: _currentTime,
      );
      if (selectedTime != null) {
        setState(() {
          date = dates;
          time = selectedTime;
          formatedTime = localizations.formatTimeOfDay(time);
          formattedDate = DateFormat.yMMMEd().format(date) + " " + formatedTime;
        });
      }
    }
  }

  TimeOfDay _currentTime = new TimeOfDay.now();

  TextEditingController name = new TextEditingController(text: '');
  TextEditingController numberOfDays = new TextEditingController(text: '');

  // String currentDay;
  String currentDay = '1';
  bool isChecked = false;

  BookingInfo currentBooking;
  GlobalKey previewContainer = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    // print(widget.fromLoc.lat);
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            heroTag: 'fire',
            onPressed: () {
              Firestore.instance
                  .collection("BookingDetails")
                  .document(widget.docId)
                  .updateData({'sendToDriver': true}).then((value) {
                Fluttertoast.showToast(
                    msg: "Details sent to driver app via Notification");
                Navigator.of(context).pop();
              });
            },
            backgroundColor: Constants.primaryColor,
            label: Text(
              'Send To Driver',
              style: title.copyWith(color: Colors.white),
            ),
            icon: Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
              heroTag: 'group',
              onPressed: () {
                int originalSize = 800;
                var message =
                    "There's a new booking for you!\n\nFROM\n\n${widget.from}\n\nTO\n\n${widget.to}\n\nFULL DETAILS:\n\nEstimated Price: ${formatPrice(double.parse(widget.estimatedPrice))}\nEstimated Distance: ${widget.estimatedDistance}\nEstimated Time: ${widget.estimatedTime}";
                ShareFilesAndScreenshotWidgets().shareScreenshot(
                    previewContainer,
                    originalSize,
                    '${Constants.appName}',
                    'New Booking From $from',
                    'image/jpg',
                    text: "$message");

                // Share.share("Hello $message");
              },
              backgroundColor: Constants.primaryColor,
              child: Icon(FontAwesomeIcons.shareAlt)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              // gradient: FlutterGradients.northMiracle(tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*   Container(
                  height: 20,
                  width: 10,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ),
                    onPressed: () {
                      print('asd');
                      Navigator.of(context).pop();
                    },
                  )), */
              /*  !isCompleted
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'basic details',
                          style: sub,
                        ),
                        SizedBox(height: defaultSize * 0.5),
                        widget.trip == 'Round Trip'
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    width: width * 0.8,
                                    height: height * 0.07,
                                    child: TextFormField(
                                      controller: name,
                                      decoration: InputDecoration(
                                          labelText: "Enter name",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.black),
                                          )),
                                    ),
                                  ),
                                  SizedBox(height: defaultSize),
                                  InkWell(
                                    onTap: () async {
                                      changeDate();
                                    },
                                    child: Container(
                                      width: width * 0.8,
                                      height: height * 0.07,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          // color: Colors.amberAccent,
                                          border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              width: 1.5)),
                                      child: Text(date == null
                                          ? 'Select the date'
                                          : formattedDate.toString()),
                                    ),
                                  ),
                                  SizedBox(height: defaultSize),
                                  Container(
                                    width: width * 0.8,
                                    height: height * 0.07,
                                    child: TextFormField(
                                      controller: numberOfDays,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: "Enter number of days",
                                          hintText: '1 - 3 days',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2, color: Colors.black),
                                          )),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: InkWell(
                                  onTap: () async {
                                    changeDate();
                                  },
                                  child: Container(
                                    width: width * 0.8,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        // color: Colors.amberAccent,
                                        border: Border.all(
                                            color: Colors.black, width: 2)),
                                    child: Text(date == null
                                        ? 'Select the date'
                                        : formattedDate.toString()),
                                  ),
                                ),
                              ),
                      ],
                    )
                  : Container(), */
              SizedBox(height: defaultSize * 0.5),
              RepaintBoundary(
                key: previewContainer,
                child: Container(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: FlutterGradients.itmeoBranding(
                              tileMode: TileMode.clamp),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'From',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: sub.copyWith(color: Colors.black54),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/locPin.png',
                                height: 30,
                                width: 30,
                              ),
                              Expanded(
                                child: Text(
                                  '$from',
                                  style: title.copyWith(fontSize: 16),
                                  // maxLines: 5,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'To',
                            textAlign: TextAlign.start,
                            style: sub.copyWith(color: Colors.black54),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/locPinTO.png',
                                height: 30,
                                width: 30,
                              ),
                              Expanded(
                                child: Text(
                                  '$to',
                                  style: title.copyWith(fontSize: 16),
                                  // maxLines: 2,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: defaultSize * 0.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/${widget.type.trim().toLowerCase()}.png',
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    '${widget.type}',
                                    style: sub,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(height: defaultSize * 0.7),
                                  Image.asset(
                                    widget.trip == 'One Way Trip'
                                        ? 'assets/images/oneway.png'
                                        : 'assets/images/twoway.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(height: defaultSize * 0.5),
                                  Text(
                                    '${widget.trip}',
                                    style: sub,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: defaultSize * 0.5),
                          // Text('')
                          Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 10,
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  gradient: FlutterGradients.temptingAzure(),
                                  borderRadius: BorderRadius.circular(10)),
                              height: height * 0.1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Total Distance : \n${widget.estimatedDistance} Kms.',
                                    style: title.copyWith(fontSize: 11),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: defaultSize),
                                  Text(
                                    'Traveling Time(min) : \n${widget.estimatedTime}',
                                    style: title.copyWith(fontSize: 11),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: defaultSize * 0.5),
                          Card(
                            color: Colors.yellow,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: FlutterGradients.northMiracle(),
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Estimation Fare : ',
                                    style: title.copyWith(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  Text(
                                    '${formatPrice(double.parse(widget.estimatedPrice))}',
                                    style: title.copyWith(
                                        color: Colors.white, fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //₹400
                          SizedBox(height: defaultSize),
                          Center(
                            child: Container(
                              height: height * 0.07,
                              child: Text(
                                formattedDate,
                                overflow: TextOverflow.ellipsis,
                                style: title.copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          SizedBox(height: defaultSize * 0.0),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              widget.trip == 'One Way Trip'
                                  ? Container()
                                  : Expanded(
                                      flex: 2,
                                      child: Container(
                                          height: height * 0.1,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                'Number of days : $days',
                                                style: sub,
                                              )
                                            ],
                                          )),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: defaultSize * 0.7),
              SizedBox(height: defaultSize * 1.2),
            ],
          ),
        ),
      ),
    );
  }
}

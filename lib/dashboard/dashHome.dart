import 'package:admin_app/auth/newLogin.dart';
import 'package:admin_app/auth/theme.dart';
import 'package:admin_app/constants.dart';
import 'package:admin_app/dashboard/changePrice.dart';
import 'package:admin_app/dashboard/checkHistoryWeb.dart';
import 'package:admin_app/dashboard/trackDriver.dart';
import 'package:admin_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_app/model/driverDetail.dart';
import 'driverVerification.dart';

var darkBgColor = Color(0xff13131B);
var cardBgColor = Color(0xff1C1C25);
var primaryColor = Color(0xff153e90);

class DashNewUI extends StatefulWidget {
  @override
  _DashNewUIState createState() => _DashNewUIState();
}

class _DashNewUIState extends State<DashNewUI> {
  // var webDatabase = WebFirebase.database();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatabase();

    getDoc();
  }

  Map<String, dynamic> data;

  DriverDetails driverDetails;

  List<DriverDetails> list = [];

  getDoc() {
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
            print(driverDetails.name);
            list.add(driverDetails);
            print(list.length);
          });
        });
        setState(() {
          data = value.documents.first.data;
        });
      }
    });
  }

  getDatabase() async {
    Firestore.instance
        .collection('locations')
        // .where('docsUploaded', '==', true)
        .getDocuments()
        .then((value) {
      if (value.documents.isEmpty) {
        print('no loc');
      } else {
        value.documents.forEach((element) {
          print(element.data['position']['geopoint'].latitude);
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

// creating a list of icons for passing in a grid view
  List<IconData> icons = [
    FontAwesomeIcons.clone,
    FontAwesomeIcons.users,
    FontAwesomeIcons.mapMarker,
    FontAwesomeIcons.coins
  ];

// creating a list of Strings for displaying in a grid

  List<String> glabels = [
    'Bookings',
    'Drivers',
    ' Track Drivers',
    'change Price'
  ];

  List pressme = [
    RideHistoryPage(),
    DriverVerification(),
    DriverTracking(),
    ChangeKmPrice(),
  ];
  @override
  Widget build(BuildContext context) {
    // getDoc();
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    // by k
    var width = screenSize.width;
    var defaultSize = height * 0.05;

// by d
    var hei = screenSize.height;
    var wid = screenSize.width;

    var contentStyle = GoogleFonts.poppins(
        color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600);

    return Scaffold(
      // by K

      // backgroundColor: Colors.grey.shade900.withOpacity(0.8),
      //     body: SafeArea(
      //   child: SingleChildScrollView(
      //     child: Container(
      //         padding: EdgeInsets.all(30),
      //         child: Column(mainAxisAlignment: MainAxisAlignment.start,
      //             // crossAxisAlignment: CrossAxisAlignment.center,
      //             children: <Widget>[
      //               InkWell(
      //                   onTap: () {
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) => DriverVerification(
      //                                   driverDetails: list,
      //                                 )));
      //                   },
      //                   child: DashboardIncreasedValueCard(
      //                     height: height,
      //                     width: width,
      //                     title: 'New Drivers',
      //                     subtitle: 'new drivers joined this month',
      //                     value: list.length.toString(),
      //                     gradients: FlutterGradients.mixedHopes(),
      //                   )),
      //               SizedBox(height: defaultSize * 0.5),
      //               InkWell(
      //                   onTap: () {
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) => RideHistoryPage()));
      //                   },
      // child: DashboardIncreasedValueCard(
      //                     height: height,
      //                     width: width,
      //                     title: 'View Bookings',
      //                     subtitle: 'view all the customer bookings',
      //                     gradients: FlutterGradients.aquaGuidance(),
      //                   )),
      //               SizedBox(height: defaultSize * 0.5),
      //               GetStartedCardBlue(
      //                 height: height,
      //                 width: width,
      //                 centerTitle: 'TRACK DRIVERS',
      //                 btntitle: 'VIEW',
      //                 topHeading: 'TRACK',
      //                 onPressed: () {
      //                   Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      // builder: (context) => DriverTracking(
      //                                 drivers: list,
      //                               )));
      //                 },
      //               ),
      //               SizedBox(height: defaultSize * 0.5),
      //               InkWell(
      //                   onTap: () {
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      // builder: (context) => ChangeKmPrice()));
      //                   },
      //                   child: DashboardIncreasedValueCard(
      //                     height: height,
      //                     width: width,
      //                     title: 'Change Price',
      //                     gradients: FlutterGradients.mixedHopes(),
      //                   )),

      //               // SizedBox(height: defaultSize),
      //               // DashboardDecreasedValueCard(height: height, width: width),
      //               SizedBox(height: defaultSize),

      //               SizedBox(height: defaultSize),
      //               // ProjectsCard(height: height, width: width, contentStyle: contentStyle),
      //             ])),
      //   ),
      // )

// by D
      backgroundColor: Constants.primary_color,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Welcome',
                      style: title.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 27.0,
                      ),
                    ),
                    SizedBox(
                      width: wid * 0.02,
                    ),
                    Text(
                      'user ,',
                      style:
                          title.copyWith(fontSize: 34.0, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              width: wid,
              // top: ,
              bottom: 0,
              height: hei * 0.8,
              child: Container(
                width: wid,
                height: hei * 0.8,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          blurRadius: 80,
                          spreadRadius: -50,
                          offset: Offset(0, 0))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 80.0, bottom: 0.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 40,
                    children: List.generate(
                      4,
                      (index) => customgrid(hei, wid, icons[index],
                          glabels[index], pressme[index]),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customgrid(
      double hei, double wid, IconData icon, String glabel, Widget child) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (c) => child));
      },
      child: Container(
        // color: Colors.blueAccent,
        height: hei * 0.2,
        width: wid * 0.5,
        decoration: BoxDecoration(
            gradient: FlutterGradients.morpheusDen(
                // startAngle: , endAngle:  math.pi*2
                center: Alignment.bottomLeft,
                tileMode: TileMode.mirror,
                startAngle: 180,
                radius: 30),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(10, -10),
                  blurRadius: 100,
                  spreadRadius: -30),
            ],
            borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            SizedBox(height: hei * 0.04),
            Icon(
              icon,
              color: Colors.white,
              size: 60.0,
            ),
            SizedBox(
              height: hei * 0.03,
            ),
            Text(
              glabel,
              style: title.copyWith(fontSize: 20.0, color: Colors.white),
            )
          ],
        ),

        // SizedBox(
        // height: hei * 0.02,
        // ),
      ),
    );
  }
}

class ProjectsCard extends StatelessWidget {
  const ProjectsCard({
    Key key,
    @required this.height,
    @required this.width,
    @required this.contentStyle,
  }) : super(key: key);

  final double height;
  final double width;
  final TextStyle contentStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.6,
      width: width * 0.9,
      decoration: BoxDecoration(
          color: cardBgColor,
          border: Border.all(color: Colors.white54),
          borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 18,
            top: 10,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 10,
            child: Text(
              'Projects',
              style: contentStyle,
            ),
          ),
          Positioned(
              left: width * 0.07,
              top: height * 0.1,
              child: Container(
                width: width * 0.7,
                height: height * 0.2,
                decoration: BoxDecoration(
                    color: cardBgColor,
                    boxShadow: [
                      BoxShadow(
                          color: cardBgColor,
                          offset: Offset(10, 20),
                          blurRadius: 37,
                          spreadRadius: 11),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(20)),
                child: buildProjectHeadCard(contentStyle: contentStyle),
              )),
          ProgressGradient(height: height, width: width),
          Positioned(
            top: height * 0.45,
            left: width * 0.08,
            child: DefaultButton(width: width, height: height),
          )
        ],
      ),
    );
  }
}

class buildProjectHeadCard extends StatelessWidget {
  const buildProjectHeadCard({
    Key key,
    @required this.contentStyle,
  }) : super(key: key);

  final TextStyle contentStyle;
  CircleAvatar buildUserCircle(String name) {
    return CircleAvatar(
      backgroundColor: Colors.blueAccent.shade400.withOpacity(0.7),
      child: Text(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FlutterLogo(
              size: 50,
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Kavin',
                style: contentStyle,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildUserCircle('AL'),
            buildUserCircle('BO'),
            buildUserCircle('CK'),
            buildUserCircle('ZP'),
            CircleAvatar(
              backgroundColor: Colors.blueAccent.shade400.withOpacity(0.7),
              child: Text('+3'),
            )
          ],
        ),
      ],
    );
  }
}

class ProgressGradient extends StatelessWidget {
  const ProgressGradient({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: height * 0.35,
      left: width * 0.08,
      child: Container(
        height: 20,
        width: width * 0.3,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff0077FF), Colors.greenAccent],
                begin: Alignment.centerLeft),
            //border: Border.all(color: Colors.white54),
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class GetStartedCardBlue extends StatelessWidget {
  final topHeading;
  final String centerTitle;
  final String btntitle;
  final Function onPressed;

  const GetStartedCardBlue({
    Key key,
    @required this.height,
    @required this.width,
    this.topHeading,
    this.centerTitle,
    this.btntitle,
    this.onPressed,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.3,
      width: width * 0.8,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff0077FF), Colors.deepPurple],
              begin: Alignment.topRight,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // SizedBox(height: defaultSize),
          Text(
            topHeading.toString().toUpperCase() ?? 'GET STARTED'.toUpperCase(),
            style: GoogleFonts.gothicA1(
                letterSpacing: 5,
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),

          Text(
            centerTitle ?? 'Get Content',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
          ),
          DefaultButton(
            width: width,
            height: height,
            onPressed: onPressed,
            title: btntitle,
          )
        ],
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  const DefaultButton({
    Key key,
    @required this.width,
    @required this.height,
    this.color,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        decoration: BoxDecoration(
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(20)),
        width: width * 0.7,
        height: height * 0.06,
        padding: EdgeInsets.all(8.0),
        child: Text(
          title ?? 'start',
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class DashboardDecreasedValueCard extends StatelessWidget {
  const DashboardDecreasedValueCard({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      width: width * 0.8,
      decoration: BoxDecoration(
          color: cardBgColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.redAccent.shade700.withOpacity(0.5),
                child: Icon(
                  Icons.arrow_downward,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
              // SizedBox(width: defaultSize),
              Text(
                '4,596',
                style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w600),
              ),
              // SizedBox(width: defaultSize),
              Text(
                '-3.7%',
                style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 19,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          // SizedBox(height: defaultSize),
          Text(
            'you have lost this month!',
            style: GoogleFonts.poppins(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class DashboardIncreasedValueCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient gradients;
  final String value;

  const DashboardIncreasedValueCard({
    Key key,
    this.title,
    @required this.height,
    @required this.width,
    this.gradients,
    this.value,
    this.subtitle,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      width: width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradients,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                value != null
                    ? CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          '${value}',
                          style: sub.copyWith(color: Colors.white),
                        ))
                    : Container(),
                // SizedBox(width: defaultSize),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      '$title',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                // SizedBox(width: defaultSize),
                /* Text(
                  '+2.7%',
                  style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ), */
              ],
            ),
            // SizedBox(height: defaultSize),
            Expanded(
              flex: 2,
              child: Text(
                subtitle ?? 'you have got this month!',
                style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
                flex: 4,
                child: Icon(
                  Icons.navigate_next_sharp,
                  size: 50,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}

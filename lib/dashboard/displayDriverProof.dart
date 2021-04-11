import 'package:admin_app/constants.dart';
import 'package:admin_app/widgets/appBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/model/driverDetail.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayProofs extends StatefulWidget {
  final DriverDetails driverDetails;

  const DisplayProofs({Key key, this.driverDetails}) : super(key: key);

  @override
  _DisplayProofsState createState() => _DisplayProofsState();
}

class _DisplayProofsState extends State<DisplayProofs> {
  @override
  Widget build(BuildContext context) {
    print(kIsWeb);
    Size screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    var defaultSize = height * 0.05;
    var defaultPadding = 16;
    return Scaffold(
        appBar: buildGradientAppBar(
            'Verification for ${widget.driverDetails.name}' , Colors.amber),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Firestore.instance
                  .collection("DriverDetails")
                  .document(widget.driverDetails.uid)
                  .updateData({'isAdminVerified': true});

              Fluttertoast.showToast(
                  msg: 'Submission done', webPosition: "center");
              Navigator.of(context).pop();
            },
            label: Text('Verification complete')),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: kIsWeb
            ? Container(
                height: height, width: width, child: buildForWeb(defaultSize))
            : Container(
                height: height,
                width: width,
                child: buildForMobile(defaultSize, widget.driverDetails)));
  }

  showImage(String urls) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            content: Container(
                child: urls.length > 15
                    ? CachedNetworkImage(
                        imageUrl: urls,
                        errorWidget: (context, url, error) {
                          return Container(
                            height: 200,
                            width: 400,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error,
                                  size: 60,
                                ),
                                Text(
                                  'No image provided',
                                  style: title,
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 200,
                        width: 400,
                        child: Column(
                          children: [
                            Icon(
                              Icons.error,
                              size: 60,
                            ),
                            Text(
                              'No image provided',
                              style: title,
                            )
                          ],
                        ),
                      )),
          );
        });
  }

  SingleChildScrollView buildForMobile(
      double defaultSize, DriverDetails driver) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(gradient: FlutterGradients.aquaGuidance()),
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(width: defaultSize),
                      Center(
                        child: Text(
                          "1. Driver name : \n${driver.name}",
                          textAlign: TextAlign.start,
                          style: title.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: defaultSize * 0.3),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    SizedBox(width: defaultSize),
                    Center(
                      child: Text(
                        "2. Number : \n${driver.phoneNum}",
                        style: title.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
                  SizedBox(height: defaultSize * 0.3),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      FontAwesomeIcons.car,
                      color: Colors.white,
                    ),
                    SizedBox(width: defaultSize),
                    Center(
                      child: Text(
                        "3. Car Type : \n${driver.carType}          ",
                        style: title.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
                  SizedBox(height: defaultSize * 0.3),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      FontAwesomeIcons.car,
                      color: Colors.white,
                    ),
                    SizedBox(width: defaultSize),
                    Center(
                      child: Text(
                        "4. Car Model : \n${driver.carName ?? 'Not Provided'}",
                        style: title.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
                  SizedBox(height: defaultSize * 0.3),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Icon(
                      FontAwesomeIcons.car,
                      color: Colors.white,
                    ),
                    SizedBox(width: defaultSize),
                    Center(
                      child: Text(
                        "5. Number : \n${driver.carNumber}",
                        style: title.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            SizedBox(height: defaultSize),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showImage(driver.proofs.dlCopy);
                    },
                    child: Column(
                      children: [
                        Text(
                          'DL COPY',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              fontSize: 30, color: Colors.black),
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          child: widget.driverDetails.proofs.dlCopy.length > 15
                              ? CachedNetworkImage(
                                  imageUrl: widget.driverDetails.proofs.dlCopy)
                              : Placeholder(),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showImage(driver.proofs.insuranceCopy);
                    },
                    child: Column(
                      children: [
                        Text(
                          'Insurance COPY'.toUpperCase(),
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              fontSize: 30, color: Colors.black),
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          child: widget.driverDetails.proofs.insuranceCopy
                                      .length >
                                  15
                              ? CachedNetworkImage(
                                  imageUrl:
                                      widget.driverDetails.proofs.insuranceCopy)
                              : Placeholder(),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: defaultSize),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          showImage(driver.proofs.rcCopy);
                        },
                        child: Column(
                          children: [
                            Text(
                              'RC COPY',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontSize: 30, color: Colors.black),
                            ),
                            Container(
                              height: 200,
                              width: 200,
                              child: widget.driverDetails.proofs.rcCopy.length >
                                      15
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          widget.driverDetails.proofs.rcCopy)
                                  : Placeholder(),
                            ),
                          ],
                        ))),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    showImage(driver.proofs.aadharCopy);
                  },
                  child: Column(
                    children: [
                      Text(
                        'Aadhar Card COPY',
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                            fontSize: 30, color: Colors.black),
                      ),
                      Container(
                        height: 200,
                        width: 200,
                        child:
                            widget.driverDetails.proofs.aadharCopy.length > 15
                                ? CachedNetworkImage(
                                    imageUrl:
                                        widget.driverDetails.proofs.aadharCopy)
                                : Placeholder(),
                      ),
                    ],
                  ),
                )),
              ],
            ),
            SizedBox(height: defaultSize * 2),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildForWeb(double defaultSize) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'DL COPY',
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.black),
                    ),
                    Container(
                      height: 400,
                      width: 500,
                      child: widget.driverDetails.proofs.dlCopy !=
                              'Not provided'
                          ? Image.network(widget.driverDetails.proofs.dlCopy)
                          : Placeholder(),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Insurance COPY',
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.black),
                    ),
                    Container(
                      height: 400,
                      width: 500,
                      child: widget.driverDetails.proofs.insuranceCopy !=
                              'Not provided'
                          ? Image.network(
                              widget.driverDetails.proofs.insuranceCopy)
                          : Placeholder(),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: defaultSize),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'RC COPY',
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.black),
                    ),
                    Container(
                      height: 400,
                      width: 500,
                      child: widget.driverDetails.proofs.dlCopy !=
                              'Not provided'
                          ? Image.network(widget.driverDetails.proofs.rcCopy)
                          : Placeholder(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Aadhar Card COPY',
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.black),
                    ),
                    Container(
                      height: 400,
                      width: 500,
                      child: widget.driverDetails.proofs.aadharCopy !=
                              'Not provided'
                          ? Image.network(
                              widget.driverDetails.proofs.aadharCopy)
                          : Placeholder(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

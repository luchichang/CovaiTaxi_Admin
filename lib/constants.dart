import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var title = GoogleFonts.montserrat(
    fontSize: 20, color: Colors.black, fontWeight: FontWeight.w800);
var sub = GoogleFonts.montserrat(
    fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);

    //by D
// creating a custom text style
var subheading = GoogleFonts.poppins(
    fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold);

var subheading2 = GoogleFonts.poppins(
  fontSize: 14.0,
  color: Colors.black.withOpacity(0.6),
);

var label_text = GoogleFonts.poppins(
  fontSize: 18.0,
  color: Colors.black,
  // fontWeight: FontWeight.w300,
);

class Constants {
  static final String logo = "assets/images/logo.png";
  static final String bgleaf = "assets/images/bg_leaf.png";
  static final Color primaryColor = Color(0xff000272); // color used ka
  static final Color primary_color = Color(0xff011627); //color used by D

  static final String appName = "Silver Drop Taxi";
  static final String companyNumber = "+919787474700";

  static final String baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static final SMS_API_KEY =
      'tXGFnAr4LNYZM8Q9jwPVHxWdvs6eahl2qk5of7SzpRbOUEumITTnoiOFHqdCLhzJPgaxer2mpZ8UNEyf';

  static final String API_KEY = 'AIzaSyBNKpr4auBLgBgiOXJ41UUWTB58MZa6p3E';

  List<String> statusList = [
    'Booking Confirmed',
    'Driver Assigned',
    'Driver On the way',
    'Travelling',
    'Reached Destination',
  ];

  static final String whatsappUrl =
      "https://api.whatsapp.com/send?phone=$companyNumber&text=Hello $appName ";
}

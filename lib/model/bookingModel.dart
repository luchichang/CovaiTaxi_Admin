// To parse this JSON data, do
//
//     final bookingInfo = bookingInfoFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

BookingInfo bookingInfoFromJson(String str) =>
    BookingInfo.fromJson(json.decode(str));

String bookingInfoToJson(BookingInfo data) => json.encode(data.toJson());

class BookingInfo {
  BookingInfo({
    this.from,
    this.fromLoc,
    this.driverLoc,
    this.carNumber,
    this.driverRatings,
    this.toLoc,
    this.trip,
    this.days,
    this.docId,
    this.carType,
    this.estimatedDistance,
    this.sendToDriver,
    this.kmPrice,
    this.to,
    this.isAssigned,
    this.assignedTo,
    this.bookedTime,
    this.createdAt,
    this.custName,
    this.custPhone,
    this.custUID,
    this.currentLoc,
    this.totalAmount,
    this.totalTravelingTime,
    this.totalDistance,
    this.status,
    this.driverName,
    this.driverPhone,
    this.otp,
  });

  final String from;
  final GeoPoint fromLoc;
  final GeoPoint toLoc;
  final String to;
  final String trip;
  final bool isAssigned;
  final bool sendToDriver;
  final String docId;
  final String assignedTo;
  final String bookedTime;
  final String createdAt;
  final String custName;
  final String custPhone;
  final String custUID;
  final String currentLoc;
  final String estimatedDistance;
  final String carType;
  final String carNumber;
  final String kmPrice;
  final String days;
  final String totalAmount;
  final String totalTravelingTime;
  final String totalDistance;
  final String status;
  final String driverName;
  final String driverPhone;
  final String driverRatings;
  final GeoPoint driverLoc;
  final String otp;

  factory BookingInfo.fromJson(Map<String, dynamic> json) => BookingInfo(
        from: json["from"],
        to: json["to"],
        isAssigned: json["isAssigned"],
        sendToDriver: json["sendToDriver"],
        assignedTo: json["assignedTo"],
        bookedTime: json["bookedTime"],
        createdAt: json["createdAt"],
        fromLoc: json['fromLoc'],
        toLoc: json['toLoc'],
        custName: json["custName"],
        kmPrice: json['kmPrice'],
        days: json['days'],
        estimatedDistance: json['estimatedDistance'],
        custPhone: json["custPhone"],
        custUID: json["custUID"],
        carType: json["carType"],
        currentLoc: json["currentLoc"],
        totalAmount: json["totalAmount"],
        totalTravelingTime: json["totalTravelingTime"],
        totalDistance: json["totalDistance"],
        carNumber: json["carNumber"],
        docId: json["docId"],
        driverRatings: json["driverRatings"],
        trip: json["trip"],
        status: json["status"],
        driverName: json["driverName"],
        driverPhone: json["driverPhone"],
        driverLoc: json["driverLoc"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "fromLoc": fromLoc,
        "toLoc": toLoc,
        "to": to,
        "isAssigned": isAssigned,
        "sendToDriver": sendToDriver,
        "assignedTo": assignedTo,
        "bookedTime": bookedTime,
        "createdAt": createdAt,
        "custName": custName,
        "custPhone": custPhone,
        "custUID": custUID,
        "currentLoc": currentLoc,
        "carType": carType,
        "estimatedDistance": estimatedDistance,
        "kmPrice": kmPrice,
        "trip": trip,
        "days": days,
        "carNumber": carNumber,
        "docId": docId,
        "driverRatings": driverRatings,
        "totalAmount": totalAmount,
        "totalTravelingTime": totalTravelingTime,
        "totalDistance": totalDistance,
        "status": status,
        "driverName": driverName,
        "driverPhone": driverPhone,
        "driverLoc": driverLoc,
        "otp": otp,
      };
}

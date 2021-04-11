import 'package:admin_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

AppBar buildAppBar(var titles) {
  return AppBar(
      elevation: 10,
      title: Text(
        '$titles',
        style: title.copyWith(
            color: titles.toString().toLowerCase() == 'online'
                ? Colors.white
                : Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.red,
      flexibleSpace: Container(
        decoration: titles.toString().toLowerCase() == 'online'
            ? BoxDecoration(gradient: FlutterGradients.youngGrass())
            : BoxDecoration(),
      ));
}

AppBar buildGradientAppBar(var titles, Color color) {
  return AppBar(
      elevation: 10,
      title: Text(
        '$titles',
        style: title.copyWith(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: color,
      // flexibleSpace: Container(
          // decoration: BoxDecoration(gradient: FlutterGradients.loveKiss()))
          
          );
}

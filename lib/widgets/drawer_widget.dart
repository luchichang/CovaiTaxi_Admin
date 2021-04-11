import 'package:admin_app/widgets/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';

import '../constants.dart';

class DrawerWidget extends StatelessWidget {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              FontAwesomeIcons.user,
              color: Constants.primaryColor,
              size: 40,
            ),
            title: Text(
              "Hello there",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              'User',
              style: CustomStyles.cardBoldDarkDrawerTextStyle,
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    /*  Navigator.of(context)
                        .popAndPushNamed(RideHistoryPage.routeName); */
                  },
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      "Ride History",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*  Share.share(
                      "https://github.com/Dennis247/green_taxi",
                      subject: "Invite Your Friend To TRS Taxi",
                    ); */
                  },
                  child: ListTile(
                    leading: Icon(Icons.person_add_alt_1_outlined),
                    title: Text(
                      "Invite",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*   Navigator.of(context)
                        .popAndPushNamed(PromoCodePage.routeName); */
                  },
                  child: ListTile(
                    leading: Icon(Icons.offline_bolt_rounded),
                    title: Text(
                      "Promo code",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*   Navigator.of(context)
                        .popAndPushNamed(SettingsPage.routeName); */
                  },
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      "Settings",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovementsScreen())); */
                  },
                  child: ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text(
                      "Tracking",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    /*  Navigator.of(context)
                        .popAndPushNamed(SupportPage.routeName); */
                  },
                  child: ListTile(
                    leading: Icon(Icons.contact_support_rounded),
                    title: Text(
                      "Support",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(
                      "Log Out",
                      style: CustomStyles.cardBoldDarkTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:Utician/screens/dashboard/index.dart';
import 'package:Utician/screens/onboard/index.dart';
import 'package:Utician/util/util.dart';
import "package:flutter/material.dart";
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String token;
  var logger = Logger();
  //check whether it's first time

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('seen') ?? false;
    logger.d("loggerd", _seen);
    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Dashboard()));
    } else {
      prefs.setBool('seen', false);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Onboarding()));
    }

  }


  @override
  void initState() {
    super.initState();
    // Timer(
    //     Duration(seconds: Util.bemeSplash),
    //     () => Navigator.of(context).pushReplacement(
    //             MaterialPageRoute(builder: (BuildContext context) {
    //           return Onboarding();
    //         })));

    Timer(Duration(seconds: Util.bemeSplash), () => checkFirstSeen());
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
        type: MaterialType.transparency,
        child: new Container(
            width: double.infinity,
            height: double.infinity,
            decoration:
                BoxDecoration(color: const Color(Util.main_default_primary)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(margin: EdgeInsets.only(bottom: 5.0)),
                title(),
                subtitle(),
              ],
            )));
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[new Text(Util.appName, style: titleStyle)],
    );
  }

  Widget subtitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[new Text(Util.appDescription, style: subtitleStyle)],
    );
  }

  // Styles
  var titleStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeLogo, fontSize: Util.bemeSize);

  var subtitleStyle = TextStyle(
      color: Colors.black,
      fontFamily: Util.BemeRegular,
      fontSize: Util.bemeSubSize);

  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

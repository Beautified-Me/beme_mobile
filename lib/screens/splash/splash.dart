import 'dart:async';

import 'package:Utician/screens/onboard/index.dart';
import 'package:Utician/util/util.dart';
import "package:flutter/material.dart";

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //Initialized state
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: Util.bemeSplash),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Onboarding())));
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
      children: <Widget>[
        new Text(Util.appDescription, style: subtitleStyle)
      ],);
  }



  // Styles
  var titleStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeLogo, fontSize: Util.bemeSize);

  var subtitleStyle = TextStyle(color: Colors.black, fontFamily:  Util.BemeRegular, fontSize: Util.bemeSubSize);
}

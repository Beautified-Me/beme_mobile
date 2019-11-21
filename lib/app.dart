import 'package:Utician/screens/forgetpassword/index.dart';
import 'package:Utician/screens/onboard/index.dart';
import 'package:Utician/screens/splash/index.dart';
import 'package:Utician/screens/login/index.dart';
import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


final appRoutes = <String, WidgetBuilder> {
  '/splash': (BuildContext context) => Scaffold(body: Splash()),
  '/walkthrough': (BuildContext context) => Scaffold(body: Onboarding()),
  '/login' :(BuildContext context) => Scaffold(body: Login()),
  '/forgetpassword' :(BuildContext context) => Scaffold(body: ForgetPassword())

};


class App extends StatelessWidget {


  final SharedPreferences prefs;
  App({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Util.appName,
      routes: appRoutes,
      home: _handleCurrentScreen(),
      theme: ThemeData(primaryColor: Color(Util.main_default_primary)),
      // DEBUG BANNER
      debugShowCheckedModeBanner: false
    );
  }

Widget _handleCurrentScreen() {
    bool seen = (prefs.getBool('seen') ?? false);
    //print(seen);
    if (seen) {
      return new Login();
    } else {
      return new Onboarding(prefs: prefs);
    }
  }

}
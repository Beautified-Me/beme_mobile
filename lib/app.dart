import 'package:Utician/screens/about/index.dart';
import 'package:Utician/screens/dashboard/index.dart';
import 'package:Utician/screens/forgetpassword/index.dart';
import 'package:Utician/screens/onboard/index.dart';
import 'package:Utician/screens/profile/index.dart';
import 'package:Utician/screens/splash/index.dart';
import 'package:Utician/screens/login/index.dart';
import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';


final appRoutes = <String, WidgetBuilder>{
  '/splash': (BuildContext context) => Scaffold(body: Splash()),
  '/walkthrough': (BuildContext context) => Scaffold(body: Onboarding()),
  '/login': (BuildContext context) => Scaffold(body: Login()),
  '/forgetpassword': (BuildContext context) => Scaffold(body: ForgetPassword()),
  '/dashboard' : (BuildContext context) => Scaffold(body: Dashboard()),
  '/profile' : (BuildContext context) => Scaffold(body: Profile()),
  '/about' : (BuildContext context) => Scaffold(body: About(),)
};

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Util.appName,
        routes: appRoutes,
        home: Splash(),
        theme: ThemeData(primaryColor: Color(Util.main_default_primary)),
        debugShowCheckedModeBanner: false);
  }
}


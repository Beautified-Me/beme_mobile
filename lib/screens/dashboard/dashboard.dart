import 'package:Utician/data/user.dart';
import 'package:Utician/services/auth_service.dart';
import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Dashboard extends StatefulWidget {
  final User userdata;
  Dashboard({Key key, this.userdata}) : super(key: key);
  

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const _kFontFam = 'MyFlutterApp';
  static const IconData logout = const IconData(0xe800, fontFamily: _kFontFam);
  bool camState = false;
  
  String name;
  String email;
  String profile_picture;

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    super.initState();

    _getSharedPreferenceString("name").then((storedName) {
      if (storedName != null) {
        setState(() {
          name = storedName;
          print("name" + name);
        });
      }
    });

    _getSharedPreferenceString("email").then((storedEmail) {
      if (storedEmail != null) {
        setState(() {
          email = storedEmail;
          print("email" + email);
        });
      }
    });

    _getSharedPreferenceString("profilePicture").then((storedPicture) {
      if (storedPicture != null) {
        setState(() {
          profile_picture = storedPicture;
        });
      }
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(Util.alert_title),
            content: new Text(Util.alert_desc),
            actions: <Widget>[
              new FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text(Util.yes),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(Util.no),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: <Widget>[
            new Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(color: Color(Util.white))),
            Scaffold(
                backgroundColor: Colors.transparent,
                appBar: new AppBar(
                  backgroundColor: Colors.black,
                  elevation: 0.0,
                  iconTheme: new IconThemeData(color: Colors.white),
                ),
                drawer: bemeDrawerPage(),
                body: Column(
                  children: <Widget>[
                    Container(
                      child: camState
                          ? accessTabScanning()
                          : defaultAccessTabCamera(),
                    ),
                    Container(
                      height: 146,
                      child: cameraButton(),
                    )
                  ],
                )),
          ],
        ));
  }

  Widget defaultAccessTabCamera() {
    return new Padding(
      padding: EdgeInsets.all(0.0),
      child: new Container(
        width: double.infinity,
        height: 500,
        decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            border: Border(
                bottom: BorderSide(width: 0.4, color: Color(Util.black)))),
        child: Center(
          child: new Container(
            padding: const EdgeInsets.all(50.0),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.rectangle,
            ),
            child:
                new Text(Util.default_tap_activity_scan, style: scanTextStyle),
          ),
        ),
      ),
    );
  }

  Widget accessTabScanning() {
    // return new GestureDetector(onTap: () {
    //   setState(() {
    //     camState = false;
    //   });
    // });
  }

  cameraButton() {
    return new GestureDetector(
        onTap: () {
          //Do something
          camState = !camState;
        },
        child: Center(
            child: ClipOval(
          child: Container(
            color: Colors.white,
            height: 80.0,
            width: 80.0,
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.black,
                  width: 10.0,
                ),
              ),
            ),
          ),
        )));
  }

Future<Null> logOutFb() async {
    await facebookSignIn.logOut();
  }

  onLogoutClicked() {
    var auth = AuthService();
    auth.logout();
    logOutFb();
    
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget bemeDrawerPage() {
    return new Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 64.0, 32.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 90.0,
                    width: 90.0,
                    child: CircleAvatar(
                      backgroundImage: (profile_picture != null) ? NetworkImage(profile_picture) : AssetImage("assets/images/default.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name ??'default value',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "See profile",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 16.0, 40.0, 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Util.home,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Util.privacy_settings,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        onLogoutClicked();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Util.logout,
                          style: TextStyle(fontSize: 18.0, color: Colors.pink),
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Util.about,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  var scanTextStyle = TextStyle(
      color: Colors.white, fontFamily: Util.BemeTextRegular, fontSize: 13.5);

  var normalTextStyle =
      TextStyle(color: Colors.grey, fontFamily: Util.BemeBold, fontSize: 14.0);

  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

Future<bool> _removeSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }


}

import 'package:Utician/services/auth_service.dart';
import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';
import 'dart:io';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  //imageLib.Image _image;
  String name;
  String email;
  String profile_picture;
  String path;
  String username;
  Filter _filter;
  // List<Filter> filters = presetFitersList;
  String fileName;

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

    _getSharedPreferenceString("imagePath").then((storedCapturePicture) {
      if (storedCapturePicture != null) {
        setState(() {
          path = storedCapturePicture;
        });
      }
    });

       _getSharedPreferenceString("default_username").then((storedUsername) {
      if (storedUsername != null) {
        setState(() {
          username = storedUsername;
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
    return WillPopScope(
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
                  Container(child: displayFilterPage()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      makeUpFilter(),
                      Container(
                        height: 146,
                        child: cameraButton(),
                      ),
                      toneFilter()
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  makeUpFilter() {
    return new GestureDetector(
        onTap: () {
          //TODO: 
        print("whos there");
        Navigator.pushNamed(context, '/makeupfilter');
        },
        child: Column(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              child: Image.asset(
                'assets/images/makeup.png',
              ),
            ),
            SizedBox(height: 10),
            Text(Util.make_up, style: scanTextStyle)
          ],
        ));
  }

//ToneFilter 
  toneFilter() {
    return new GestureDetector(
      onTap: () {
        //TODO:
      Navigator.pushNamed(context, '/toneFilter');
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            child: Image.asset(
              'assets/images/color.png',
            ),
          ),
          SizedBox(height: 10),
          Text(Util.tone, style: scanTextStyle)
        ],
      ),
    );
  }

  displayFilterPage() {
    return new Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 480,
          child: Image.file(File(path)),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: new Text(Util.appName, style: titleStyle),
            ),
          ),
        ),
      ],
    );
  }

  cameraButton() {
    return new GestureDetector(
        onTap: () async {
          Navigator.pushNamed(context, '/dashboard');
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
   _removeSharedPreferenceString('seen');
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
                      backgroundImage: (profile_picture != null)
                          ? NetworkImage(profile_picture)
                          : AssetImage("assets/images/default.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name ?? username,
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
                          Util.see_profile,
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
                    //Home Page
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Util.home,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    // Privacy Settings
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/setting');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Util.privacy_settings,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                    Divider(),
                    // LogOut
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
                    // About
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/about');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Util.about,
                          style: TextStyle(fontSize: 18.0),
                        ),
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

  var titleStyle =
      TextStyle(color: Colors.white60, fontFamily: Util.BemeLogo, fontSize: 30);

  var scanTextStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeTextRegular, fontSize: 13.5);

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

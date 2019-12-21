import 'package:Utician/data/user.dart';
import 'package:Utician/screens/dashboard/DisplayPictureScreen.dart';
import 'package:Utician/services/auth_service.dart';
import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'dart:async';
import 'dart:io';
import 'package:torch_compat/torch_compat.dart';

List<CameraDescription> cameras;

class Dashboard extends StatefulWidget {
  final CameraDescription camera;
  final User userdata;
  Dashboard({Key key, this.userdata, this.camera}) : super(key: key);

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
  int selectedCameraIdx;

  CameraController _controller;
  Future<void> _initCamFuture;
  File _image;

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    super.initState();
    _initApp();

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

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  _initApp() async {
    final cameras = await availableCameras();
    //final firstCam = cameras.first;
    final frontCam = cameras[1];

    _controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
    );

    _initCamFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      child: accessTabScanning()
                   
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
    return new GestureDetector(
      onTap: () {
        setState(() {
          camState = !camState;
        });
      },
      child: Padding(
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
              child: new Text(Util.default_tap_activity_scan,
                  style: scanTextStyle),
            ),
          ),
        ),
      ),
    );
  }



  Widget accessTabScanning() {
    return new GestureDetector(
      onTap: () {
        setState(() {
          camState = !camState;
          print("TODO: Camera initializattion");
        });
      },
      child: new Container(
        width: double.infinity,
        height: 500,
        child: FutureBuilder<void>(
          future: _initCamFuture,
          builder: (context, snapshot) {
            return CameraPreview(_controller);
          },
        ),
      ),
    );
  }

  cameraButton() {
    return new GestureDetector(
        onTap: () async {
          print("ontap tap tap");
          await _initCamFuture;
          final path = join((await getTemporaryDirectory()). path,'${DateTime.now()}.png');
          await _controller.takePicture(path);
          _setSharedPreferenceString("imagePath", path );
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          
        
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
                      backgroundImage: (profile_picture != null)
                          ? NetworkImage(profile_picture)
                          : AssetImage("assets/images/default.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name ?? 'default value',
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

  var scanTextStyle = TextStyle(
      color: Colors.white, fontFamily: Util.BemeTextRegular, fontSize: 13.5);

  var normalTextStyle =
      TextStyle(color: Colors.grey, fontFamily: Util.BemeBold, fontSize: 14.0);


      
  Future<bool> _setSharedPreferenceString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> _removeSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}

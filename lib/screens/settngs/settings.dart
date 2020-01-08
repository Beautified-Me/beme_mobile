import 'package:Utician/services/auth_service.dart';
import 'package:Utician/services/http_service.dart';
import 'package:Utician/util/custom_dialog.dart';
import 'package:Utician/util/util.dart';
import 'package:Utician/widgets/password_textfield_icon/index.dart';
import 'package:Utician/widgets/primary_button/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  String name;
  String email;
  String profile_picture;
  String username;
  bool _isInAsyncCall = false;

  PasswordTextFieldIcon _currentpasswordField;
  PasswordTextFieldIcon _newpasswordField;
  PasswordTextFieldIcon _confirmnewpasswordField;

  final TextEditingController _currentpassword = new TextEditingController();
  final TextEditingController _newpassword = new TextEditingController();
  final TextEditingController _confirmnewpassword = new TextEditingController();

  final _recoveryKey = GlobalKey<FormState>();

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    //Current Password
    _currentpasswordField = new PasswordTextFieldIcon(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red[600],
      controller: _currentpassword,
      obscureText: true,
      hint: Util.current_password,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
    );

//new Password
    _newpasswordField = new PasswordTextFieldIcon(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red[600],
      controller: _newpassword,
      obscureText: true,
      hint: Util.new_password,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
    );

//Confirm new Password
    _confirmnewpasswordField = new PasswordTextFieldIcon(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red[600],
      controller: _confirmnewpassword,
      obscureText: true,
      hint: Util.new_password_again,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
    );

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          title: new Text(
            Util.privacy_settings,
            style: scanTextStyle,
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0.0,
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        drawer: bemeDrawerPage(),
        body: resetPasswordForm(),
      ),
    );
  }

  resetPasswordForm() {
    return new Container(
      height: double.maxFinite,
      decoration: BoxDecoration(color: Colors.white70),
      child: new Form(
        key: _recoveryKey,
        child: Column(
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(30),
                child: Text(Util.reset_password_title, style: boldTextStyle)),
            new Padding(
              padding: const EdgeInsets.all(10),
              child: _currentpasswordField,
            ),
            new Padding(
              padding: const EdgeInsets.all(10),
              child: _newpasswordField,
            ),
            new Padding(
              padding: const EdgeInsets.all(10),
              child: _confirmnewpasswordField,
            ),
            new Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: resetPasswordButton(),
            )
          ],
        ),
      ),
    );
  }

  resetPasswordButton() {
    return new PrimaryButton(
      buttonName: Util.forget_password_button,
      highlightColor: Colors.pinkAccent,
      buttonColor: Color(Util.black),
      buttonTextStyle:
          TextStyle(color: Color(Util.white), fontFamily: Util.BemeLight),
      onPressed: () {
        if (_recoveryKey.currentState.validate()) {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _isInAsyncCall = true;
          });
          onRecoveryPressed();
        }
      },
    );
  }

  onRecoveryPressed() {
    var http = HttpService();
    http
        .postApiResetPassword(
            _currentpassword.text, _newpassword.text, _confirmnewpassword.text)
        .then((resetPasswordSuccess) {
      if (resetPasswordSuccess != null) {
        print("Reset Password: OK");
        successDialog();
        Navigator.pushNamed(context, '/login');
        
      } else {
        print("Reset Password : Fail");
        alertDialog();
        setState(() {
          _isInAsyncCall = false;
        });
      }
    });
  }

  void successDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
              title: Util.success_title,
              description: Util.reset_password_title,
              buttonText: Util.ok,
              icon: Icons.email,
              color: Color(Util.white),
              iconColor: Color(Util.green),
            ));
  }

  void alertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
              title: Util.login_error_title,
              description: Util.reset_password_alert,
              buttonText: Util.ok,
              icon: Icons.error_outline,
              color: Color(Util.white),
              iconColor: Color(Util.red),
            ));
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

  var titleStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeLogo, fontSize: Util.bemeSize);

  var boldTextStyle = TextStyle(
      fontFamily: Util.BemeMediumRegular, fontSize: Util.bemeTabTextSize);

  var connectionTextStyle = TextStyle(
      color: Color(Util.white), fontFamily: Util.BemeRegular, fontSize: 15);

  var background = (BuildContext context) => new DecorationImage(
      image: new AssetImage("assets/images/login.png"), fit: BoxFit.cover);

  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> _removeSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}

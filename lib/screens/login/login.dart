import 'dart:async';

import 'package:Utician/util/app_version.dart';
import 'package:Utician/util/util.dart';
import 'package:Utician/util/validator.dart';
import 'package:Utician/widgets/email_textfield_icon/index.dart';
import 'package:Utician/widgets/password_textfield_icon/index.dart';
import 'package:Utician/widgets/primary_button/index.dart';
import 'package:Utician/widgets/user_textfield_icon/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  UserTextFieldIcon _userField;
  PasswordTextFieldIcon _passwordField;
  EmailTextFieldIcon _emailField;

  final TextEditingController _username = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _connectionStatus = 'unknown';
  String _connections = '';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  TabController _controller;

  final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.ACTION_WIFI_SETTINGS',
      package: 'com.gis.beme',
      data: 'package:com.gis.beme');

  @override
  void initState() {

    // username 
    _userField = new UserTextFieldIcon(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _username,
      hint: Util.username,
      icon: Icon(Icons.access_alarms),
      inputType: TextInputType.text,
      validator: Validator.validateName,
    );

    //Password 
    _passwordField = new PasswordTextFieldIcon(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _password,
      obscureText: true,
      hint: Util.password,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
      validator: Validator.validatePassword,
    );

    //email 
    _emailField = new EmailTextFieldIcon(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _email,
      hint: Util.email,
      icon: Icon(Icons.email),
      inputType: TextInputType.emailAddress,
      validator: Validator.validateEmail,

    );

    super.initState();
    _controller = new TabController(length: 2, vsync: this);

    initConnectionState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.none) {
        setState(() {
          showInSnackBar(Util.network_error, context);
        });
      }
    });
  }

  initConnectionState() async {
    String connection;
    try {
      final result = await InternetAddress.lookup(Util.BASE_DEVELOPMENT_URL);
      if (result.isEmpty && result[0].rawAddress.isEmpty) {
        connection = Util.network_error;
      }
    } on SocketException catch (_) {
      print(Util.network_error);
    }

    if (!mounted) return;
    setState(() {
      _connections = connection;
    });
  }

  // void _onLoading() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: new Padding(
  //           padding: const EdgeInsets.all(30.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               new CircularProgressIndicator(),
  //               new Text("Server Error . Please Try Again"),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   new Future.delayed(new Duration(seconds: 1000000), () {
  //     Navigator.pop(context); //pop dialog
  //   });
  // }

  void showInSnackBar(String value, BuildContext context) {
    final snackBar = SnackBar(
        content: new SingleChildScrollView(
            child: new Text(value, style: connectionTextStyle)),
        action: new SnackBarAction(
          label: Util.setting,
          textColor: Color(Util.white),
          onPressed: () => intent.launch(),
        ),
        backgroundColor: Colors.redAccent);

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    subscription.cancel();
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
                onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text(Util.yes),
              ),
              new FlatButton(
                onPressed: () =>
                Navigator.of(context).pop(false),
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
        child: new Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          body: Container(
            padding: EdgeInsets.only(
                top: 70, left: 30, right: 30, bottom: 30),
            decoration: BoxDecoration(image: background(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                appLogo(),
                loginRegisteration(),
                ssoButton(),
                AppVersion()
              ],
            ),
          ),
        ));
  }

  appLogo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[Text(Util.appName, style: titleStyle)]);
  }

  loginRegisteration() {
    return Column(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
              color: Colors.grey[500],
              border: Border(
                  right: BorderSide(
                      color: Colors.grey, width: 1, style: BorderStyle.solid))),
          child: new TabBar(
            indicator: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Color(Util.main_default_primary),
                    width: 0.5,
                    style: BorderStyle.solid), // provides to left side
                right: BorderSide(
                    color: Color(Util.main_default_primary),
                    width: 0.5,
                    style: BorderStyle.solid), // for right side
              ),
            ),
            labelPadding: EdgeInsets.all(0),
            indicatorPadding: EdgeInsets.all(0),
            indicatorColor: Color(Util.main_default_primary),
            labelColor: Color(Util.main_default_primary),
            unselectedLabelColor: Colors.white,
            labelStyle: boldTextStyle,
            controller: _controller,
            tabs: [
              new Container(
                  width: 158, height: 52, child: new Tab(text: Util.signIn)),
              new Container(
                  width: 158, height: 52, child: new Tab(text: Util.register))
            ],
          ),
        ),
        new Container(
          height: 270.0,
          decoration: BoxDecoration(color: Colors.white70),
          child: new TabBarView(
            controller: _controller,
            children: <Widget>[
              new Padding(
                  //TODO: LOGIN
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  child: new ListView(
                    children: <Widget>[
                      new Padding(padding: const EdgeInsets.only(bottom: 5.0), child: _userField),
                      new Padding(padding: const EdgeInsets.only(top: 15.0), child: _passwordField),
                      new Padding(padding: const EdgeInsets.all(15), child: loginButton()),      
                      new Padding(padding: const EdgeInsets.all(0), child: resetPassword()) ],
                  ),
                ),
              new Padding(
                  //TODO: REGISTER
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  child: new ListView(
                    children: <Widget>[
                      new Padding(padding: const EdgeInsets.only(bottom: 5.0), child: _userField),
                      new Padding(padding: const EdgeInsets.all(0), child: _emailField),
                      new Padding(padding: const EdgeInsets.only(top: 5.0), child: _passwordField),
                      new Padding(padding: const EdgeInsets.all(15), child: registerButton())
                    ],
                  ),
              )
            ]
          ),
        )
      ],
    );
  }

    loginButton() {
      return new PrimaryButton(
        buttonName: Util.signIn,
        buttonColor: Color(Util.main_default_primary),
        buttonTextStyle: TextStyle(
            color: Color(Util.white),
            fontFamily: Util.BemeLight),
        onPressed: () {
          // if (_formKey.currentState.validate()) {
          //   onLoginPressed();
          // }
        },
      );
    }

    registerButton() {
      return new PrimaryButton(
        buttonName: Util.register,
        buttonColor: Color(Util.main_default_primary),
        buttonTextStyle: TextStyle(
            color: Color(Util.white),
            fontFamily: Util.BemeLight),
        onPressed: () {
          // if (_formKey.currentState.validate()) {
          //   onLoginPressed();
          // }
        },
      );
    }


  ssoButton() {
    return Container(
      child: FacebookSignInButton(
        onPressed: (){},
      ),
    );
  }
  
  resetPassword(){
    return new Center(
    child: GestureDetector(
        child: Text(
          Util.forget_password, style: TextStyle(color: Color(Util.grey), fontWeight: FontWeight.w100),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/forgetpassword');
        },
      )
    );
    
  }

  // Styles
  var titleStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeLogo, fontSize: Util.bemeSize);

  var boldTextStyle = TextStyle(
      fontFamily: Util.BemeMediumRegular, fontSize: Util.bemeTabTextSize);

  var connectionTextStyle = TextStyle(
      color: Color(Util.white), fontFamily: Util.BemeRegular, fontSize: 15);

  var background = (BuildContext context) => new DecorationImage(
      image: new AssetImage("assets/images/login.png"),
      fit: BoxFit.cover);
}

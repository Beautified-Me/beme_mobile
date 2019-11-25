import 'package:Utician/services/http_service.dart';
import 'package:Utician/util/app_version.dart';
import 'package:Utician/util/custom_dialog.dart';
import 'package:Utician/util/util.dart';
import 'package:Utician/util/validator.dart';
import 'package:Utician/widgets/email_textfield_icon/index.dart';
import 'package:Utician/widgets/primary_button/index.dart';
import 'package:Utician/widgets/user_textfield_icon/user_textfield_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  
  UserTextFieldIcon  _userTextField;
  EmailTextFieldIcon _emailTextField;

  final TextEditingController _username = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _recoveryKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userTextField = new UserTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _username,
      obscureText: true,
      hint: Util.username,
      icon: Icon(Icons.lock),
      inputType: TextInputType.text,
      validator: Validator.validatePassword,
    );

    _emailTextField = new EmailTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _email,
      obscureText: true,
      hint: Util.email,
      icon: Icon(Icons.lock),
      inputType: TextInputType.emailAddress,
      validator: Validator.validatePassword,
    );

    
    super.initState();
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
      child: new Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 70, left: 30, right: 30, bottom: 30),
          decoration: BoxDecoration(image: background(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              appLogo(),
              forgetPasswordForm(),
              backLogin(),
              AppVersion()
            ],
          ),
        ),
      ),
    );
  }

  appLogo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[Text(Util.appName, style: titleStyle)]);
  }

  forgetPasswordForm() {
    return Container(
      height: 380,
      decoration: BoxDecoration(color: Colors.white70),
      child: new Form(
        key: _recoveryKey,
        child: Column(
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(30),
                child: Text(Util.forget_password_title, style: boldTextStyle)),
            new Padding(
              padding: const EdgeInsets.all(10),
              child: _userTextField,
            ),
            new Padding(
              padding: const EdgeInsets.all(10),
              child: _emailTextField,
            ),
            // new Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: _newPasswordAgainField),
            new Padding(
              padding: const EdgeInsets.all(5),
              child: forgetPasswordButton(),
            )
          ],
        ),
      ),
    );
  }

  forgetPasswordButton() {
    return new PrimaryButton(
      buttonName: Util.forget_password_button,
      highlightColor: Colors.pinkAccent,
      buttonColor: Color(Util.main_default_primary),
      buttonTextStyle:
          TextStyle(color: Color(Util.white), fontFamily: Util.BemeLight),
      onPressed: () {
        if (_recoveryKey.currentState.validate()) {
          onRecoveryPressed();
        }
      },
    );
  }

  onRecoveryPressed() {
  var http = HttpService();
    http
        .postAuthForgotPassword(_username.text, _email.text)
        .then((forgetPasswordSuccess) {
      if (forgetPasswordSuccess != null) {
        print("Registeration: OK");
        successDialog();
      } else {
        print("Registeration: Fail");
        alertDialog();
      }
    });
  }


  void successDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
              title: Util.login_error_title,
              description: Util.message_activation,
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
              description: Util.login_error_description,
              buttonText: Util.ok,
              icon: Icons.error_outline,
              color: Color(Util.white),
              iconColor: Color(Util.red),
            ));
  }



  backLogin() {
    return new Center(
      child: GestureDetector(
          child: Text(
            Util.backButton,
            style: connectionTextStyle,
          ),
          onTap: () {
            Navigator.pop(context);
          }),
    );
  }

  var titleStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeLogo, fontSize: Util.bemeSize);

  var boldTextStyle = TextStyle(
      fontFamily: Util.BemeMediumRegular, fontSize: Util.bemeTabTextSize);

  var connectionTextStyle = TextStyle(
      color: Color(Util.white), fontFamily: Util.BemeRegular, fontSize: 15);

  var background = (BuildContext context) => new DecorationImage(
      image: new AssetImage("assets/images/login.png"), fit: BoxFit.cover);
}

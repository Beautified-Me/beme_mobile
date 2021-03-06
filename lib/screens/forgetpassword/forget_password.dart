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
import 'package:modal_progress_hud/modal_progress_hud.dart';


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

  bool _isInAsyncCall = false;

  @override
  void initState() {
    _userTextField = new UserTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red[600],
      controller: _username,
      hint: Util.username,
      icon: Icon(Icons.lock),
      inputType: TextInputType.text,
      validator: Validator.validatePassword,
    );

    _emailTextField = new EmailTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red[600],
      controller: _email,
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
      child: new ModalProgressHUD( 
          opacity: 0.4,
          color: Colors.pinkAccent,
          inAsyncCall: _isInAsyncCall,
          progressIndicator: CircularProgressIndicator(),
        child:  new Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 30),
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
    )
    );
  }

  appLogo() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[Text(Util.appName, style: titleStyle)]);
  }

  forgetPasswordForm() {
    return Container(
      height: 400,
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
            new Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
        .postAuthForgotPassword(_username.text, _email.text)
        .then((forgetPasswordSuccess) {
      if (forgetPasswordSuccess != null) {
        print("Registeration: OK");
        Navigator.pushNamed(context, '/login');
        successDialog();
      } else {
        print("Registeration: Fail");
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
              description: Util.current_username_email,
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

import 'package:Utician/util/app_version.dart';
import 'package:Utician/util/util.dart';
import 'package:Utician/util/validator.dart';
import 'package:Utician/widgets/password_textfield_icon/index.dart';
import 'package:Utician/widgets/primary_button/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  PasswordTextFieldIcon _currentPasswordField;
  PasswordTextFieldIcon _newPasswordField;
  PasswordTextFieldIcon _newPasswordAgainField;

  final TextEditingController _currentPassword = new TextEditingController();
  final TextEditingController _newPassword = new TextEditingController();
  final TextEditingController _confirmPassword = new TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _currentPasswordField = new PasswordTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _currentPassword,
      obscureText: true,
      hint: Util.current_password,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
      validator: Validator.validatePassword,
    );

    _newPasswordField = new PasswordTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _newPassword,
      obscureText: true,
      hint: Util.new_password,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
      validator: Validator.validatePassword,
    );

    _newPasswordAgainField = new PasswordTextFieldIcon(
      borderColor: Colors.grey[400],
      errorColor: Colors.red,
      controller: _confirmPassword,
      obscureText: true,
      hint: Util.new_password_again,
      icon: Icon(Icons.lock),
      inputType: TextInputType.visiblePassword,
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
      child: new Column(
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.all(30),
              child: Text(Util.forget_password_title, style: boldTextStyle)),
          new Padding(
            padding: const EdgeInsets.all(10),
            child: _currentPasswordField,
          ),
          new Padding(
            padding: const EdgeInsets.all(10),
            child: _newPasswordField,
          ),
          new Padding(
              padding: const EdgeInsets.all(10), child: _newPasswordAgainField),
          new Padding(
            padding:  const EdgeInsets.all(5), child: forgetPasswordButton(),
          )    
        ],
      ),
    );
  }

forgetPasswordButton(){
  return new PrimaryButton(
        buttonName: Util.forget_password_button,
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
  backLogin() {
    return new Center(
      child: GestureDetector( child: Text(Util.backButton, style: connectionTextStyle,) , onTap: () {Navigator.pop(context);} ),
      
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

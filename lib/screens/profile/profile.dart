import 'dart:async';
import 'dart:io';

import 'package:Utician/services/http_service.dart';
import 'package:Utician/util/util.dart';
import 'package:Utician/widgets/primary_button/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final _profileKey = GlobalKey<FormState>();
  bool _isInAsyncCall = false;

  String name, email, profile_picture, username;

  final TextEditingController _username = new TextEditingController();
  final TextEditingController _age = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _address1 = new TextEditingController();
  final TextEditingController _address2 = new TextEditingController();

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          Util.profile,
          style: scanTextStyle,
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.done,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     updateProfileButton();
          //   },
          // )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        centerTitle: true,
      ),
      body: new EditProfileScreen(),
    );
  }



  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  var scanTextStyle = TextStyle(
      color: Colors.white, fontFamily: Util.BemeTextRegular, fontSize: 15.5);

  var normalTextStyle =
      TextStyle(color: Colors.black, fontFamily: Util.BemeBold, fontSize: 14.0);

  var textStyle = TextStyle(
      color: Colors.black, fontFamily: Util.BemeTextRegular, fontSize: 13.5);
}

class EditProfileScreen extends StatefulWidget {
  @override
  State createState() => new EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  File avatarImageFile, backgroundImageFile;
  String sex, name, email, address1, address2;

  final TextEditingController _username = new TextEditingController();
  final TextEditingController _email = new TextEditingController();

  Future getImage(bool isAvatar) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isAvatar) {
        avatarImageFile = result;
      } else {
        backgroundImageFile = result;
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

    
  }

  updateProfileButton() {
    return new PrimaryButton(
      buttonName: Util.update_profile,
      highlightColor: Colors.black,
      buttonColor: Color(Util.black),
      buttonTextStyle:
          TextStyle(color: Color(Util.white), fontFamily: Util.BemeLight),
      onPressed: () {
        //TODO:
        var http = HttpService();
        http.postApiUserProfile(name, email, address1, address2, age, phonenumber, sex).then(sucessProfile)

      
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Stack(
                  children: <Widget>[
                    // Background
                    (backgroundImageFile == null)
                        ? new Container(
                            // 'images/bg_uit.jpg',
                            width: double.infinity,
                            height: 150.0,
                            color: Colors.black
                            // fit: BoxFit.cover,
                            )
                        : new Image.file(
                            backgroundImageFile,
                            width: double.infinity,
                            height: 150.0,
                            fit: BoxFit.cover,
                          ),

                    // Button change background
                    new Positioned(
                      child: new Material(
                        child: new IconButton(
                          icon: new Icon(
                            Icons.camera,
                            // width: 30.0,
                            // height: 30.0,
                            // fit: BoxFit.cover,
                          ),
                          onPressed: () => getImage(false),
                          padding: new EdgeInsets.all(0.0),
                          highlightColor: Colors.black,
                          iconSize: 30.0,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(30.0)),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      right: 5.0,
                      top: 5.0,
                    ),

                    // Avatar and button Profile Picture
                    new Positioned(
                      child: new Stack(
                        children: <Widget>[
                          (avatarImageFile == null)
                              ? new Container(
                                  width: 100.0,
                                  height: 100.0,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/default.png"),
                                  ))
                              : new Material(
                                  // child: new Image.file(
                                  //   avatarImageFile,
                                  //   width: 70.0,
                                  //   height: 70.0,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          new FileImage(avatarImageFile),
                                    ),
                                  ),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(60.0)),
                                ),
                          new Material(
                            child: new IconButton(
                              icon: new Image.asset(
                                'images/ic_camera.png',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                              onPressed: () => getImage(true),
                              padding: new EdgeInsets.all(0.0),
                              highlightColor: Colors.black,
                              iconSize: 70.0,
                            ),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(60.0)),
                            color: Colors.grey.withOpacity(0.0),
                          ),
                        ],
                      ),
                      top: 100.0,
                      left: MediaQuery.of(context).size.width / 2 - 70 / 2,
                    )
                  ],
                ),
                width: double.infinity,
                height: 200.0,
              ),
              new Column(
                children: <Widget>[
                  // Username
                  new Container(
                    child: new Text(
                      Util.profile_name,
                      style: normalTextStyle,
                    ),
                    margin:
                        new EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  new Container(
                    child: new TextFormField(
                      controller: _username,
                      decoration: new InputDecoration(
                          hintText: name ?? 'Please Enter Your Name',
                          border: new UnderlineInputBorder(),
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: textStyle),
                    ),
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // Email Address
                  new Container(
                    child: new Text(
                      Util.profile_email,
                      style: normalTextStyle,
                    ),
                    margin:
                        new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                          hintText: email  ??'Please Enter Your Email Address',
                          border: new UnderlineInputBorder(),
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: textStyle),
                    ),
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  //Age
                  new Container(
                    child: new Text(
                      Util.profile_age,
                      style: normalTextStyle,
                    ),
                    margin:
                        new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                            hintText: 'Please Enter your Age',
                            border: new UnderlineInputBorder(),
                            contentPadding: new EdgeInsets.all(5.0),
                            hintStyle: textStyle),
                      ),
                      margin: new EdgeInsets.only(left: 30.0, right: 30.0)),

                  // Address
                  new Container(
                    child: new Text(
                      Util.profile_address_one,
                      style: normalTextStyle,
                    ),
                    margin:
                        new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                          hintText: 'Please Enter Home/Office address',
                          border: new UnderlineInputBorder(),
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: textStyle),
                    ),
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // Address
                  new Container(
                    child: new Text(
                      Util.profile_address_two,
                      style: normalTextStyle,
                    ),
                    margin:
                        new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                          hintText: '',
                          border: new UnderlineInputBorder(),
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: textStyle),
                    ),
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // Phone Number
                  new Container(
                    child: new Text(
                      Util.profile_phone,
                      style: normalTextStyle,
                    ),
                    margin:
                        new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                    child: new TextFormField(
                      decoration: new InputDecoration(
                          hintText: '0123456789',
                          border: new UnderlineInputBorder(),
                          contentPadding: new EdgeInsets.all(5.0),
                          hintStyle: textStyle),
                      keyboardType: TextInputType.number,
                    ),
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                  ),

                  // Sex
                  new Container(
                    child:
                        new Text(Util.profile_gender, style: normalTextStyle),
                    margin:
                        new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                    child: new DropdownButton<String>(
                      items: <String>['Male', 'Female'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sex = value;
                        });
                      },
                      hint: sex == null
                          ? new Text('Male')
                          : new Text(
                              sex,
                              style: new TextStyle(color: Colors.black),
                            ),
                      style: new TextStyle(color: Colors.black),
                    ),
                    margin: new EdgeInsets.only(left: 50.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )
            ],
          ),
          padding: new EdgeInsets.only(bottom: 20.0),
        ));
  }

  var scanTextStyle = TextStyle(
      color: Colors.white, fontFamily: Util.BemeTextRegular, fontSize: 15.5);

  var normalTextStyle =
      TextStyle(color: Colors.black, fontFamily: Util.BemeBold, fontSize: 14.0);

  var textStyle = TextStyle(
      color: Colors.black54, fontFamily: Util.BemeTextRegular, fontSize: 13.5);

  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

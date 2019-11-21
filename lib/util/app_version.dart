import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

class AppVersion extends StatefulWidget {
  @override
  _AppVersionState createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  String _appVersion = "";

  @override
  void initState(){
    super.initState();
    initVersionState();
  }

  initVersionState() async {
    String appVersion; 
    try {
      appVersion = await GetVersion.projectVersion;
    }on PlatformException { 
      appVersion = Util.projectCodeError;
    }

    if(!mounted) return;
    setState(() {
      _appVersion = appVersion;
    });
  }

  @override
 @override
  Widget build(BuildContext context) {
    return new Center( 
     child: new Text("Version " + _appVersion, style: appStyle),
     );
  }

  var appStyle = new TextStyle(
      color: Color(Util.grey), fontFamily: Util.BemeLight, fontSize: 10.0);
      
}
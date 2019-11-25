import 'package:Utician/services/auth_service.dart';
import 'package:Utician/util/util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const _kFontFam = 'MyFlutterApp';
  static const IconData logout = const IconData(0xe800, fontFamily: _kFontFam);


  @override
  void initState() {
    super.initState();
    // _getSharedPreferenceString(Util.staffcode).then((storedCode) {
    //   if (storedCode != null) {
    //     setState(() {
    //       staffCode = storedCode;
    //     });
    //   }
    // });

    // _getSharedPreferenceString(Util.staffName).then((storedName) {
    //   if (storedName != null) {
    //     setState(() {
    //       staffName = storedName;
    //     });
    //   }
    // });
  }

  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Color(Util.white))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              new IconButton(
                icon: new Icon(logout),
                onPressed: () => onLogoutClicked(),
              )
            ],
          ),
          drawer: bemeDrawerPage(),
          body: new Container(
            padding: EdgeInsets.only(top: 3, left: 30, right: 30, bottom: 10),
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Camera
                  
                //Camera Target
              ],
            ),
          ),
        ),
      ],
    );
  }


  
  profilePictureSection() {
    var theme = Theme.of(context);
    return new Container(
      width: 90.0,
      height: 90.0,
      decoration: new BoxDecoration(
        color: Colors.transparent,
        image: new DecorationImage(
          image: new AssetImage('assets/images/defaultProfilePicture.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
        border: new Border.all(
          color: theme.primaryColor,
          width: 2.5,
        ),
      ),
    );
  }

  dashboardMenuSection() {
    var theme = Theme.of(context);
    return new Container(
      height: 130.0,
      decoration: new BoxDecoration(
          color: Color(Util.white),
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: ListView(
        children: <Widget>[
          ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/inbound');
              },
              leading: Container(
                child: new Icon(Icons.local_mall, color: theme.primaryColor),
              ),
              title: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(Util.goodInbound, style: normalTextStyle)),
              trailing: Icon(Icons.keyboard_arrow_right)),
          new Divider(),
          ListTile(
              leading: Container(
                child: new Icon(
                  Icons.store_mall_directory,
                  color: theme.primaryColor,
                ),
              ),
              title: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(Util.putaway, style: normalTextStyle)),
              trailing: Icon(
                Icons.keyboard_arrow_right,
              )),
        ],
      ),
    );
  }

  onLogoutClicked() {
    var auth = AuthService();
    auth.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget bemeDrawerPage() {
    return new Drawer();
  }

// Future<void> _optionsDialogBox() {
//   return showDialog(context: context,
//     builder: (BuildContext context) {
//         return AlertDialog(
//           content: new SingleChildScrollView(
//             child: new ListBody(
//               children: <Widget>[
//                 GestureDetector(
//                   child: new Text(Util.take_picture),
//                   onTap: openCamera,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                 ),
//                 GestureDetector(
//                   child: new Text(Util.select_gallery),
//                   onTap: openGallery,
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }


  var normalTextStyle = TextStyle(
      color: Colors.grey, fontFamily: Util.BemeBold, fontSize: 14.0);

  var floorTextStyle = TextStyle(
    color: Colors.grey,
    fontFamily: Util.BemeRegular,
    fontSize: 11.0,
  );

  // var background = (BuildContext context) => new DecorationImage(
  //     image: new AssetImage("assets/images/background.png"),
  //     colorFilter:
  //         ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.overlay),
  //     fit: BoxFit.cover,
  //     alignment: Alignment.topCenter);

  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

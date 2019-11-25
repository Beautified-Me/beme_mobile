import 'package:Utician/models/onboard.dart';
import 'package:Utician/util/util.dart';
import 'package:Utician/widgets/secondary_button/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatefulWidget {
  final SharedPreferences prefs;

  final List<Onboard> pages = [
    Onboard(
      image: new AssetImage("assets/images/icon3.png"),
      title: Util.onboardingOneTitle,
      description: Util.onboardingOneDesc,
    ),
    Onboard(
      image: new AssetImage("assets/images/icononboard.png"),
      title: Util.onboardingTwoTitle,
      description: Util.onboardingTwoDesc,
    ),
  ];

  Onboarding({this.prefs});
  
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper.children(
        autoplay: false,
        index: 0,
        loop: false,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          builder: new DotSwiperPaginationBuilder(
              color: Color(Util.white30),
              activeColor: Color(Util.white),
              size: 5.0,
              activeSize: 9.0),
        ),
        control: SwiperControl(iconNext: null, iconPrevious: null),
        children: _getPages(context),
      ),
    );
  }

  List<Widget> _getPages(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.pages.length; i++) {
      Onboard page = widget.pages[i];
      widgets.add(new Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage("assets/images/makeup1.jpg"),
          fit: BoxFit.cover,
        )),
        child: new Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            width: 325,
            height: 540,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              ),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child:
                      new Image(image: page.image, width: 100.0, height: 100.0),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                  child: Text(
                    page.title,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(Util.purple),
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: Util.BemeRegular,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    page.description,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(Util.purple),
                      decoration: TextDecoration.none,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: Util.BemeRegular,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: page.extraWidget,
                )
              ],
            ),
          ),
        ),
      ));
    }
    widgets.add(
      new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/makeup1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            width: 325,
            height: 540,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
                bottomRight: const Radius.circular(10.0),
              ),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new Image(
                    image: new AssetImage("assets/images/icon.png"),
                    width: 100,
                    height: 100,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
                  child: Text(
                    Util.onboardingThreeTitle,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(Util.purple),
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: Util.BemeRegular,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Text(
                    Util.onboardingThreeDesc,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(Util.purple),
                      decoration: TextDecoration.none,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: Util.BemeRegular,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15.0, left: 15.0),
                  child: SecondaryButton(
                    title: Util.continueButton,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.white,
                    onPressed: () {
                      //widget.prefs.setBool('seen', true);
                      Navigator.of(context).pushNamed("/login");
                    },
                    splashColor: Colors.black12,
                    borderColor: Colors.white,
                    borderWidth: 2,
                    color: Color(Util.purple),
                    highlightColor: Colors.deepPurple[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return widgets;
  }
}

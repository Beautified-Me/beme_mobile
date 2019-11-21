import "package:flutter/material.dart";

class Onboard {
  AssetImage image;
  String title;
  String description;
  Widget extraWidget;
  
  Onboard({this.image, this.title, this.description, this.extraWidget}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}
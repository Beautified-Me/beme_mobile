import 'package:Utician/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  SharedPreferences.getInstance().then((prefs) {
    runApp(App(prefs: prefs));
  });
}
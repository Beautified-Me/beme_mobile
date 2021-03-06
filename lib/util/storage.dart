import 'package:shared_preferences/shared_preferences.dart';

class Storage { 
   Future<String> getSharedPreferenceString(String key) async { 
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return prefs.getString(key);
   }

   Future<bool> setSharedPreferenceString(String key, String value) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return  await prefs.setString(key, value);
   }

   Future<bool> removeSharedPreferenceString(String key, String value) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return await prefs.remove(key);
   }
}
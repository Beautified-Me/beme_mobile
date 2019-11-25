import 'package:Utician/services/http_service.dart';
import 'package:Utician/util/storage.dart';
import 'package:Utician/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  bool _loggedIn = false;
  String _token;
  Storage str = new Storage();
  

  final _loginStatusSubject = new BehaviorSubject<bool>.seeded(false);

  Stream<bool> get loginStatus => _loginStatusSubject.stream;

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    //  INIT: Auth
    _getSharedPreferenceString(Util.token).then((storedToken) {
      if (storedToken != null) {
        _token = storedToken;
        _loggedIn = true;
      }
    });
  }


  Future<bool> login(String username, String password) async {
    var http = HttpService();
    try {
      var loginResponse =
          await http.postAuthLogin(username, password);
      if (loginResponse != null) {
        print("Successfully logged in! Token -> ${loginResponse.authToken}");

        _loggedIn = true;
        _token = loginResponse.authToken;
 

        _setSharedPreferenceString(Util.token, _token);
        _loginStatusSubject.add(_loggedIn);

        return true;
      }
    } catch (e) {
      print("Failed to login! " + e.toString());
    }

    return false;
  }

  logout() {
    _loggedIn = false;
    _token = null;


    _removeSharedPreferenceString(Util.token);
    _loginStatusSubject.add(_loggedIn);
  }

  get loggedIn => _loggedIn;
  get token => _token;


  // SECTION: Util
  Future<String> _getSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> _setSharedPreferenceString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  Future<bool> _removeSharedPreferenceString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

 
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class HttpService {
  String _baseUrl;
  AuthService _auth;

  static final HttpService _instance = HttpService._internal();
  factory HttpService() {
    return _instance;
  }

  HttpService._internal()
      : _baseUrl = Util.BASE_URL,
        _auth = AuthService();



  //Login
  Future<AuthLoginResponse> postAuthLogin(
      String companyId, String username, String password) async {
    var response = await _post(Util.ENDPOINT_AUTH_LOGIN, body: {
      'appPlatformProductCode': Util.appPlatformProductCode,
      'companyId': companyId,
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      if (response.body != null && response.body.length > 0) {
        return AuthLoginResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } else {
      print("Response: (${response.statusCode})" + response.body);
      throw Exception('Failed to load post');
    }
  }


  //POST
  Future<http.Response> _post(String urn, {Map<String, dynamic> body}) {
    var bodyJson = json.encode(body);

    var headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
      HttpHeaders.acceptHeader: ContentType.json.mimeType
    };

    if (_auth.loggedIn) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${_auth.token}';
    }

    return http.post(_baseUrl + urn, headers: headers, body: bodyJson);
  }

  //GET
  Future<http.Response> _get(String urn) {
    var headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
      HttpHeaders.acceptHeader: ContentType.json.mimeType
    };

    if (_auth.loggedIn) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ${_auth.token}';
    }

    return http.get(_baseUrl + urn, headers: headers);
  }
}





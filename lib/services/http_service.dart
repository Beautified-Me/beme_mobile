import 'dart:async';
import 'dart:convert';
import 'package:Utician/data/auth.dart';
import 'package:Utician/data/profile.dart';
import 'package:Utician/data/register.dart';
import 'package:Utician/util/util.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'auth_service.dart';

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
      String username, String password) async {
    var response = await _post(Util.ENDPOINT_AUTH_LOGIN, body: {
      'userName': username,
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

  //Registeration
  Future<AuthRegisterResponse> postAuthRegisteration(
      String username, String email, String password) async {
    var response = await _post(Util.ENDPOINT_AUTH_REGISTER, body: {
      'userName': username,
      'userEmail': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      if (response.body != null && response.body.length > 0) {
        return AuthRegisterResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } else {
      print("Response: (${response.statusCode})" + response.body);
      return null;
    }
  }

  //Forget Password
  Future<AuthRegisterResponse> postAuthForgotPassword(
      String username, String email) async {
    var response = await _post(Util.ENDPOINT_AUTH_FORGOTPASSWORD, body: {
      'userName': username,
      'email': email,
    });

    if (response.statusCode == 200) {
      if (response.body != null && response.body.length > 0) {
        return AuthRegisterResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } else {
      print("Response: (${response.statusCode})" + response.body);
      //throw Exception('Failed to load post');
      return null;
    }
  }

  // Reset Password
  Future<AuthRegisterResponse> postApiResetPassword(
      String password, String newpassword, String confirmnewpassword) async {
    var response = await _post(Util.ENDPOINT_AUTH_RESETPASSWORD, body: {
      'currentPass': password,
      'newPassword': newpassword,
      'newPasswordAgain': confirmnewpassword
    });

    if (response.statusCode == 200) {
      if (response.body != null && response.body.length > 0) {
        return AuthRegisterResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } else {
      print("Response: (${response.statusCode})" + response.body);
      //throw Exception('Failed to load post');
      return null;
    }
  }

  // User Profile
  Future<AuthUserProfileResponse> postApiUserProfile(
      String gender,
      String age,
      String phonenumber,
      String address1,
      String address2,
      String name,
      String email) async {
    var response = await _post(Util.ENDPOINT_API_USERPROFILE, body: {
      'gender': gender,
      'age': age,
      'phoneNo': phonenumber,
      'address1': address1,
      'address2': address2,
      'name': name,
      'email': email
    });

    if (response.statusCode == 200) {
      if (response.body != null && response.body.length > 0) {
        return AuthUserProfileResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } else {
      print("Response: (${response.statusCode})" + response.body);
      //throw Exception('Failed to load post');
      return null;
    }
  }

  //POST HEADER
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

  //GET HEADER
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

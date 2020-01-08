class AuthLoginResponse {
  bool status;
  int code;
  String message;
  String authToken;
  String userName;
  String email;

  AuthLoginResponse(this.status, this.code, this.message, this.authToken,
      this.userName, this.email);
  AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    this.status = json["success"];
    this.code = json["code"];
    this.message = json["message"];
    this.authToken = json["access_token"];
    this.userName = json["userName"];
    this.email = json["email"];
  }
}

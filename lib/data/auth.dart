class AuthLoginResponse {
  String authToken;
  int expiresIn;
  String userName;
  String email;

  AuthLoginResponse(this.authToken, this.expiresIn, this.userName, this.email);
  AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    this.authToken = json["access_token"];
    this.expiresIn = json["expiresInTime"];
    this.userName = json["userName"];
    this.email = json["email"];
  }
}

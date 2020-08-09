
class AuthUserProfileResponse {
  String message;
  String status;
  int code;

  AuthUserProfileResponse(this.message, this.status, this.code);

  AuthUserProfileResponse.fromJson(Map<String, dynamic> json){
    this.message = json["message"];
    this.status = json["status"];
    this.code = json["code"];
  }

}

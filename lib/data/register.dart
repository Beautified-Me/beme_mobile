class AuthRegisterResponse {
  String message;


  AuthRegisterResponse(this.message);

  AuthRegisterResponse.fromJson(Map<String, dynamic> json) {
    this.message = json["message"];
  }
}

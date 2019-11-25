class AuthRegisterResponse {
  String message;
  bool success;

  AuthRegisterResponse(this.message, this.success);

  AuthRegisterResponse.fromJson(Map<String, dynamic> json) {
    this.message = json["message"];
    this.success = json["success"];
  }
}

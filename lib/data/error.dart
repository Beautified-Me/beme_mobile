class errorResponse {
  String message;
  bool success;
  int code; 

  errorResponse(this.message, this.success, this.code);

  errorResponse.fromJson(Map<String, dynamic> json){
    this.message = json["message"];
    this.success = json["success"];
    this.code = json["code"];
  }
}
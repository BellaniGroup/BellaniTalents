import 'dart:convert';

UserRegisteredResponse UserRegisteredResponseApiFromJson(String str) => UserRegisteredResponse.fromJson(json.decode(str));
String UserRegisteredResponseApiToJson(UserRegisteredResponse data) => json.encode(data.toJson());

class UserRegisteredResponse {
  UserRegisteredResponse({
    required this.token,
    required this.status,
  });
  late final String token;
  late final String status;
  
  UserRegisteredResponse.fromJson(Map<String, dynamic> json){
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['status'] = status;
    return _data;
  }
}
import 'dart:convert';

UserLoginResponse UserLoginResponseApiFromJson(String str) => UserLoginResponse.fromJson(json.decode(str));
String UserLoginResponseApiToJson(UserLoginResponse data) => json.encode(data.toJson());

class UserLoginResponse {
  UserLoginResponse({
    required this.talent,
    required this.token,
    required this.status,
  });
  late final String talent;
  late final String token;
  late final String status;
  
  UserLoginResponse.fromJson(Map<String, dynamic> json){
    talent = json['talent'];
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['talent'] = talent;
    _data['token'] = token;
    _data['status'] = status;
    return _data;
  }
}
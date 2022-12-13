import 'dart:convert';

VerifyUsernameResponse verifyUsernameApiFromJson(String str) => VerifyUsernameResponse.fromJson(json.decode(str));
String verifyUsernameApiToJson(VerifyUsernameResponse data) => json.encode(data.toJson());

class VerifyUsernameResponse {
  VerifyUsernameResponse({
    required this.available,
    required this.status,
  });
  late final String available;
  late final String status;
  
  VerifyUsernameResponse.fromJson(Map<String, dynamic> json){
    available = json['available'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['available'] = available;
    _data['status'] = status;
    return _data;
  }
}
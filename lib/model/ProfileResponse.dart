import 'dart:convert';
import 'package:bellani_talents_market/model/Account.dart';

ProfileResponse ProfileResponseApiFromJson(String str) => ProfileResponse.fromJson(json.decode(str));
String ProfileResponseApiToJson(ProfileResponse data) => json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({
    required this.data,
    required this.status,
  });
  late final Account data;
  late final String status;
  
  ProfileResponse.fromJson(Map<String, dynamic> json){
    data = Account.fromJson(json['data']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['status'] = status;
    return _data;
  }
}

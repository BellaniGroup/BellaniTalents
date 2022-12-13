import 'dart:convert';

Account AccountApiFromJson(String str) => Account.fromJson(json.decode(str));
String AccountApiToJson(Account data) => json.encode(data.toJson());

class Account {
  Account({
    required this.accountId,
    required this.countryCode,
    required this.phone,
    required this.locale,
    required this.username,
    required this.name,
    required this.email,
    required this.dob,
    required this.gender,
    required this.talentId,
  });
  late final String accountId;
  late final String countryCode;
  late final String phone;
  late final String locale;
  late final String username;
  late final String name;
  late final String email;
  late final String dob;
  late final String gender;
  late final String talentId;
  
  Account.fromJson(Map<String, dynamic> json){
    accountId = json['account_id'];
    countryCode = json['country_code'];
    phone = json['phone'];
    locale = json['locale'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    gender = json['gender'];
    talentId = json['talent_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['account_id'] = accountId;
    _data['country_code'] = countryCode;
    _data['phone'] = phone;
    _data['locale'] = locale;
    _data['username'] = username;
    _data['name'] = name;
    _data['email'] = email;
    _data['dob'] = dob;
    _data['gender'] = gender;
    _data['talent_id'] = talentId;
    return _data;
  }
}
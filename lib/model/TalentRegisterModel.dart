import 'dart:convert';

TalentRegisterModel talentRegisterModelApiFromJson(String str) => TalentRegisterModel.fromJson(json.decode(str));
String talentRegisterModelApiToJson(TalentRegisterModel data) => json.encode(data.toJson());

class TalentRegisterModel {
  TalentRegisterModel({
    required this.companyId,
    required this.name,
    required this.primaryPhone,
    required this.primaryPhoneCode,
    required this.primaryPhoneLocale,
    required this.primaryWhatsapp,
    required this.primaryWhatsappCode,
    required this.primaryWhatsappLocale,
    required this.primaryEmail,
    required this.service,
    required this.service2,
    required this.category,
    required this.category2,
    required this.languages,
  });
  late final String companyId;
  late final String name;
  late final String primaryPhone;
  late final String primaryPhoneCode;
  late final String primaryPhoneLocale;
  late final String primaryWhatsapp;
  late final String primaryWhatsappCode;
  late final String primaryWhatsappLocale;
  late final String primaryEmail;
  late final String service;
  late final String service2;
  late final String category;
  late final String category2;
  late final String languages;
  
  TalentRegisterModel.fromJson(Map<String, dynamic> json){
    companyId = json['company_id'];
    name = json['name'];
    primaryPhone = json['primary_phone'];
    primaryPhoneCode = json['primary_phone_code'];
    primaryPhoneLocale = json['primary_phone_locale'];
    primaryWhatsapp = json['primary_whatsapp'];
    primaryWhatsappCode = json['primary_whatsapp_code'];
    primaryWhatsappLocale = json['primary_whatsapp_locale'];
    primaryEmail = json['primary_email'];
    service = json['service'];
    service2 = json['service2'];
    category = json['category'];
    category2 = json['category2'];
    languages = json['languages'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['company_id'] = companyId;
    _data['name'] = name;
    _data['primary_phone'] = primaryPhone;
    _data['primary_phone_code'] = primaryPhoneCode;
    _data['primary_phone_locale'] = primaryPhoneLocale;
    _data['primary_whatsapp'] = primaryWhatsapp;
    _data['primary_whatsapp_code'] = primaryWhatsappCode;
    _data['primary_whatsapp_locale'] = primaryWhatsappLocale;
    _data['primary_email'] = primaryEmail;
    _data['service'] = service;
    _data['service2'] = service2;
    _data['category'] = category;
    _data['category2'] = category2;
    _data['languages'] = languages;
    return _data;
  }
}
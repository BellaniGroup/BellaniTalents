import 'dart:convert';
import 'package:flutter/material.dart';

PostDealSuccessDealRequirementModel
    PostDealSuccessDealRequirementModelApiFromJson(String str) =>
        PostDealSuccessDealRequirementModel.fromJson(json.decode(str));
String PostDealSuccessDealRequirementModelApiToJson(
        PostDealSuccessDealRequirementModel data) =>
    json.encode(data.toJson());

class PostDealSuccessDealRequirementModel {
  PostDealSuccessDealRequirementModel({
    required this.dealId,
    required this.requirements,
  });
  late final String dealId;
  late final List<DealRequirementModel> requirements;

  PostDealSuccessDealRequirementModel.fromJson(Map<String, dynamic> json) {
    dealId = json['deal_id'];
    requirements = List.from(json['requirements'])
        .map((e) => DealRequirementModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['deal_id'] = dealId;
    _data['requirements'] = requirements.map((e) => e.toJson()).toList();
    return _data;
  }
}

class DealRequirementModel {
  DealRequirementModel({
    required this.service,
    required this.category,
    required this.members,
    required this.pricing,
    required this.availableCategories,
    required this.textController1,
    required this.textController2,
  });
  late final String? service;
  late final String? category;
  late final String? members;
  late final String? pricing;
  late final List<String>? availableCategories;
  late final TextEditingController textController1;
  late final TextEditingController textController2;

  DealRequirementModel.fromJson(Map<String, dynamic> json) {
    service = json['service'];
    category = json['category'];
    members = json['members'];
    pricing = json['pricing'];
    availableCategories = json['availableCategories'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['service'] = service;
    _data['category'] = category;
    _data['members'] = members;
    _data['pricing'] = pricing;
    _data['availableCategories'] = availableCategories;
    return _data;
  }
}

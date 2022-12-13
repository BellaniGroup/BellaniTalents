import 'dart:convert';
import 'package:flutter/material.dart';

import 'DealRequirementModel.dart';

PostCollabRequirementModel
    PostCollabRequirementModelApiFromJson(String str) =>
        PostCollabRequirementModel.fromJson(json.decode(str));
String PostCollabRequirementModelApiToJson(
        PostCollabRequirementModel data) =>
    json.encode(data.toJson());

class PostCollabRequirementModel {
  PostCollabRequirementModel({
    required this.collab_id,
    required this.requirements,
  });
  late final String collab_id;
  late final List<DealRequirementModel> requirements;

  PostCollabRequirementModel.fromJson(Map<String, dynamic> json) {
    collab_id = json['collab_id'];
    requirements = List.from(json['requirements'])
        .map((e) => DealRequirementModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['collab_id'] = collab_id;
    _data['requirements'] = requirements.map((e) => e.toJson()).toList();
    return _data;
  }
}
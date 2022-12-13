import 'dart:convert';

PostCollabDetails PostCollabDetailsApiFromJson(String str) => PostCollabDetails.fromJson(json.decode(str));
String PostCollabDetailsApiToJson(PostCollabDetails data) => json.encode(data.toJson());

class PostCollabDetails {
  PostCollabDetails({
    required this.talentId,
    required this.title,
    required this.desc,
    required this.driveUrl,
    required this.dropboxUrl,
    required this.promotionUrl,
    required this.fromDate,
    required this.toDate,
  });
  late final String talentId;
  late final String title;
  late final String desc;
  late final String driveUrl;
  late final String dropboxUrl;
  late final String promotionUrl;
  late final String fromDate;
  late final String toDate;
  
  PostCollabDetails.fromJson(Map<String, dynamic> json){
    talentId = json['talent_id'];
    title = json['title'];
    desc = json['desc'];
    driveUrl = json['drive_url'];
    dropboxUrl = json['dropbox_url'];
    promotionUrl = json['promotion_url'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['talent_id'] = talentId;
    _data['title'] = title;
    _data['desc'] = desc;
    _data['drive_url'] = driveUrl;
    _data['dropbox_url'] = dropboxUrl;
    _data['promotion_url'] = promotionUrl;
    _data['from_date'] = fromDate;
    _data['to_date'] = toDate;
    return _data;
  }
}
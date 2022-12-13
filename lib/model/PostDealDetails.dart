
import 'dart:convert';

PostDealDetails PostDealDetailsResponseApiFromJson(String str) => PostDealDetails.fromJson(json.decode(str));
String PostDealDetailsResponseApiToJson(PostDealDetails data) => json.encode(data.toJson());

class PostDealDetails {
  PostDealDetails({
    required this.title,
    required this.desc,
    required this.driveUrl,
    required this.dropboxUrl,
    required this.promotionUrl,
    required this.fromDate,
    required this.toDate,
  });
  late final String title;
  late final String desc;
  late final String driveUrl;
  late final String dropboxUrl;
  late final String promotionUrl;
  late final String fromDate;
  late final String toDate;
  
  PostDealDetails.fromJson(Map<String, dynamic> json){
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
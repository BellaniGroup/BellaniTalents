class Talents {
  Talents({
    required this.id,
    required this.accountId,
    required this.stageName,
    required this.live,
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
    required this.lat,
    required this.lng,
    required this.lat2,
    required this.lng2,
    required this.photo,
    required this.facebook,
    required this.instagram,
    required this.portfolio,
    required this.languages,
    required this.phoneClicks,
    required this.whatsappClicks,
    required this.bmClicks,
    required this.fbClicks,
    required this.instaClicks,
    required this.bcardClicks,
    required this.portfolioClicks,
    required this.priceTagClicks,
    required this.payNowClicks,
    required this.shareClicks,
    required this.username,
  });
  late final String id;
  late final String accountId;
  late final String stageName;
  late final String live;
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
  late final String lat;
  late final String lng;
  late final String lat2;
  late final String lng2;
  late final String photo;
  late final String facebook;
  late final String instagram;
  late final String portfolio;
  late final String languages;
  late final String phoneClicks;
  late final String whatsappClicks;
  late final String bmClicks;
  late final String fbClicks;
  late final String instaClicks;
  late final String bcardClicks;
  late final String portfolioClicks;
  late final String priceTagClicks;
  late final String payNowClicks;
  late final String shareClicks;
  late final String username;

  Talents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['account_id'];
    stageName = json['stage_name'];
    live = json['live'];
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
    lat = json['lat'];
    lng = json['lng'];
    lat2 = json['lat2'];
    lng2 = json['lng2'];
    photo = json['photo'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    portfolio = json['portfolio'];
    languages = json['languages'];
    phoneClicks = json['phone_clicks'];
    whatsappClicks = json['whatsapp_clicks'];
    bmClicks = json['bm_clicks'];
    fbClicks = json['fb_clicks'];
    instaClicks = json['insta_clicks'];
    bcardClicks = json['bcard_clicks'];
    portfolioClicks = json['portfolio_clicks'];
    priceTagClicks = json['price_tag_clicks'];
    payNowClicks = json['pay_now_clicks'];
    shareClicks = json['share_clicks'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['account_id'] = accountId;
    _data['stage_name'] = stageName;
    _data['live'] = live;
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
    _data['lat'] = lat;
    _data['lng'] = lng;
    _data['lat2'] = lat2;
    _data['lng2'] = lng2;
    _data['photo'] = photo;
    _data['facebook'] = facebook;
    _data['instagram'] = instagram;
    _data['portfolio'] = portfolio;
    _data['languages'] = languages;
    _data['phone_clicks'] = phoneClicks;
    _data['whatsapp_clicks'] = whatsappClicks;
    _data['bm_clicks'] = bmClicks;
    _data['fb_clicks'] = fbClicks;
    _data['insta_clicks'] = instaClicks;
    _data['bcard_clicks'] = bcardClicks;
    _data['portfolio_clicks'] = portfolioClicks;
    _data['price_tag_clicks'] = priceTagClicks;
    _data['pay_now_clicks'] = payNowClicks;
    _data['share_clicks'] = shareClicks;
    _data['username'] = username;
    return _data;
  }
}

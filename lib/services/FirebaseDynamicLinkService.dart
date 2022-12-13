import 'package:bellani_talents_market/strings/strings.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService {
  static String DynamicLink = "https://bellanitalents.com/";
  static FirebaseDynamicLinks firebaseDynamicLinks =
      FirebaseDynamicLinks.instance;

  static Future<String> createDynamicLink(bool short, String id, String imageUrl) async {
    String _linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://talents.page.link',
      link: Uri.parse(
        'https://bellanitalents.com/$id',
      ),
      androidParameters: AndroidParameters(
        packageName: 'com.bellani.talents',
        fallbackUrl: Uri.parse(PLAY_STORE_URL),
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: 'bellani.talents',
        fallbackUrl: Uri.parse(APP_STORE_URL),
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
    title: "Bellani Talents",
    description: "Hey! Checkout this talent",
    imageUrl: Uri.parse(imageUrl),
  ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await firebaseDynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await firebaseDynamicLinks.buildLink(parameters);
    }

    _linkMessage = url.toString();
    return _linkMessage;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    firebaseDynamicLinks.onLink.listen((dynamicLinkData) {
        Navigator.pushNamedAndRemoveUntil(context, "/talentDetails" , (route) => false, arguments: {
        "talent_id": dynamicLinkData.link.path.replaceFirst("/", ""),
      });
      // Navigator.pushNamed(context, '/talentDetails', arguments: {
      //   "talent_id": dynamicLinkData.link.path.replaceFirst("/", ""),
      // });
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deeplink = data?.link;
     if(deeplink != null){
         Navigator.pushNamedAndRemoveUntil(context, "/talentDetails" , (route) => false, arguments: {
        "talent_id": deeplink.path.replaceFirst("/", ""),
      });
      //  Navigator.pushNamed(context, '/talentDetails', arguments: {
      //   "talent_id": deeplink.path.replaceFirst("/", ""),
      // });
     }
  }
}

import 'package:bellani_talents_market/main.dart';
import 'package:bellani_talents_market/model/MarqueeWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../theme/custom_theme.dart';

class testScreen extends StatefulWidget {
  const testScreen({Key? key}) : super(key: key);

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> {
  var _height = 100.0;
  var availableHeight;

  Completer<GoogleMapController> _mapController = Completer();
  final LatLng _center = const LatLng(13.063476641475418, 80.2650513392232);

  @override
  Widget build(BuildContext context) {
    availableHeight = MediaQuery.of(context).size.height -
        // AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
        backgroundColor: CustomTheme.appColors.primaryColor,
        body: SafeArea(
            child: CustomScrollView(slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              width: double.infinity,
              color: CustomTheme.appColors.secondaryColor,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(10),
                                color: CustomTheme.appColors.primaryColor,
                                child: SvgPicture.asset(
                                    "assets/left_arrow_white.svg"),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Edit profile",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
                              color: CustomTheme.appColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: GestureDetector(
                          onDoubleTap: () {},
                          child: Container(
                            height: 725,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.white,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://live.staticflickr.com/65535/52006667680_43f145d819_n.jpg"),
                                fit: BoxFit.cover,
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: CustomTheme.appColors.black
                              //         .withOpacity(0.5),
                              //     blurRadius: 8,
                              //     spreadRadius: 5,
                              //     offset: const Offset(0, 0),
                              //   ),
                              // ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6)),
                                    child: Container(
                                      height: 86,
                                      width: double.infinity,
                                      // color: CustomTheme.appColors.white,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: Column(children: [
                                                Container(
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(6),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    6)),
                                                    child: Container(
                                                      height: 36,
                                                      color: CustomTheme
                                                          .appColors
                                                          .primaryColor,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/star_icon.svg")),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/star_icon.svg")),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/star_icon.svg")),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/star_icon.svg")),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Container(
                                                                height: 14,
                                                                width: 14,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/star_icon.svg")),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft: Radius
                                                              .circular(6),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  6)),
                                                  child: Container(
                                                    height: 36,
                                                    width: double.infinity,
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        MarqueeWidget(
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          pauseDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      800),
                                                          backDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          child: Text(
                                                            "@" + "username",
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        MarqueeWidget(
                                                            animationDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        1000),
                                                            pauseDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        800),
                                                            backDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        1000),
                                                            child: Text(
                                                              "service" +
                                                                  " - " +
                                                                  "category",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: Container(
                                                  height: 36,
                                                  color: CustomTheme
                                                      .appColors.primaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "EN",
                                                        style: TextStyle(
                                                            color: CustomTheme
                                                                .appColors
                                                                .white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(6),
                                                    bottomRight:
                                                        Radius.circular(6)),
                                                child: Container(
                                                  height: 36,
                                                  width: 30,
                                                  color: CustomTheme
                                                      .appColors.secondaryColor,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 9,
                                                        top: 9,
                                                        left: 6,
                                                        right: 6),
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: SvgPicture.asset(
                                                          "assets/report.svg"),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6)),
                                              child: Container(
                                                height: 36,
                                                width: 30,
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10,
                                                      top: 10,
                                                      left: 8,
                                                      right: 8),
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: SvgPicture.asset(
                                                        "assets/down_arrow.svg"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: CustomTheme
                                        //         .appColors.black
                                        //         .withOpacity(0.3),
                                        //     spreadRadius: 3,
                                        //     blurRadius: 3,
                                        //     offset: Offset(0,
                                        //         -5), // changes position of shadow
                                        //   ),
                                        // ],
                                        ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6)),
                                      child: Container(
                                        height: 130,
                                        decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: CustomTheme
                                          //         .appColors.black
                                          //         .withOpacity(0.3),
                                          //     spreadRadius: 5,
                                          //     blurRadius: 7,
                                          //     offset: Offset(3,
                                          //         -3), // changes position of shadow
                                          //   ),
                                          // ],
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(6),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    6)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // call = "tel:" +
                                                        //     selectedTalent
                                                        //         .phone;
                                                        // share(
                                                        //     SocialMedia
                                                        //         .call);
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/call.svg")),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(6),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    6)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // whatsappUrl =
                                                        //     "https://api.whatsapp.com/send?phone=${selectedTalent.phone}";
                                                        // share(SocialMedia
                                                        //     .whatsapp);
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/whatsapp.svg")),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(6),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    6)),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/bellani_messenger.svg")),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(6),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    6)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // facebookUrl =
                                                        //     selectedTalent
                                                        //         .facebook;
                                                        // share(SocialMedia
                                                        //     .facebook);
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/facebook.svg")),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(6),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    6)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        // instaUrl =
                                                        //     selectedTalent
                                                        //         .instagram;
                                                        // share(SocialMedia
                                                        //     .instagram);
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        child: Center(
                                                            child: SvgPicture.asset(
                                                                "assets/insta.svg")),
                                                      ),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        //     call = "tel:" + selectedTalent.phone;
                                                        // share(SocialMedia.call);
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: SvgPicture.asset(
                                                            "assets/full_name.svg"),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: SvgPicture.asset(
                                                            "assets/username.svg"),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: SvgPicture.asset(
                                                            "assets/mobile.svg"),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: SvgPicture.asset(
                                                            "assets/email.svg"),
                                                      ),
                                                    ),
                                                  )),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                      bottomRight:
                                                          Radius.circular(6),
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        // String link = await FirebaseDynamicLinkService.createDynamicLink(
                                                        //     true,
                                                        //     selectedTalent
                                                        //         .id,
                                                        //     selectedTalent
                                                        //         .photo);

                                                        // Share.share(
                                                        //     link);
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        padding:
                                                            EdgeInsets.all(15),
                                                        child: SvgPicture.asset(
                                                            "assets/dob.svg"),
                                                      ),
                                                    ),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: CustomTheme.appColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 35,
                          padding: EdgeInsets.all(10),
                          color: CustomTheme.appColors.primaryColor,
                          child:
                              SvgPicture.asset("assets/left_arrow_white.svg"),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Edit profile",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 35,
                        padding: EdgeInsets.all(10),
                        color: CustomTheme.appColors.primaryColor,
                      ),
                    ],
                  ),
                ),
                Stack(children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                        color: CustomTheme.appColors.white,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                  Positioned(
                      right: 6,
                      bottom: 6,
                      child: CircleAvatar(
                        backgroundColor: CustomTheme.appColors.primaryColor,
                        radius: 8,
                      ))
                ]),
                Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Text("Aakash Venkat")),
                GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    height: 30,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: CustomTheme.appColors.primaryColor,
                    ),
                    child: Text(
                      "@aakashv",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: CustomTheme.appColors.primaryColor,
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          "+919283047899",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset("assets/tick_unselected.svg"),
                    )
                  ]),
                ),
                Container(
                  height: 30,
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: CustomTheme.appColors.primaryColor,
                  ),
                  child: Text(
                    "aakash@gmail.com",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 30,
                        width: 80,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Text(
                          "01/07/1995",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          sp.remove("token");
                        },
                        child: Container(
                          height: 30,
                          width: 80,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 10, left: 5, right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.primaryColor,
                          ),
                          child: Text(
                            "Male",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ),
        ]))
        // body: GoogleMap(
        //   onMapCreated: (GoogleMapController controller) {
        //     _mapController.complete(controller);
        //   },
        //   initialCameraPosition: CameraPosition(
        //     target: _center,
        //     zoom: 18.0,
        //   ),
        // ),
        );
  }

  void changePosition() {
    setState(() {
      _height = availableHeight - 0;
    });
  }
}

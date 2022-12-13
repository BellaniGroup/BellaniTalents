import 'package:badges/badges.dart';
import 'package:bellani_talents_market/screens/packages/bloc/packages_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../strings/strings.dart';
import '../../theme/custom_theme.dart';
import '../model/Dashboard.dart';

class TalentDashboard extends StatefulWidget {
  const TalentDashboard({Key? key}) : super(key: key);

  @override
  State<TalentDashboard> createState() => _TalentDashboardState();
}

class _TalentDashboardState extends State<TalentDashboard> {
  var dashboard;
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    dashboard = arguments["dashboard"];

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PackagesBloc>(
                create: (context) => PackagesBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
              backgroundColor: CustomTheme.appColors.primaryColor,
              body: SafeArea(
                bottom: false,
                child: Container(
                  color: CustomTheme.appColors.secondaryColor,
                  child: Column(
                    children: [
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
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Talents dashboard",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ]),
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
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                        ),
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: CustomTheme.appColors.primaryColor50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                width: 60,
                                margin: EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                    "assets/notification_selected.svg"),
                              ),
                              Container(
                                height: 80,
                                width: 60,
                                margin: EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                    "assets/edit_unselected.svg"),
                              ),
                              Container(
                                height: 80,
                                width: 60,
                                margin: EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                    "assets/toolbox_unselected.svg"),
                              ),
                                Container(
                                height: 80,
                                width: 60,
                                margin: EdgeInsets.only(left: 10),
                                child: SvgPicture.asset(
                                    "assets/centres_unselected.svg"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            color: CustomTheme.appColors.primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(6),
                                bottomRight: Radius.circular(6)),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: CustomTheme.appColors.secondaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6)),
                                    color: CustomTheme.appColors.secondaryColor,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: scrollableIcons(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(
                                        "View complete history",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.primaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: Row(children: [
                          Expanded(
                            child: Text(
                              "Click here to mark attendance",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        height: 25,
                        color: CustomTheme.appColors.primaryColor,
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  scrollableIcons() {
    return Container(
      height: 50,
      color: CustomTheme.appColors.primaryColor50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard!.phoneClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/viewCallers");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btph.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.whatsappClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/viewWhatsappClick");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btwa.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.bmClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      // padding: EdgeInsets.only(top: 30),
                      backgroundColor: CustomTheme.appColors.white,
                      content: Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(
                          'Bellani Messenger will launch soon!',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: sp.getString("selectedFont"),
                              color: CustomTheme.appColors.secondaryColor),
                        ),
                      ),
                    ));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btbm.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.fbClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/facebookClicks");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btfb.svg")),
                ),
              ),
            ),
            Badge(
              shape: BadgeShape.square,
              badgeContent: Text(
                dashboard.instaClicks,
                style:
                    TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
              ),
              position: BadgePosition.topEnd(top: -12, end: -5),
              badgeColor: CustomTheme.appColors.primaryColor,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/instaClicks");
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // color: CustomTheme.appColors.bjpOrange,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SvgPicture.asset("assets/btig.svg")),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

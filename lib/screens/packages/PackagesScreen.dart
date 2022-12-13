import 'package:bellani_talents_market/screens/packages/bloc/packages_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../strings/strings.dart';
import '../../theme/custom_theme.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
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
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          margin: EdgeInsets.only(right: 10),
                                          color: CustomTheme
                                              .appColors.primaryColor,
                                          child: SvgPicture.asset(
                                              "assets/package.svg"),
                                        )),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Packages dashboard",
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
                                // color: CustomTheme.appColors.bjpOrange,
                                child: Image.asset(
                                    "assets/talents_icon_packages_dashboard.png"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      // padding: EdgeInsets.only(top: 30),
                                      backgroundColor:
                                          CustomTheme.appColors.white,
                                      content: Container(
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "This package will be available soon",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                    ));
                                },
                                child: Container(
                                  height: 80,
                                  width: 60,
                                  margin: EdgeInsets.only(left: 10),
                                  // color: CustomTheme.appColors.bjpOrange,
                                  child: Image.asset(
                                      "assets/builders_icon_packages_dashboard.png"),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      // padding: EdgeInsets.only(top: 30),
                                      backgroundColor:
                                          CustomTheme.appColors.white,
                                      content: Container(
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "This package will be available soon",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                    ));
                                },
                                child: Container(
                                  height: 80,
                                  width: 60,
                                  margin: EdgeInsets.only(left: 10),
                                  // color: CustomTheme.appColors.bjpOrange,
                                  child: Image.asset(
                                      "assets/explore_icon_packages_dashboard.png"),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      // padding: EdgeInsets.only(top: 30),
                                      backgroundColor:
                                          CustomTheme.appColors.white,
                                      content: Container(
                                        height: 32,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "This package will be available soon",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily:
                                                  sp.getString("selectedFont"),
                                              color: CustomTheme
                                                  .appColors.secondaryColor),
                                        ),
                                      ),
                                    ));
                                },
                                child: Container(
                                  height: 80,
                                  width: 60,
                                  margin: EdgeInsets.only(left: 10),
                                  // color: CustomTheme.appColors.bjpOrange,
                                  child: Image.asset(
                                      "assets/work_icon_packages_dashboard.png"),
                                ),
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
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.appColors.primaryColor50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Your subscription is active, until 30th",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                        color: CustomTheme
                                            .appColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  child: ListView.builder(
                                    itemCount: btc.length,
                                    padding: EdgeInsets.all(0),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            color: CustomTheme
                                                .appColors.primaryColor50,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Column(children: [
                                          Container(
                                            height: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: CustomTheme
                                                    .appColors.secondaryColor,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    topRight:
                                                        Radius.circular(6))),
                                            child: Text(
                                              btc[index].title,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: CustomTheme
                                                  .appColors.secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    btc[index].asset),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 10),
                                            child: Text(
                                              btc[index].desc,
                                              style: TextStyle(fontSize: 11),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ]),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
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
                          Container(
                            padding: EdgeInsets.all(14),
                          ),
                          Expanded(
                            child: Text(
                              "Continue to dashboard",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                              color: CustomTheme.appColors.primaryColor,
                              padding: EdgeInsets.all(14),
                              child:
                                  SvgPicture.asset("assets/right_arrow.svg")),
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
}

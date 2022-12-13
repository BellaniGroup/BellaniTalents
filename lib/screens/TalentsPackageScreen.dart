import 'package:bellani_talents_market/screens/packages/bloc/packages_bloc.dart';
import 'package:bellani_talents_market/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../theme/custom_theme.dart';

class TalentsPackageScreen extends StatefulWidget {
  const TalentsPackageScreen({Key? key}) : super(key: key);

  @override
  State<TalentsPackageScreen> createState() => _TalentsPackageScreenState();
}

class _TalentsPackageScreenState extends State<TalentsPackageScreen> {
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
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.primaryColor50,
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor,
                                ),
                                child: Text(
                                  "Talents package",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CustomTheme.appColors.primaryColor,
                                      borderRadius: BorderRadius.circular(6)),
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                        ),
                                        child: Text(
                                          "Bellani Talents App",
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                          child: ListView.builder(
                                            itemCount: btc.length,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: double.infinity,
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .primaryColor50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: Column(children: [
                                                  Container(
                                                    height: 30,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: CustomTheme
                                                            .appColors
                                                            .secondaryColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6))),
                                                    child: Text(
                                                      btc[index].title,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 100,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: CustomTheme
                                                          .appColors
                                                          .secondaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            btc[index].asset),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 10),
                                                    child: Text(
                                                      btc[index].desc,
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                      textAlign:
                                                          TextAlign.center,
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/talentsPackageRegister");
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color:
                                          CustomTheme.appColors.primaryColor),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 35,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomTheme
                                                .appColors.primaryColor),
                                      ),
                                      Expanded(
                                        child: Center(
                                            child: Text(
                                          "Subscribe to Talents package",
                                          style: TextStyle(fontSize: 14),
                                        )),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 35,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomTheme
                                                .appColors.primaryColor),
                                        child: SvgPicture.asset(
                                            "assets/right_arrow.svg"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

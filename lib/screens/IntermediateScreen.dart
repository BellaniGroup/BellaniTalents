import 'package:bellani_talents_market/screens/packages/bloc/packages_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../theme/custom_theme.dart';

class IntermediateScreen extends StatefulWidget {
  const IntermediateScreen({Key? key}) : super(key: key);

  @override
  State<IntermediateScreen> createState() => _IntermediateScreenState();
}

class _IntermediateScreenState extends State<IntermediateScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var talent = arguments["talent"];
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
                            Expanded(
                              child: Text(
                                "OneBellani",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
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
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: 3,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Column(children: [
                                    Container(
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6))),
                                      child: Text(
                                        "Your OneBellani account offers xyz abc",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                    Container(
                                      height: 50,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        "khadgfv ajlhfbv jahbf vjahbfvfjkahbf ajlhfbv ajhdbfaldjf lkajdnfblahdf ajbhfljad fladjhbjkad",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ]),
                                );
                              }),
                        ),
                      ),
                      Column(children: [
                        if (talent == "1")
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/");
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 35,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text(
                                      "Continue to talents",
                                      style: TextStyle(fontSize: 14),
                                    )),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 35,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor),
                                    child: SvgPicture.asset(
                                        "assets/right_arrow.svg"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (talent == "0")
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/");
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 35,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text(
                                      "Continue as a user",
                                      style: TextStyle(fontSize: 14),
                                    )),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 35,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor),
                                    child: SvgPicture.asset(
                                        "assets/right_arrow.svg"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (talent == "0")
                          GestureDetector(
                             onTap: () {
                              Navigator.pushNamed(
                                  context, "/talentsPackageRegister");
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: CustomTheme.appColors.primaryColor),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 35,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor),
                                  ),
                                  Expanded(
                                    child: Center(
                                        child: Text(
                                      "Register as a talent",
                                      style: TextStyle(fontSize: 14),
                                    )),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 35,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color:
                                            CustomTheme.appColors.primaryColor),
                                    child: SvgPicture.asset(
                                        "assets/right_arrow.svg"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

import 'package:bellani_talents_market/model/TalentRegisterModel.dart';
import 'package:bellani_talents_market/screens/selectPlan/bloc/select_plan_bloc.dart';
import 'package:bellani_talents_market/screens/transaction/bloc/transaction_bloc.dart';
import 'package:bellani_talents_market/services/ApiService.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';

class SelectPlanScreen extends StatefulWidget {
  TalentRegisterModel talentRegisterdata;
  SelectPlanScreen({required this.talentRegisterdata, Key? key})
      : super(key: key);

  @override
  State<SelectPlanScreen> createState() =>
      _SelectPlanScreenState(talentRegisterdata);
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  bool _agreeTerms = false;
  TalentRegisterModel talentRegisterdata;
  _SelectPlanScreenState(TalentRegisterModel this.talentRegisterdata);

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
            BlocProvider<SelectPlanBloc>(
                create: (context) => SelectPlanBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: SafeArea(
              child: BlocBuilder<SelectPlanBloc, SelectPlanState>(
                builder: (context, state) {
                  return Container(
                    width: double.infinity,
                    color: CustomTheme.appColors.secondaryColor,
                    child: Column(children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Text(
                          "Talents package - Plans",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 5, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/offers.svg")),
                          ),
                          Expanded(
                              child: Text(
                            "Free trial until 30th June 2023",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: SvgPicture.asset("assets/tick_maroon.svg"),
                          ),
                        ]),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 5, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        child: Row(children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/1month.svg")),
                          ),
                          Expanded(
                              child: Text(
                            "Free trial until 30th June 2023",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: CustomTheme.appColors.primaryColor),
                          )),
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            // child:
                            //     SvgPicture.asset("assets/tick_maroon.svg"),
                          ),
                        ]),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 5, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        child: Row(children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/3month.svg")),
                          ),
                          Expanded(
                              child: Text(
                            "Free trial until 30th June 2023",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: CustomTheme.appColors.primaryColor),
                          )),
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            // child:
                            //     SvgPicture.asset("assets/tick_maroon.svg"),
                          ),
                        ]),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 5, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        child: Row(children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/6month.svg")),
                          ),
                          Expanded(
                              child: Text(
                            "Free trial until 30th June 2023",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: CustomTheme.appColors.primaryColor),
                          )),
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            // child:
                            //     SvgPicture.asset("assets/tick_maroon.svg"),
                          ),
                        ]),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 5, top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        child: Row(children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/12month.svg")),
                          ),
                          Expanded(
                              child: Text(
                            "Free trial until 30th June 2023",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: CustomTheme.appColors.primaryColor),
                          )),
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.all(5),
                            // child:
                            //     SvgPicture.asset("assets/tick_maroon.svg"),
                          ),
                        ]),
                      ),
                      Expanded(
                        child: Column(children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6)),
                              color: CustomTheme.appColors.primaryColor50,
                            ),
                            child: Text(
                              "Terms and conditions",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // height: 250,
                              width: double.infinity,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: CustomTheme.appColors.white,
                              ),
                              child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "hjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\nhjavsdka\n",
                                      style: TextStyle(
                                          color: CustomTheme
                                              .appColors.secondaryColor),
                                    ),
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_agreeTerms) {
                                setState(() {
                                  _agreeTerms = false;
                                });
                              } else {
                                setState(() {
                                  _agreeTerms = true;
                                });
                              }
                            },
                            child: Container(
                              height: 30,
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(6)),
                                color: CustomTheme.appColors.primaryColor50,
                              ),
                              child: Row(
                                children: [
                                  if (!_agreeTerms)
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin:
                                          EdgeInsets.only(left: 5, right: 10),
                                      color:
                                          CustomTheme.appColors.secondaryColor,
                                      child: SvgPicture.asset(
                                          "assets/tick_unselected.svg"),
                                    ),
                                  if (_agreeTerms)
                                    Container(
                                      height: 20,
                                      width: 20,
                                      margin:
                                          EdgeInsets.only(left: 5, right: 10),
                                      color:
                                          CustomTheme.appColors.secondaryColor,
                                      child: SvgPicture.asset(
                                          "assets/tick_selected.svg"),
                                    ),
                                  Text("Accept terms and conditions")
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_agreeTerms) {
                            final activity = await ApiService()
                                .registerTalent(talentRegisterdata);
                            if (activity.status == "success") {
                            Navigator.pushNamed(context, "/uploadTalentImage");
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                // padding: EdgeInsets.only(top: 30),
                                backgroundColor: CustomTheme.appColors.white,
                                content: Container(
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Please agree terms and conditions",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily:
                                            sp.getString("selectedFont"),
                                        color: CustomTheme
                                            .appColors.secondaryColor),
                                  ),
                                ),
                              ));
                          }
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: CustomTheme.appColors.primaryColor,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(10),
                                // child: SvgPicture.asset(
                                //     "assets/right_arrow.svg"),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Complete registration",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(10),
                                child:
                                    SvgPicture.asset("assets/right_arrow.svg"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

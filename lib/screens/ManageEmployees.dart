import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../main.dart';
import '../model/MarqueeWidget.dart';
import '../services/ApiService.dart';
import '../strings/strings.dart';
import '../theme/custom_theme.dart';
import 'searchScreen/SearchScreen.dart';
import 'transaction/bloc/transaction_bloc.dart';

class ManageEmployees extends StatefulWidget {
  const ManageEmployees({Key? key}) : super(key: key);

  @override
  State<ManageEmployees> createState() => _ManageEmployeesState();
}

class _ManageEmployeesState extends State<ManageEmployees>
    with TickerProviderStateMixin {
  double dropDownHeight = 496;
  var searchResult;
  late AnimationController _ownerAnimationController,
      _employeeAnimationController,
      _pendingAnimationController;
  late Animation<double> _ownerAnimation, _employeeAnimation, _pendingAnimation;
  bool _ownerClicked = true, _employeeClicked = false, _pendingClicked = false;

  @override
  void initState() {
    super.initState();

    _ownerAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _ownerAnimation = CurvedAnimation(
        parent: _ownerAnimationController, curve: Curves.easeInOut);
    _employeeAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _employeeAnimation = CurvedAnimation(
        parent: _employeeAnimationController, curve: Curves.easeInOut);
    _pendingAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _pendingAnimation = CurvedAnimation(
        parent: _pendingAnimationController, curve: Curves.easeInOut);

    _ownerAnimationController.forward();
  }

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
            BlocProvider<TransactionBloc>(
                create: (context) => TransactionBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: SafeArea(
              child: Container(
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
                      "Manage employees",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _ownerClicked = true;
                        _employeeClicked = false;
                        _pendingClicked = false;
                        _ownerAnimationController.forward();
                        _employeeAnimationController.reverse();
                        _pendingAnimationController.reverse();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        color: _ownerClicked
                            ? CustomTheme.appColors.primaryColor
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  margin: EdgeInsets.only(right: 10),
                                  // color: CustomTheme.appColors.primaryColor,
                                  // child: SvgPicture.asset("assets/wallet.svg"),
                                )),
                            Expanded(
                              child: Text(
                                "Owners/Admin",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToSearchScreen(context, "username");
                              },
                              child: Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(6),
                                child: SvgPicture.asset("assets/add.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _ownerAnimation,
                    axis: Axis.vertical,
                    axisAlignment: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: dropDownHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                        color: CustomTheme.appColors.primaryColor,
                      ),
                      child: ListView.builder(
                          itemCount: 4,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 30,
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/companyName.svg")),
                                ),
                                Expanded(
                                    child: Text(
                                  "@krishnabellani",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/white_x.svg")),
                                ),
                              ]),
                            );
                          }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _ownerClicked = false;
                        _employeeClicked = true;
                        _pendingClicked = false;
                        _ownerAnimationController.forward();
                        _employeeAnimationController.reverse();
                        _pendingAnimationController.reverse();
                        _ownerAnimationController.reverse();
                        _employeeAnimationController.forward();
                        _pendingAnimationController.reverse();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        color: _employeeClicked
                            ? CustomTheme.appColors.primaryColor
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  margin: EdgeInsets.only(right: 10),
                                  // child: SvgPicture.asset("assets/wallet.svg"),
                                )),
                            Expanded(
                              child: Text(
                                "Employees",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToSearchScreen(context, "username");
                              },
                              child: Container(
                                height: 50,
                                width: 35,
                                padding: EdgeInsets.all(6),
                                child: SvgPicture.asset("assets/add.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _employeeAnimation,
                    axis: Axis.vertical,
                    axisAlignment: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: dropDownHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                        color: CustomTheme.appColors.primaryColor,
                      ),
                      child: ListView.builder(
                          itemCount: 6,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 30,
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/employee.svg")),
                                ),
                                Expanded(
                                    child: Text(
                                  "@krishnabellani",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/white_x.svg")),
                                ),
                              ]),
                            );
                          }),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _ownerClicked = false;
                        _employeeClicked = false;
                        _pendingClicked = true;
                        _ownerAnimationController.forward();
                        _employeeAnimationController.reverse();
                        _pendingAnimationController.reverse();
                        _ownerAnimationController.reverse();
                        _employeeAnimationController.reverse();
                        _pendingAnimationController.forward();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        color: _pendingClicked
                            ? CustomTheme.appColors.primaryColor
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomTheme.appColors.primaryColor50,
                        ),
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  margin: EdgeInsets.only(right: 10),
                                  // child: SvgPicture.asset("assets/wallet.svg"),
                                )),
                            Expanded(
                              child: Text(
                                "Pending",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(6),
                              // child: SvgPicture.asset("assets/add.svg"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _pendingAnimation,
                    axis: Axis.vertical,
                    axisAlignment: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: dropDownHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6)),
                        color: CustomTheme.appColors.primaryColor,
                      ),
                      child: ListView.builder(
                          itemCount: 2,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 30,
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
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
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/companyName.svg")),
                                ),
                                Expanded(
                                    child: Text(
                                  "@krishnabellani",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.all(5),
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                          color: CustomTheme
                                              .appColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: SvgPicture.asset(
                                          "assets/pending.svg")),
                                ),
                              ]),
                            );
                          }),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6)),
                      color: CustomTheme.appColors.primaryColor50,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: CustomTheme.appColors.primaryColor,
                      ),
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.only(right: 10),
                                color: CustomTheme.appColors.primaryColor,
                                // child: SvgPicture.asset("assets/wallet.svg"),
                              )),
                          Expanded(
                            child: Text(
                              "Save Changes",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 35,
                            padding: EdgeInsets.all(10),
                            color: CustomTheme.appColors.primaryColor,
                            child: SvgPicture.asset("assets/right_arrow.svg"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToSearchScreen(BuildContext context, String type) async {
    searchResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen(searchType: type)),
    );

    if (searchResult != null) {
      if (searchResult['id'] != null) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            // padding: EdgeInsets.only(top: 30),
            backgroundColor: CustomTheme.appColors.white,
            content: Container(
              height: 32,
              alignment: Alignment.center,
              child: Text(
                searchResult['id'],
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: sp.getString("selectedFont"),
                    color: CustomTheme.appColors.secondaryColor),
              ),
            ),
          ));

        // final response = await post(
        //     Uri.parse(BASE_URL + "user/get_talent_details"),
        //     headers: <String, String>{
        //       'Content-Type': 'application/json; charset=UTF-8',
        //     },
        //     body:
        //         jsonEncode(<String, String>{"talent_id": searchResult['id']}));
        // final activity = getTalentDetailsResponseApiFromJson(response.body);

      }
    }
  }
}

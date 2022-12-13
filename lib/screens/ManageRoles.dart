import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../strings/strings.dart';
import '../../theme/custom_theme.dart';
import '../main.dart';
import 'transaction/bloc/transaction_bloc.dart';

class ManageRoles extends StatefulWidget {
  const ManageRoles({Key? key}) : super(key: key);

  @override
  State<ManageRoles> createState() => _ManageRolesState();
}

class _ManageRolesState extends State<ManageRoles>
    with TickerProviderStateMixin {
  double? safeAreaHeight = sp.getDouble("safeAreaHeight");
  late double dropDownHeight = safeAreaHeight! - 240;
  late AnimationController _ownerAnimationController,
      _employeeAnimationController,
      _pendingAnimationController;
  bool _show = false;
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
            bottomSheet: _showBottomSheet(),
            body: GestureDetector(
              onTap: () {
                setState(() {
                  if (_show) {
                    _show = false;
                  }
                });
              },
              child: SafeArea(
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
                        "Manage roles",
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
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_show) {
                                      _show = false;
                                    } else {
                                      _show = true;
                                    }
                                  });
                                },
                                child: Container(
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
                                ),
                              );
                            }),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _showBottomSheet() {
    if (_show) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 130,
            color: CustomTheme.appColors.primaryColor50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
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
                            "Accept",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 35,
                          padding: EdgeInsets.all(3),
                          color: CustomTheme.appColors.primaryColor,
                          child: SvgPicture.asset("assets/tick.svg"),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
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
                            "Reject",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 35,
                          padding: EdgeInsets.all(3),
                          color: CustomTheme.appColors.primaryColor,
                          child: SvgPicture.asset("assets/x_selected.svg"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

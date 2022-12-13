import 'dart:collection';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';

class ManagePaymentMethods extends StatefulWidget {
  ManagePaymentMethods({Key? key}) : super(key: key);

  @override
  State<ManagePaymentMethods> createState() => _ManagePaymentMethodsState();
}

class _ManagePaymentMethodsState extends State<ManagePaymentMethods> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool _showCountryPicker = false;
  int selectedYear = 0, selectedMonth = 0, _selectedDate = 32;
  late DateTime firstDayOfMonth, lastDayOfMonth, firstMonth, lastMonth;
  bool _yearSelected = false, _monthSelected = false;
  bool focused = false;
  List<DateTime> days = [];
  var photo =
      "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=";
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> years = [2022, 2023, 2024, 2025, 2026];
  final Map<String, String> selectedValue = HashMap();
  Account user = AccountApiFromJson(sp.getString("userdata")!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textController.text = user.phone;
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        focused = true;
        if (_textController.text == user.phone) {
          _textController.text = "";
        }
      });
    } else {
      setState(() {
        focused = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // type = "username";

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ApiService()),
        ],
        child: Scaffold(
            bottomSheet: _showBottomSheet(),
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: GestureDetector(
              onTap: () {
                setState(() {
                  if (_showCountryPicker) {
                    _showCountryPicker = false;
                  }
                });
              },
              child: SafeArea(
                child: Container(
                  color: CustomTheme.appColors.secondaryColor,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor,
                        ),
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                color: CustomTheme.appColors.primaryColor,
                                padding: EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                    "assets/left_arrow_white.svg")),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Manage payment methods",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          )
                        ]),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.primaryColor50,
                            borderRadius: BorderRadius.circular(6)),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 215,
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: [
                                        Expanded(
                                          child: Text(
                                            "Bank account details",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 20,
                                          width: 26,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: CustomTheme
                                                  .appColors.bjpOrange,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          // child: Text(
                                          //   "₹20",
                                          //   style: TextStyle(
                                          //       fontSize: 12,
                                          //       color: CustomTheme
                                          //           .appColors.primaryColor),
                                          // ),
                                        )
                                      ]),
                                    ),
                                    Container(
                                      height: 145,
                                      color: CustomTheme.appColors.primaryColor,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                            ),
                                            child: Row(children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: SvgPicture.asset(
                                                    "assets/name_tag.svg"),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  // controller: _textController2,
                                                  // focusNode: _textFocus2,
                                                  cursorColor: CustomTheme
                                                      .appColors.white,
                                                  textInputAction:
                                                      TextInputAction.go,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: CustomTheme
                                                          .appColors.white,
                                                      fontSize: 12),
                                                  decoration: InputDecoration(
                                                    suffixIcon: Container(
                                                      height: 20,
                                                      width: 20,
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          top: 5,
                                                          bottom: 5),
                                                      child: SvgPicture.asset(
                                                          "assets/edit.svg"),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 0),
                                                    filled: true,
                                                    hintText:
                                                        "Enter account name",
                                                    hintStyle: TextStyle(
                                                        height: 1.8,
                                                        color: CustomTheme
                                                            .appColors.white),
                                                    fillColor: CustomTheme
                                                        .appColors
                                                        .primaryColor50,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Container(
                                            height: 30,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                            ),
                                            child: Row(children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: SvgPicture.asset(
                                                    "assets/account_number.svg"),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  // controller: _textController2,
                                                  // focusNode: _textFocus2,
                                                  cursorColor: CustomTheme
                                                      .appColors.white,
                                                  textInputAction:
                                                      TextInputAction.go,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: CustomTheme
                                                          .appColors.white,
                                                      fontSize: 12),
                                                  decoration: InputDecoration(
                                                    suffixIcon: Container(
                                                      height: 20,
                                                      width: 20,
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          top: 5,
                                                          bottom: 5),
                                                      child: SvgPicture.asset(
                                                          "assets/edit.svg"),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 0),
                                                    filled: true,
                                                    hintText:
                                                        "Enter account number",
                                                    hintStyle: TextStyle(
                                                        height: 1.8,
                                                        color: CustomTheme
                                                            .appColors.white),
                                                    fillColor: CustomTheme
                                                        .appColors
                                                        .primaryColor50,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Container(
                                            height: 30,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                            ),
                                            child: Row(children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: SvgPicture.asset(
                                                    "assets/bank.svg"),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  // controller: _textController2,
                                                  // focusNode: _textFocus2,
                                                  cursorColor: CustomTheme
                                                      .appColors.white,
                                                  textInputAction:
                                                      TextInputAction.go,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: CustomTheme
                                                          .appColors.white,
                                                      fontSize: 12),
                                                  decoration: InputDecoration(
                                                    suffixIcon: Container(
                                                      height: 20,
                                                      width: 20,
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          top: 5,
                                                          bottom: 5),
                                                      child: SvgPicture.asset(
                                                          "assets/edit.svg"),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 0),
                                                    filled: true,
                                                    hintText: "Enter IFSC code",
                                                    hintStyle: TextStyle(
                                                        height: 1.8,
                                                        color: CustomTheme
                                                            .appColors.white),
                                                    fillColor: CustomTheme
                                                        .appColors
                                                        .primaryColor50,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          Container(
                                            height: 30,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                                left: 5, right: 5, top: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: CustomTheme
                                                  .appColors.primaryColor50,
                                            ),
                                            child: Row(children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: CustomTheme.appColors
                                                        .secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                child: SvgPicture.asset(
                                                    "assets/swift.svg"),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  // controller: _textController2,
                                                  // focusNode: _textFocus2,
                                                  cursorColor: CustomTheme
                                                      .appColors.white,
                                                  textInputAction:
                                                      TextInputAction.go,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: CustomTheme
                                                          .appColors.white,
                                                      fontSize: 12),
                                                  decoration: InputDecoration(
                                                    suffixIcon: Container(
                                                      height: 20,
                                                      width: 20,
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          top: 5,
                                                          bottom: 5),
                                                      child: SvgPicture.asset(
                                                          "assets/edit.svg"),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 0),
                                                    filled: true,
                                                    hintText:
                                                        "Enter SWIFT code",
                                                    hintStyle: TextStyle(
                                                        height: 1.8,
                                                        color: CustomTheme
                                                            .appColors.white),
                                                    fillColor: CustomTheme
                                                        .appColors
                                                        .primaryColor50,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: CustomTheme
                                                              .appColors
                                                              .primaryColor50,
                                                          width: 0.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          height: 30,
                                          margin:
                                              EdgeInsets.fromLTRB(5, 5, 0, 5),
                                          decoration: BoxDecoration(
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.all(5),
                                                child: SvgPicture.asset(
                                                    "assets/edit.svg"),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                "Edit this item",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 10),
                                              )),
                                              Container(
                                                height: 20,
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          height: 30,
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: CustomTheme
                                                  .appColors.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: EdgeInsets.all(5),
                                                child: SvgPicture.asset(
                                                    "assets/delete.svg"),
                                              ),
                                              Expanded(
                                                  child: Text(
                                                "Delete this item",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 10),
                                              )),
                                              Container(
                                                height: 20,
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                        )),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                      )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCountryPicker = true;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                "Add payment methods",
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
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget? _showBottomSheet() {
    // GestureDetector(
    //           onTap: () {
    //             Navigator.pushNamed(context, "/addPaymentMethod");
    //           },
    // );
    if (_showCountryPicker &&
        !(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 180,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            decoration: BoxDecoration(
              color: CustomTheme.appColors.primaryColor50,
              boxShadow: [
                BoxShadow(
                  color: CustomTheme.appColors.secondaryColor,
                  spreadRadius: 2.5,
                  blurRadius: 2.5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 40,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: 40,
              itemBuilder: (context, index) {
                return Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                    color: CustomTheme.appColors.bjpOrange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

import 'dart:collection';
import 'package:bellani_talents_market/model/Success.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';

class AddSocialMedia extends StatefulWidget {
  AddSocialMedia({Key? key}) : super(key: key);

  @override
  State<AddSocialMedia> createState() => _AddSocialMediaState();
}

class _AddSocialMediaState extends State<AddSocialMedia> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  TextEditingController _textController2 = new TextEditingController();
  FocusNode _textFocus2 = new FocusNode();
  TextEditingController _textController3 = new TextEditingController();
  FocusNode _textFocus3 = new FocusNode();
  Account user = AccountApiFromJson(sp.getString("userdata")!);
  int selectedYear = 0, selectedMonth = 0, _selectedDate = 32;
  late DateTime firstDayOfMonth, lastDayOfMonth, firstMonth, lastMonth;
  bool _yearSelected = false, _monthSelected = false;
  bool focused = false;
  bool focused2 = false;
  bool focused3 = false;
  bool _showCountryPicker = false;
  List<DateTime> days = [];
  var photo =
      "https://media.istockphoto.com/vectors/user-avatar-profile-icon-black-vector-illustration-vector-id1209654046?k=20&m=1209654046&s=612x612&w=0&h=Atw7VdjWG8KgyST8AXXJdmBkzn0lvgqyWod9vTb2XoE=";
  List<int> months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> years = [2022, 2023, 2024, 2025, 2026];
  final Map<String, String> selectedValue = HashMap();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textFocus2.addListener(onChange);
    _textController2.addListener(onChange);
    _textFocus3.addListener(onChange);
    _textController3.addListener(onChange);
  }

  void onChange() {
    String searchText = _textController.text;
    bool hasFocus = _textFocus.hasFocus;

    if (hasFocus) {
      setState(() {
        focused = true;
      });
    } else {
      setState(() {
        focused = false;
      });
    }

    bool hasFocus2 = _textFocus2.hasFocus;

    if (hasFocus2) {
      setState(() {
        focused2 = true;
      });
    } else {
      setState(() {
        focused2 = false;
      });
    }

    bool hasFocus3 = _textFocus3.hasFocus;

    if (hasFocus3) {
      setState(() {
        focused3 = true;
      });
    } else {
      setState(() {
        focused3 = false;
      });
    }
  }

  Widget? _showBottomSheet() {
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/addPaymentMethod");
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      color: CustomTheme.appColors.bjpOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
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
                                "Add social media",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          )
                        ]),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor50,
                            ),
                            child: Row(children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset(
                                    "assets/bellani_messenger.svg"),
                              ),
                              Expanded(
                                child: Text(
                                  user.username,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                              )
                            ]),
                          ),
                          Container(
                            height: 30,
                            width: double.infinity,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor50,
                            ),
                            child: Row(children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child:
                                    SvgPicture.asset("assets/talent_info.svg"),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _textController,
                                  focusNode: _textFocus,
                                  cursorColor: CustomTheme.appColors.white,
                                  textInputAction: TextInputAction.go,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: CustomTheme.appColors.white,
                                      fontSize: 12),
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(
                                          left: 20, top: 5, bottom: 5),
                                      // child: SvgPicture.asset("assets/edit.svg"),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 0),
                                    filled: true,
                                    hintText:
                                        focused ? "" : "Portfolio/Resume URL",
                                    hintStyle: TextStyle(
                                        height: 1.8,
                                        color: CustomTheme.appColors.white),
                                    fillColor:
                                        CustomTheme.appColors.primaryColor50,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomTheme
                                              .appColors.primaryColor50,
                                          width: 0.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomTheme
                                              .appColors.primaryColor50,
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
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor50,
                            ),
                            child: Row(children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/insta.svg"),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _textController2,
                                  focusNode: _textFocus2,
                                  cursorColor: CustomTheme.appColors.white,
                                  textInputAction: TextInputAction.go,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: CustomTheme.appColors.white,
                                      fontSize: 12),
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(
                                          left: 20, top: 5, bottom: 5),
                                      // child: SvgPicture.asset("assets/edit.svg"),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 0),
                                    filled: true,
                                    hintText: focused2 ? "" : "Instagram URL",
                                    hintStyle: TextStyle(
                                        height: 1.8,
                                        color: CustomTheme.appColors.white),
                                    fillColor:
                                        CustomTheme.appColors.primaryColor50,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomTheme
                                              .appColors.primaryColor50,
                                          width: 0.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomTheme
                                              .appColors.primaryColor50,
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
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: CustomTheme.appColors.primaryColor50,
                            ),
                            child: Row(children: [
                              Container(
                                height: 20,
                                width: 20,
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: CustomTheme.appColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(6)),
                                child: SvgPicture.asset("assets/facebook.svg"),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _textController3,
                                  focusNode: _textFocus3,
                                  cursorColor: CustomTheme.appColors.white,
                                  textInputAction: TextInputAction.go,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: CustomTheme.appColors.white,
                                      fontSize: 12),
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      height: 20,
                                      width: 20,
                                      margin: EdgeInsets.only(
                                          left: 20, top: 5, bottom: 5),
                                      // child: SvgPicture.asset("assets/edit.svg"),
                                    ),
                                    contentPadding: EdgeInsets.only(bottom: 0),
                                    filled: true,
                                    hintText: focused3 ? "" : "Facebook URL",
                                    hintStyle: TextStyle(
                                        height: 1.8,
                                        color: CustomTheme.appColors.white),
                                    fillColor:
                                        CustomTheme.appColors.primaryColor50,
                                    disabledBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomTheme
                                              .appColors.primaryColor50,
                                          width: 0.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: CustomTheme
                                              .appColors.primaryColor50,
                                          width: 0.0),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      )),
                      GestureDetector(
                        onTap: () async {
                          // setState(() {
                          //   _showCountryPicker = true;
                          // });
                          // if (_textController.text.isNotEmpty &&
                          //     _textController2.text.isNotEmpty &&
                          //     _textController3.text.isNotEmpty) {
                            Success activity = await ApiService()
                                .addSocialMedia(
                                    _textController.text,
                                    _textController2.text,
                                    _textController3.text,
                                    "0");
                            if (activity.status == "success") {
                              Navigator.pushNamed(context, "/addPaymentMethod");
                            }
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //     backgroundColor:
                          //         CustomTheme.appColors.primaryColor50,
                          //     content: Text(
                          //       "Please fill all fields",
                          //       style: TextStyle(
                          //           color: CustomTheme.appColors.white),
                          //     ),
                          //   ));
                          // }
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
                                "Add payment method",
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
}

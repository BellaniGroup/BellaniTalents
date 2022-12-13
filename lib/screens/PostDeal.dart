import 'package:bellani_talents_market/model/PostDealDetails.dart';
import 'package:bellani_talents_market/model/Success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../model/MarqueeWidget.dart';
import '../../services/ApiService.dart';
import '../../strings/strings.dart';
import '../../theme/custom_theme.dart';
import '../main.dart';
import '../model/PostDealSuccess.dart';
import 'addCompany/bloc/add_company_bloc.dart';
import 'otp/OtpScreen.dart';

class PostDeal extends StatefulWidget {
  const PostDeal({Key? key}) : super(key: key);

  @override
  State<PostDeal> createState() => _PostDealState();
}

class _PostDealState extends State<PostDeal> {
  TextEditingController _textController = new TextEditingController();
  TextEditingController _textController2 = new TextEditingController();
  TextEditingController _textController3 = new TextEditingController();
  TextEditingController _textController4 = new TextEditingController();
  TextEditingController _textController5 = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  FocusNode _textFocus2 = new FocusNode();
  FocusNode _textFocus3 = new FocusNode();
  FocusNode _textFocus4 = new FocusNode();
  FocusNode _textFocus5 = new FocusNode();
  bool focused = false;
  bool focused2 = false;
  bool focused3 = false;
  bool focused4 = false;
  bool focused5 = false;
  List<String> services = ["s1", "s2", "s3"];
  List<String> categories = ["c1", "c2", "c3"];
  var selectedCategory, selectedServices;
  var selectedCategory2, selectedServices2;
  var focusNode0 = FocusNode();
  var focusNode1 = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  bool _showDatePicker = false;
  bool _showDatePicker2 = false;
  var selectedEmployees, selectedFromDate, selectedToDate;
  final now = DateTime.now();
  DateFormat formattedDate = DateFormat('dd/MM/yyyy');
  var startDate;

  @override
  void initState() {
    selectedFromDate = "From date*";
    selectedToDate = "To date*";

    super.initState();
    _textFocus.addListener(onChange);
    _textController.addListener(onChange);
    _textFocus2.addListener(onChange);
    _textController2.addListener(onChange);
    _textFocus3.addListener(onChange);
    _textController3.addListener(onChange);
    _textFocus4.addListener(onChange);
    _textController4.addListener(onChange);
    _textFocus5.addListener(onChange);
    _textController5.addListener(onChange);
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

    String searchText2 = _textController2.text;
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

    String searchText3 = _textController3.text;
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

    String searchText4 = _textController4.text;
    bool hasFocus4 = _textFocus4.hasFocus;

    if (hasFocus4) {
      setState(() {
        focused4 = true;
      });
    } else {
      setState(() {
        focused4 = false;
      });
    }

    String searchText5 = _textController5.text;
    bool hasFocus5 = _textFocus5.hasFocus;

    if (hasFocus5) {
      setState(() {
        focused5 = true;
      });
    } else {
      setState(() {
        focused5 = false;
      });
    }
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
            BlocProvider<AddCompanyBloc>(
                create: (context) => AddCompanyBloc(
                      RepositoryProvider.of<ApiService>(context),
                    )),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomSheet: _showBottomSheet(now),
            backgroundColor: CustomTheme.appColors.primaryColor,
            body: GestureDetector(
              onTap: () {
                setState(() {
                  if (_showDatePicker) {
                    _showDatePicker = false;
                  }
                  if (_showDatePicker2) {
                    _showDatePicker2 = false;
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
                            child: MarqueeWidget(
                              animationDuration: Duration(milliseconds: 1000),
                              pauseDuration: Duration(milliseconds: 800),
                              backDuration: Duration(milliseconds: 1000),
                              child: Text(
                                "Post a deal",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                        )
                      ]),
                    ),
                    registerNew(),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (_textController.text.isEmpty ||
                            _textController2.text.isEmpty ||
                            selectedToDate == "To date*") {
                               ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  // padding: EdgeInsets.only(top: 30),
                                  backgroundColor: CustomTheme.appColors.white,
                                  content: Container(
                                    height: 32,
                                    alignment: Alignment.center,
                                    child: Text(
                              "Please fill all mandatory fields",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily:
                                              sp.getString("selectedFont"),
                                          color: CustomTheme
                                              .appColors.secondaryColor),
                                    ),
                                  ),
                                ));
                        } else {
                          PostDealSuccess suc = await ApiService().postDeal(
                              PostDealDetails(
                                  title: _textController.text,
                                  desc: _textController2.text,
                                  driveUrl: _textController3.text,
                                  dropboxUrl: _textController4.text,
                                  promotionUrl: _textController5.text,
                                  fromDate: selectedFromDate,
                                  toDate: selectedToDate));
                          if (suc.status == "success") {
                            Navigator.pushNamed(context, "/dealRequirements",
                                arguments: {"deal_id": suc.id});
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                    "Select services",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 35,
                              padding: EdgeInsets.all(10),
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
      ),
    );
  }

  registerNew() {
    return Column(
      children: [
        Container(
          height: 30,
          width: double.infinity,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: CustomTheme.appColors.primaryColor50,
          ),
          child: Row(children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.all(5),
              child: SvgPicture.asset("assets/collab_center.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController,
                focusNode: _textFocus,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused ? "" : "Enter title here*",
                  hintStyle: TextStyle(
                      height: 1.8, color: CustomTheme.appColors.white),
                  fillColor: CustomTheme.appColors.primaryColor50,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
                        width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
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
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: CustomTheme.appColors.primaryColor50,
          ),
          child: Row(children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.all(5),
              child: SvgPicture.asset("assets/description.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController2,
                focusNode: _textFocus2,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused2 ? "" : "Enter description*",
                  hintStyle: TextStyle(
                      height: 1.8, color: CustomTheme.appColors.white),
                  fillColor: CustomTheme.appColors.primaryColor50,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
                        width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
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
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: CustomTheme.appColors.primaryColor50,
          ),
          child: Row(children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.all(5),
              child: SvgPicture.asset("assets/google_drive.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController3,
                focusNode: _textFocus3,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused3 ? "" : "Google drive link",
                  hintStyle: TextStyle(
                      height: 1.8, color: CustomTheme.appColors.white),
                  fillColor: CustomTheme.appColors.primaryColor50,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
                        width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
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
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: CustomTheme.appColors.primaryColor50,
          ),
          child: Row(children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.all(5),
              child: SvgPicture.asset("assets/dropbox.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController4,
                focusNode: _textFocus4,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused4 ? "" : "Dropbox link",
                  hintStyle: TextStyle(
                      height: 1.8, color: CustomTheme.appColors.white),
                  fillColor: CustomTheme.appColors.primaryColor50,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
                        width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
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
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: CustomTheme.appColors.primaryColor50,
          ),
          child: Row(children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.all(5),
              child: SvgPicture.asset("assets/promotion.svg"),
            ),
            Expanded(
              child: TextFormField(
                controller: _textController5,
                focusNode: _textFocus5,
                cursorColor: CustomTheme.appColors.white,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    // child: SvgPicture.asset("assets/edit.svg"),
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0),
                  filled: true,
                  hintText: focused5 ? "" : "Promotional link",
                  hintStyle: TextStyle(
                      height: 1.8, color: CustomTheme.appColors.white),
                  fillColor: CustomTheme.appColors.primaryColor50,
                  disabledBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
                        width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomTheme.appColors.primaryColor50,
                        width: 0.0),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (!_showDatePicker &&
                      !(WidgetsBinding.instance.window.viewInsets.bottom >
                          0.0)) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    selectedFromDate = formattedDate.format(now);
                    startDate = now;
                    _showDatePicker = true;
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _showDatePicker = false;
                  }
                });
              },
              child: Container(
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
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: SvgPicture.asset("assets/calendar.svg")),
                  ),
                  Expanded(
                      child: Text(
                    selectedFromDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  )),
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(5),
                    // child:
                    //     SvgPicture.asset("assets/edit.svg"),
                  ),
                ]),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_showDatePicker) {
                    setState(() {
                      _showDatePicker = false;
                    });
                  } else {
                    if (!_showDatePicker2 &&
                        !(WidgetsBinding.instance.window.viewInsets.bottom >
                            0.0)) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      selectedToDate = selectedFromDate;
                      _showDatePicker2 = true;
                    } else {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _showDatePicker2 = false;
                    }
                  }
                });
              },
              child: Container(
                height: 30,
                width: double.infinity,
                margin: EdgeInsets.only(left: 5, right: 10, top: 10),
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
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: CustomTheme.appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(6)),
                        child: SvgPicture.asset("assets/calendar.svg")),
                  ),
                  Expanded(
                      child: Text(
                    selectedToDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  )),
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.all(5),
                    // child:
                    //     SvgPicture.asset("assets/edit.svg"),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Widget? _showBottomSheet(now) {
    if (_showDatePicker &&
        !(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 180,
            color: CustomTheme.appColors.primaryColor50,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DatePickerWidget(
              looping: true, // default is not looping
              firstDate: new DateTime(now.year, now.month, now.day),
              lastDate: new DateTime(now.year + 20),
              initialDate: new DateTime(now.year, now.month, now.day),
              dateFormat:
                  // "MM-dd(E)",
                  "dd/MMMM/yyyy",
              //     locale: DatePicker.localeFromString('he'),
              onChange: (DateTime newDate, _a) {
                setState(() {
                  startDate = newDate;
                  selectedFromDate = formattedDate.format(newDate);
                });
              },
              pickerTheme: DateTimePickerTheme(
                backgroundColor: CustomTheme.appColors.primaryColor50,
                itemTextStyle: TextStyle(
                    color: CustomTheme.appColors.white,
                    fontSize: 19,
                    fontFamily: "AvenirNext"),
                dividerColor: CustomTheme.appColors.primaryColor,
              ),
            ),
          );
        },
      );
    } else if (_showDatePicker2 &&
        !(WidgetsBinding.instance.window.viewInsets.bottom > 0.0)) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            height: 180,
            color: CustomTheme.appColors.primaryColor50,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DatePickerWidget(
              looping: true, // default is not looping
              firstDate: startDate,
              // firstDate: new DateTime(now.year, now.month, now.day),
              lastDate: new DateTime(now.year + 20),
              initialDate: new DateTime(now.year, now.month, now.day),
              dateFormat:
                  // "MM-dd(E)",
                  "dd/MMMM/yyyy",
              //     locale: DatePicker.localeFromString('he'),
              onChange: (DateTime newDate, _a) {
                setState(() {
                  selectedToDate = formattedDate.format(newDate);
                });
              },
              pickerTheme: DateTimePickerTheme(
                backgroundColor: CustomTheme.appColors.primaryColor50,
                itemTextStyle: TextStyle(
                    color: CustomTheme.appColors.white,
                    fontSize: 19,
                    fontFamily: "AvenirNext"),
                dividerColor: CustomTheme.appColors.primaryColor,
              ),
            ),
          );
        },
      );
    } else {
      return null;
    }
  }
}

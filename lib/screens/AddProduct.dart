import 'dart:collection';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
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
                              "Add a product",
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
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: CustomTheme.appColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: SvgPicture.asset("assets/rupee_tag.svg"),
                            ),
                            Expanded(
                              child: TextFormField(
                                // controller: _textController2,
                                // focusNode: _textFocus2,
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
                                  hintText: "Enter title here",
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
                              decoration: BoxDecoration(
                                  color: CustomTheme.appColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: SvgPicture.asset("assets/description.svg"),
                            ),
                            Expanded(
                              child: TextFormField(
                                // controller: _textController2,
                                // focusNode: _textFocus2,
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
                                  hintText: "Enter description here",
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
                              decoration: BoxDecoration(
                                  color: CustomTheme.appColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: SvgPicture.asset("assets/rupee.svg"),
                            ),
                            Expanded(
                              child: TextFormField(
                                // controller: _textController2,
                                // focusNode: _textFocus2,
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
                                  hintText: "Enter price",
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
                      onTap: () {
                        Navigator.pushNamed(context, "/uploadProductImage");
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
                              "Upload product image",
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
            )),
      ),
    );
  }
}

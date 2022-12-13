import 'dart:collection';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';
import '../model/MarqueeWidget.dart';
import '../strings/strings.dart';

class ManageDeals extends StatefulWidget {
  ManageDeals({Key? key}) : super(key: key);

  @override
  State<ManageDeals> createState() => _ManageDealsState();
}

class _ManageDealsState extends State<ManageDeals> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                            child: MarqueeWidget(
                              animationDuration: Duration(milliseconds: 1000),
                              pauseDuration: Duration(milliseconds: 800),
                              backDuration: Duration(milliseconds: 1000),
                              child: Text(
                                "Manage deals",
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
                    SizedBox(
                      height: 10,
                    ),
                    if (!_yearSelected && !_monthSelected) yearCalender(),
                    if (_yearSelected) monthCalender(),
                    // if (_yearSelected && _monthSelected) dayCalender(),
                    if (_yearSelected && _monthSelected)
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          decoration: BoxDecoration(
                              color: CustomTheme.appColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6))),
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: 6,
                              shrinkWrap: true,
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/manageOneDeal");
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    margin: EdgeInsets.only(top: 5),
                                    padding: EdgeInsets.only(right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                    ),
                                    child: Row(children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin:
                                            EdgeInsets.fromLTRB(5, 0, 10, 0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Image.network(photo),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "@username",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: CustomTheme
                                                      .appColors.white),
                                            ),
                                            Text(
                                              "service",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: CustomTheme
                                                      .appColors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "6/20",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: CustomTheme.appColors.white),
                                      ),
                                    ]),
                                  ),
                                );
                              }),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  List<DateTime> getDatesInMonth(DateTime startDate, DateTime endDate) {
    days.clear();
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime(
          startDate.year,
          startDate.month,
          // In Dart you can set more than. 30 days, DateTime will do the trick
          startDate.day + i));
    }
    return days;
  }

  dayCalender() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: CustomTheme.appColors.secondaryColor,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: CustomTheme.appColors.primaryColor50,
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _yearSelected = true;
                _monthSelected = false;
                _selectedDate = 32;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedMonth < 10
                          ? "0" + selectedMonth.toString()
                          : selectedMonth.toString(),
                      style: TextStyle(
                        color: CustomTheme.appColors.white,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      selectedYear.toString(),
                      style: TextStyle(
                        color: CustomTheme.appColors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                color: CustomTheme.appColors.primaryColor50,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    DateFormat formatter = DateFormat("dd");
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = index;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: _selectedDate == index
                                ? CustomTheme.appColors.primaryColor
                                : null,
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatter.format(days[index]),
                                style: TextStyle(
                                  color: CustomTheme.appColors.white,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Container(
                                  height: 15,
                                  width: 15,
                                  child: index == 29
                                      ? SvgPicture.asset("assets/noti_dot.svg")
                                      : null),
                            ]),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }

  monthCalender() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: CustomTheme.appColors.primaryColor,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: CustomTheme.appColors.primaryColor50,
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _yearSelected = false;
                _monthSelected = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor,
              ),
              child: Center(
                child: Text(
                  selectedYear.toString(),
                  style: TextStyle(
                    color: CustomTheme.appColors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                color: CustomTheme.appColors.primaryColor50,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: months.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _yearSelected = true;
                          _monthSelected = true;
                          selectedMonth = months[index];
                          firstDayOfMonth =
                              new DateTime(selectedYear, selectedMonth, 1);
                          lastDayOfMonth =
                              new DateTime(selectedYear, selectedMonth + 1, 0);
                          days =
                              getDatesInMonth(firstDayOfMonth, lastDayOfMonth);
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                months[index] < 10
                                    ? "0" + months[index].toString()
                                    : months[index].toString(),
                                style: TextStyle(
                                  color: CustomTheme.appColors.white,
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                selectedYear.toString(),
                                style: TextStyle(
                                  color: CustomTheme.appColors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }

  yearCalender() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 0, left: 10, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        color: CustomTheme.appColors.primaryColor,
      ),
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: CustomTheme.appColors.primaryColor50,
        ),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _yearSelected = false;
                _monthSelected = false;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: CustomTheme.appColors.primaryColor,
              ),
              child: Center(
                child: SvgPicture.asset("assets/calendar.svg"),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                color: CustomTheme.appColors.primaryColor50,
              ),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: years.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedYear = years[index];
                          _yearSelected = true;
                          _monthSelected = false;
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            years[index].toString(),
                            style: TextStyle(
                              color: CustomTheme.appColors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
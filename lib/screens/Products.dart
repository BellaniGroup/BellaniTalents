import 'dart:collection';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';

class Products extends StatefulWidget {
  Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
                              "Products",
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
                        child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: CustomTheme.appColors.primaryColor50,
                          borderRadius: BorderRadius.circular(6)),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: 2,
                          shrinkWrap: true,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 190,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: CustomTheme.appColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    margin: EdgeInsets.only(left: 10, right: 5),
                                    alignment: Alignment.centerLeft,
                                    child: Row(children: [
                                      Expanded(
                                        child: Text(
                                          "Outfit for bride and groom",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: CustomTheme.appColors.white,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Text(
                                          "₹20,000",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: CustomTheme
                                                  .appColors.primaryColor),
                                        ),
                                      )
                                    ]),
                                  ),
                                  Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                        color:
                                            CustomTheme.appColors.primaryColor,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          margin:
                                              EdgeInsets.fromLTRB(5, 5, 5, 0),
                                          decoration: BoxDecoration(
                                              color: CustomTheme
                                                  .appColors.bjpOrange,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 5, 0, 0),
                                          child: Text(
                                            "A complete outfit for both the bride and the groom, from designing to fabric materials, and stitching included, for a flat rate. Synthetic materials only.",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

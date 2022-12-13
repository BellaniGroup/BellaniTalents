import 'dart:collection';
import 'dart:ffi';
import 'package:bellani_talents_market/model/PaymentMethods.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';

class AddBankAccount extends StatefulWidget {
  AddBankAccount({Key? key}) : super(key: key);

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  TextEditingController _textController1 = new TextEditingController();
  TextEditingController _textController2 = new TextEditingController();
  TextEditingController _textController3 = new TextEditingController();
  TextEditingController _textController4 = new TextEditingController();
  TextEditingController _textController5 = new TextEditingController();
  TextEditingController _textController6 = new TextEditingController();
  TextEditingController _textController7 = new TextEditingController();
  TextEditingController _textController8 = new TextEditingController();
  TextEditingController _textController9 = new TextEditingController();
  TextEditingController _textController10 = new TextEditingController();
  TextEditingController _textController11 = new TextEditingController();
  TextEditingController _textController12 = new TextEditingController();
  TextEditingController _textController13 = new TextEditingController();
  TextEditingController _textController14 = new TextEditingController();
  TextEditingController _textController15 = new TextEditingController();
  TextEditingController _textController16 = new TextEditingController();
  TextEditingController _textController17 = new TextEditingController();
  TextEditingController _textController18 = new TextEditingController();
  TextEditingController _textController19 = new TextEditingController();

  late Map<int, TextEditingController> map;
  FocusNode _textFocus = new FocusNode();
  List<int> controller_index = [];
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

    map = {
      1: _textController1,
      2: _textController2,
      3: _textController3,
      4: _textController4,
      5: _textController5,
      6: _textController6,
      7: _textController7,
      8: _textController8,
      9: _textController9,
      10: _textController10,
      11: _textController11,
      12: _textController12,
      13: _textController13,
      14: _textController14,
      15: _textController15,
      16: _textController16,
      17: _textController17,
      18: _textController18,
      19: _textController19,
    };
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    BankingOptions accDetails = arguments["accDetails"];

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
                              "Add a bank account",
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
                        if (accDetails.accountNumber == "1")
                          textField("Enter Account number", map[1], 1),
                        if (accDetails.accountOwnerName == "1")
                          textField("Enter Account name", map[2], 2),
                        if (accDetails.accountType == "1")
                          textField("Enter Account type", map[3], 3),
                        if (accDetails.bankCode == "1")
                          textField("Enter Bank code", map[4], 4),
                        if (accDetails.bankName == "1")
                          textField("Enter Bank name", map[5], 5),
                        if (accDetails.bic == "1")
                          textField("Enter BIC", map[6], 6),
                        if (accDetails.branchCode == "1")
                          textField("Enter Branch code", map[7], 7),
                        if (accDetails.branchName == "1")
                          textField("Enter Branch name", map[8], 8),
                        if (accDetails.bsb == "1")
                          textField("Enter BSB", map[9], 9),
                        if (accDetails.cbu == "1")
                          textField("Enter CBU", map[10], 10),
                        if (accDetails.cci == "1")
                          textField("Enter CCI", map[11], 11),
                        if (accDetails.clabe == "1")
                          textField("Enter CLABE", map[12], 12),
                        if (accDetails.iban == "1")
                          textField("Enter IBAN", map[13], 13),
                        if (accDetails.ifsc == "1")
                          textField("Enter IFSC", map[14], 14),
                        if (accDetails.institutionNumber == '1')
                          textField("Enter Institution number", map[15], 15),
                        if (accDetails.routingNumber == "1")
                          textField("Enter Routing number", map[16], 16),
                        if (accDetails.sortCode == "1")
                          textField("Enter Sort code", map[17], 17),
                        if (accDetails.swift == "1")
                          textField("Enter SWIFT", map[18], 18),
                        if (accDetails.transitNumber == "1")
                          textField("Enter Transit number", map[19], 19),
                      ],
                    )),
                    GestureDetector(
                      onTap: () {
                        Object accDetail = {
                          "talent_id": user.talentId,
                          "country_code": accDetails.countryCode,
                          "account_number": map[1]!.text,
                          "account_owner_name": map[2]!.text,
                          "account_type": map[3]!.text,
                          "bank_code": map[4]!.text,
                          "bank_name": map[5]!.text,
                          "bic": map[6]!.text,
                          "branch_code": map[7]!.text,
                          "branch_name": map[8]!.text,
                          "bsb": map[9]!.text,
                          "cbu": map[10]!.text,
                          "cci": map[11]!.text,
                          "clabe": map[12]!.text,
                          "iban": map[13]!.text,
                          "ifsc": map[14]!.text,
                          "institution_number": map[15]!.text,
                          "routing_number": map[16]!.text,
                          "sort_code": map[17]!.text,
                          "swift": map[18]!.text,
                          "transit_number": map[19]!.text
                        };
                        ApiService().addBankAccount(
                            user.talentId, accDetails.countryCode, accDetail);
                        // for (int i in map.keys) {
                        //   if (map[i]!.value.text.isNotEmpty) {
                        //     var s = map[i]!.text;
                        //     var t = s;
                        //   }
                        // }
                        // Navigator.pushNamed(context, "/uploadImage");
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
                              "Add Account",
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

  textField(String hint, TextEditingController? _textController, int index) {
    return Container(
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
          child: SvgPicture.asset("assets/bank.svg"),
        ),
        Expanded(
          child: TextFormField(
            controller: _textController,
            // focusNode: _textFocus2,
            cursorColor: CustomTheme.appColors.white,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textAlign: TextAlign.center,
            style: TextStyle(color: CustomTheme.appColors.white, fontSize: 12),
            decoration: InputDecoration(
              suffixIcon: Container(
                height: 20,
                width: 20,
                margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                // child: SvgPicture.asset("assets/edit.svg"),
              ),
              contentPadding: EdgeInsets.only(bottom: 0),
              filled: true,
              hintText: hint,
              hintStyle:
                  TextStyle(height: 1.8, color: CustomTheme.appColors.white),
              fillColor: CustomTheme.appColors.primaryColor50,
              disabledBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomTheme.appColors.primaryColor50, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomTheme.appColors.primaryColor50, width: 0.0),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

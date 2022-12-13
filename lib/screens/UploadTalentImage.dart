import 'dart:collection';
import 'dart:io';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/ApiService.dart';
import '../main.dart';
import '../model/Account.dart';
import '../model/ImageUploaded.dart';

class UploadTalentImage extends StatefulWidget {
  UploadTalentImage({Key? key}) : super(key: key);

  @override
  State<UploadTalentImage> createState() => _UploadTalentImageState();
}

class _UploadTalentImageState extends State<UploadTalentImage> {
  TextEditingController _textController = new TextEditingController();
  FocusNode _textFocus = new FocusNode();
  File imageFile = File("");
  int selectedYear = 0, selectedMonth = 0, _selectedDate = 32;
  late DateTime firstDayOfMonth, lastDayOfMonth, firstMonth, lastMonth;
  bool _yearSelected = false, _monthSelected = false;
  bool focused = false;
  var uploadedImageUrl;
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
                              "Upload image",
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
                          height: 100,
                          decoration: BoxDecoration(
                              color: CustomTheme.appColors.primaryColor,
                              borderRadius: BorderRadius.circular(6)),
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  _getFromGallery();
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                  decoration: BoxDecoration(
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                      height: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      child: SvgPicture.asset(
                                          "assets/add_from_gallery.svg")),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  _getFromCamera();
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                  decoration: BoxDecoration(
                                      color:
                                          CustomTheme.appColors.primaryColor50,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Container(
                                      height: double.infinity,
                                      padding: EdgeInsets.all(15),
                                      child: SvgPicture.asset(
                                          "assets/camera.svg")),
                                ),
                              )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: BoxDecoration(
                              color: CustomTheme.appColors.primaryColor,
                              borderRadius: BorderRadius.circular(6),
                              image: uploadedImageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(uploadedImageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        )
                      ],
                    )),
                    GestureDetector(
                      onTap: () async {
                        if (uploadedImageUrl != null) {
                          Navigator.pushNamed(context, "/addSocialMedia");
                        }
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
                              "Add social media",
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

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      ImageUploaded uploadImage =
          await ApiService().uploadTalentImage(imageFile, user.talentId);
      if (uploadImage.status == "success") {
        setState(() {
          uploadedImageUrl = uploadImage.url +
              "?q" +
              DateTime.now().millisecondsSinceEpoch.toString();
        });
      }
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      ImageUploaded uploadImage =
          await ApiService().uploadTalentImage(imageFile, user.talentId);
      if (uploadImage.status == "success") {
        setState(() {
          uploadedImageUrl = uploadImage.url +
              "?q" +
              DateTime.now().millisecondsSinceEpoch.toString();
        });
      }
    }
  }
}

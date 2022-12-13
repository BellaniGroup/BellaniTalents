// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   GlobalKey<FormState> _formKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Phone Field Example'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(height: 30),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Name',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 IntlPhoneField(
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                     ),
//                   ),
//                   onChanged: (phone) {
//                     print(phone.completeNumber);
//                   },
//                   onCountryChanged: (country) {
//                     print('Country changed to: ' + country.name);
//                   },
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 MaterialButton(
//                   child: Text('Submit'),
//                   color: Theme.of(context).primaryColor,
//                   textColor: Colors.white,
//                   onPressed: () {
//                     _formKey.currentState?.validate();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:bellani_talents_market/firebase_options.dart';
import 'package:bellani_talents_market/screens/AddLocation.dart';
import 'package:bellani_talents_market/screens/AddProduct.dart';
import 'package:bellani_talents_market/screens/AddSocialMedia.dart';
import 'package:bellani_talents_market/screens/CollabRequirements.dart';
import 'package:bellani_talents_market/screens/DealCenter.dart';
import 'package:bellani_talents_market/screens/DealRequirements.dart';
import 'package:bellani_talents_market/screens/EditOneBellani.dart';
import 'package:bellani_talents_market/screens/EditTalent.dart';
import 'package:bellani_talents_market/screens/EditTalentProfile.dart';
import 'package:bellani_talents_market/screens/FacebookClicks.dart';
import 'package:bellani_talents_market/screens/InstaClicks.dart';
import 'package:bellani_talents_market/screens/IntermediateScreen.dart';
import 'package:bellani_talents_market/screens/ManageDeals.dart';
import 'package:bellani_talents_market/screens/ManageOneDeal.dart';
import 'package:bellani_talents_market/screens/ManagePaymentMethods.dart';
import 'package:bellani_talents_market/screens/PaymentDetailsScreen.dart';
import 'package:bellani_talents_market/screens/PostCollab.dart';
import 'package:bellani_talents_market/screens/Products.dart';
import 'package:bellani_talents_market/screens/ProfileView.dart';
import 'package:bellani_talents_market/screens/SelectCollabLocation.dart';
import 'package:bellani_talents_market/screens/SelectDealLoaction.dart';
import 'package:bellani_talents_market/screens/SelectLocation.dart';
import 'package:bellani_talents_market/screens/TalentDashboard.dart';
import 'package:bellani_talents_market/screens/UploadProductImage.dart';
import 'package:bellani_talents_market/screens/UploadTalentImage.dart';
import 'package:bellani_talents_market/screens/ViewCallers.dart';
import 'package:bellani_talents_market/screens/ViewWhatsappClick.dart';
import 'package:bellani_talents_market/screens/addCompany/AddCompanyScreen.dart';
import 'package:bellani_talents_market/screens/CompanyTalentsPackageRegister.dart';
import 'package:bellani_talents_market/screens/selectPlan/SelectPlanScreen.dart';
import 'package:bellani_talents_market/screens/TalentsPackageRegister.dart';
import 'package:bellani_talents_market/screens/TalentsPackageScreen.dart';
import 'package:bellani_talents_market/screens/agent/AgentScreen.dart';
import 'package:bellani_talents_market/screens/bellaniWallet/BellaniWalletScreen.dart';
import 'package:bellani_talents_market/screens/editProfile/EditProfileScreen.dart';
import 'package:bellani_talents_market/screens/home/HomeScreen.dart';
import 'package:bellani_talents_market/screens/login/LoginScreen.dart';
import 'package:bellani_talents_market/screens/manageEmployees.dart';
import 'package:bellani_talents_market/screens/packages/PackagesScreen.dart';
import 'package:bellani_talents_market/screens/register/RegisterScreen.dart';
import 'package:bellani_talents_market/screens/talents/TalentsScreen.dart';
import 'package:bellani_talents_market/screens/testScreen.dart';
import 'package:bellani_talents_market/screens/transaction/TransactionScreen.dart';
import 'package:bellani_talents_market/theme/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'screens/AddBankAccount.dart';
import 'screens/AddPaymentMethod.dart';
import 'screens/ManageProducts.dart';
import 'screens/CollabCenter.dart';
import 'screens/CollabCenterDetails.dart';
import 'screens/ManageCollabs.dart';
import 'screens/ManageOneCollab.dart';
import 'screens/ManageRoles.dart';
import 'screens/EditCompanyScreen.dart';
import 'screens/PostDeal.dart';

late SharedPreferences sp;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  sp = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talents',
      theme: CustomTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // '/searchScreen': (context) => const SearchScreen(),
        '/talentsScreen': (context) => const TalentsScreen(),
        '/registerScreen': (context) => const RegisterScreen(),
        '/loginScreen': (context) => const LoginScreen(),
        '/packagesScreen': (context) => const PackagesScreen(),
        '/agentScreen': (context) => const AgentScreen(),
        '/transactionScreen': (context) => const TransactionScreen(),
        '/editProfileScreen': (context) => const EditprofileScreen(),
        '/bellaniWalletScreen': (context) => const BellaniWalletScreen(),
        '/talentsPackageScreen': (context) => const TalentsPackageScreen(),
        '/talentsPackageRegister': (context) => const TalentsPackageRegister(),
        // '/selectPlanScreen': (context) => const SelectPlanScreen(),
        '/addCompanyScreen': (context) => const AddCompanyScreen(),
        '/editCompanyScreen': (context) => const EditCompanyScreen(),
        '/companyTalentsPackageRegister': (context) =>
            const CompanyTalentsPackageRegister(),
        '/manageEmployees': (context) => const ManageEmployees(),
        '/manageRoles': (context) => const ManageRoles(),
        '/collabCenter': (context) => const CollabCenter(),
        '/collabCenterDetails': (context) => const CollabCenterDetails(),
        '/viewCallers': (context) => ViewCallers(),
        '/postCollab': (context) => PostCollab(),
        '/postDeal': (context) => PostDeal(),
        '/dealRequirements': (context) => DealRequirements(),
        '/selectDealLocation': (context) => SelectDealLocation(),
        '/manageDeals': (context) => ManageDeals(),
        '/manageOneDeal': (context) => ManageOneDeal(),
        '/collabRequirements': (context) => CollabRequirements(),
        '/selectCollabLocation': (context) => SelectCollabLocation(),
        '/manageCollabs': (context) => ManageCollabs(),
        '/manageOneCollab': (context) => ManageOneCollab(),
        '/dealCenter': (context) => DealCenter(),
        '/manageProducts': (context) => ManageProducts(),
        '/addProduct': (context) => AddProduct(),
        '/uploadProductImage': (context) => UploadProductImage(),
        '/managePaymentMethods': (context) => ManagePaymentMethods(),
        '/addPaymentMethod': (context) => AddPaymentMethod(),
        '/addBankAccount': (context) => AddBankAccount(),
        '/editTalentProfile': (context) => EditTalentProfile(),
        '/products': (context) => Products(),
        '/paymentDetailsScreen': (context) => PaymentDetailsScreen(),
        '/viewWhatsappClick': (context) => ViewWhatsappClick(),
        '/facebookClicks': (context) => FacebookClicks(),
        '/instaClicks': (context) => InstaClicks(),
        '/intermediateScreen': (context) => IntermediateScreen(),
        '/editOneBellani': (context) => EditOneBellani(),
        '/editTalent': (context) => EditTalent(),
        '/selectLocation': (context) => SelectLocation(),
        '/addLocation': (context) => AddLocation(),
        '/uploadTalentImage': (context) => UploadTalentImage(),
        '/addSocialMedia': (context) => AddSocialMedia(),
        '/talentDashboard': (context) => TalentDashboard(),
        // '/profileView': (context) => ProfileView(),
        // '/OtpScreen': (context) => const OtpScreen(),
        '/test': (context) => const testScreen()
      },
    );
  }
}



// Convert a Widget to image byte code

// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:bellani_talents_market/theme/custom_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// void main() => runApp(new MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   GlobalKey _globalKey = new GlobalKey();
//   var img;

//   Future<Uint8List?> _capturePng() async {
//     try {
//       print('inside');
//       RenderRepaintBoundary? boundary = _globalKey.currentContext!
//           .findRenderObject() as RenderRepaintBoundary?;
//       ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
//       ByteData? byteData =
//           await image?.toByteData(format: ui.ImageByteFormat.png);
//       var pngBytes = byteData?.buffer.asUint8List();
//       var bs64 = base64Encode(pngBytes!);
//       print("start" + pngBytes.toString());
//       print(bs64);
//       setState(() {
//         img = pngBytes;
//       });
//       return pngBytes;
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       key: _globalKey,
//       child: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Widget To Image demo'),
//         ),
//         body: new Center(
//           child: new Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               new Text(
//                 'click below given button to capture iamge',
//               ),
//               new Container(
//                 child: GestureDetector(
//                     onTap: () {
//                       onPressed:
//                       _capturePng();
//                     },
//                     child: Text('capture Image')),
//               ),
//               if(img != null)
//               Center(
//                 child: Container(
//                   height: 180,
//                   width: 100,
//                   color: CustomTheme.appColors.bjpOrange,
//                   child: Padding(
//                     padding: EdgeInsets.all(12),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.memory(img)))),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

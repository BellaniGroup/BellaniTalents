import 'dart:convert';
import 'dart:io';

import 'package:bellani_talents_market/main.dart';
import 'package:bellani_talents_market/model/Account.dart';
import 'package:bellani_talents_market/model/AssetsResponse.dart';
import 'package:bellani_talents_market/model/AvailableServices.dart';
import 'package:bellani_talents_market/model/CategoriesResponse.dart';
import 'package:bellani_talents_market/model/DealRequirementModel.dart';
import 'package:bellani_talents_market/model/GetTalentsResponse.dart';
import 'package:bellani_talents_market/model/GetTypes.dart';
import 'package:bellani_talents_market/model/PaymentMethods.dart';
import 'package:bellani_talents_market/model/PostDealDetails.dart';
import 'package:bellani_talents_market/model/ProfileResponse.dart';
import 'package:bellani_talents_market/model/SearchTalent.dart';
import 'package:bellani_talents_market/model/ServicesResponse.dart';
import 'package:bellani_talents_market/model/Success.dart';
import 'package:bellani_talents_market/model/TalentRegisterModel.dart';
import 'package:bellani_talents_market/model/TalentRegisterResponse.dart';
import 'package:bellani_talents_market/model/Talents.dart';
import 'package:bellani_talents_market/model/Updated.dart';
import 'package:bellani_talents_market/model/UserRegisteredResponse.dart';
import 'package:bellani_talents_market/model/VerifyUsernameResponse.dart';
import 'package:bellani_talents_market/screens/register/bloc/register_bloc.dart';
import 'package:bellani_talents_market/screens/talents/TalentsScreen.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import '../model/AvailableCategories.dart';
import '../model/CollabRquirementModel.dart';
import '../model/DashboardNumbers.dart';
import '../model/ImageUploaded.dart';
import '../model/PostCollabDetails.dart';
import '../model/PostDealSuccess.dart';
import '../model/SearchServiceResponse.dart';
import '../model/UserLoginResponse.dart';

var BASE_URL = "http://api.bellani.in:5100/";
// var BASE_URL = "http://8ea1-49-205-81-165.ngrok.io/";

Account user = AccountApiFromJson(sp.getString("userdata")!);

class ApiService {
  Future<AssetsResponse> getAssets(String? selectedLang) async {
    final response = await post(Uri.parse(BASE_URL + "app/get_assets"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{"language": selectedLang}));
    final activity = getAssetsApiFromJson(response.body);
    return activity;
  }

  Future<ServicesResponse> getServices() async {
    final response = await get(Uri.parse(BASE_URL + "user/get_services"));
    final activity = getServicesApiFromJson(response.body);
    return activity;
  }

  Future<CategoriesResponse> getCategories(String service) async {
    final response = await post(Uri.parse(BASE_URL + "user/get_categories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"service": service}));
    final activity = getCategoriesApiFromJson(response.body);
    return activity;
  }

  Future<GetTypes> getTypes(String city, String category) async {
    final response = await post(Uri.parse(BASE_URL + "user/get_types"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"city": city, "category": category}));
    final activity = getTypeApiFromJson(response.body);
    return activity;
  }

  Future<GetTalentsResponse> getTalents(String service, String category) async {
    final response = await post(Uri.parse(BASE_URL + "user/get_talents"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{"service": service, "category": category}));
    final activity = getTalentsResponseApiFromJson(response.body);
    return activity;
  }

  Future<SearchTalentResponse> searchTalents(String searchText) async {
    final response = await post(Uri.parse(BASE_URL + "user/search_talents"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"term": searchText}));
    final activity = searchTalentsApiFromJson(response.body);
    return activity;
  }

  Future<SearchServiceResponse> searchServices(String searchText) async {
    final response = await post(Uri.parse(BASE_URL + "user/search_services"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"term": searchText}));
    final activity = searchServiceApiFromJson(response.body);
    return activity;
  }

  Future<VerifyUsernameResponse> verifyUsername(String username) async {
    final response = await post(Uri.parse(BASE_URL + "account/verify_username"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"term": username}));
    final activity = verifyUsernameApiFromJson(response.body);
    return activity;
  }

  Future<VerifyUsernameResponse> verifyMobile(
      String mobile, String code) async {
    final response = await post(Uri.parse(BASE_URL + "account/verify_mobile"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"term": mobile, "code": code}));
    final activity = verifyUsernameApiFromJson(response.body);
    return activity;
  }

  Future<VerifyUsernameResponse> verifyEmail(String email) async {
    final response = await post(Uri.parse(BASE_URL + "account/verify_email"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"term": email}));
    final activity = verifyUsernameApiFromJson(response.body);
    return activity;
  }

  Future<UserRegisteredResponse> registerUser(
      String username,
      String name,
      String mobile,
      String email,
      String dob,
      String gender,
      String locale,
      String code) async {
    final response = await post(Uri.parse(BASE_URL + "account/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "name": name,
          "code": code,
          "locale": locale,
          "mobile": mobile,
          "dob": dob,
          "gender": gender,
          "email": email,
        }));
    final activity = UserRegisteredResponseApiFromJson(response.body);
    return activity;
  }

  Future<TalentRegisterResponse> registerTalent(
      TalentRegisterModel talentRegisterdata) async {
    final response = await post(Uri.parse(BASE_URL + "talent/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: talentRegisterModelApiToJson(talentRegisterdata));
    final activity = TalentRegisterResponseApiFromJson(response.body);
    sp.setString(
        "userdata",
        AccountApiToJson(Account(
            accountId: user.accountId,
            countryCode: user.countryCode,
            phone: user.phone,
            locale: user.locale,
            username: user.username,
            name: user.name,
            email: user.email,
            dob: user.dob,
            gender: user.gender,
            talentId: activity.talent_id)));
    return activity;
  }

  Future<ImageUploaded> uploadTalentImage(File file, String talent_id) async {
    var request = MultipartRequest(
      'POST',
      Uri.parse(BASE_URL + "talent/profile_pic")
          .replace(queryParameters: {"talent_id": talent_id}),
    );
    Map<String, String> headers = {
      "Authorization": sp.getString("token")!,
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      MultipartFile(
        'upload',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    // request.fields.addAll({
    //   "name":"test",
    //   "email":"test@gmail.com",
    //   "id":"12345"
    // });
    print("request: " + request.toString());
    var res = await request.send();
    var response = await Response.fromStream(res);
    final activity = ImageUploadedApiFromJson(response.body);
    return activity;
  }

  Future<Success> addSocialMedia(String portfolio, String instagram,
      String facebook, String company_id) async {
    final response = await post(Uri.parse(BASE_URL + "account/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "portfolio": portfolio,
          "instagram": instagram,
          "facebook": facebook,
          "company_id": company_id,
        }));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<PaymentMethods> getPaymentMethods(String countryCode) async {
    final response =
        await post(Uri.parse(BASE_URL + "talent/get_payment_methods"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': sp.getString("token")!
            },
            body: jsonEncode(<String, String>{
              "country_code": countryCode,
            }));
    final activity = PaymentMethodsApiFromJson(response.body);
    return activity;
  }

  Future<Success> addBankAccount(
      String talentId, String countryCode, Object accDetail) async {
    final response =
        await post(Uri.parse(BASE_URL + "talent/add_bank_account_details"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': sp.getString("token")!
            },
            body: jsonEncode(accDetail));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<PostDealSuccess> postDeal(PostDealDetails postDealDetails) async {
    final response = await post(Uri.parse(BASE_URL + "deal/post"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: PostDealDetailsResponseApiToJson(postDealDetails));
    final activity = PostDealSuccessResponseApiFromJson(response.body);
    return activity;
  }

  Future<Success> addDealRequirements(
      String deal_id, List<DealRequirementModel> dealRequirements) async {
    final response = await post(Uri.parse(BASE_URL + "deal/requirements"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: PostDealSuccessDealRequirementModelApiToJson(
            PostDealSuccessDealRequirementModel(
                dealId: deal_id, requirements: dealRequirements)));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<Success> addLatLngDeal(String id, String lat, String lng) async {
    final response = await post(Uri.parse(BASE_URL + "deal/coords"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: jsonEncode(<String, String>{"id": id, "lat": lat, "lng": lng}));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<PostDealSuccess> postCollab(
      PostCollabDetails postCollabDetails) async {
    final response = await post(Uri.parse(BASE_URL + "collab/post"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: PostCollabDetailsApiToJson(postCollabDetails));
    final activity = PostDealSuccessResponseApiFromJson(response.body);
    return activity;
  }

  Future<Success> addCollabRequirements(
      String collab_id, List<DealRequirementModel> collabRequirements) async {
    final response = await post(Uri.parse(BASE_URL + "collab/requirements"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: PostCollabRequirementModelApiToJson(PostCollabRequirementModel(
            collab_id: collab_id, requirements: collabRequirements)));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<Success> addLatLngCollab(String id, String lat, String lng) async {
    final response = await post(Uri.parse(BASE_URL + "collab/coords"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': sp.getString("token")!
        },
        body: jsonEncode(<String, String>{"id": id, "lat": lat, "lng": lng}));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<Success> registerCompany(
      String token,
      String username,
      String name,
      String mobile,
      String email,
      String dob,
      String gender,
      String locale,
      String code) async {
    final response = await post(Uri.parse(BASE_URL + "company/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "legal_name": name,
          "phone_code": code,
          "phone_locale": locale,
          "phone": mobile,
          "doi": dob,
          "size": gender,
          "email": email,
        }));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<ProfileResponse> getProfile(
    String token,
  ) async {
    final response = await get(
      Uri.parse(BASE_URL + "account/profile"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );
    final activity = ProfileResponseApiFromJson(response.body);
    return activity;
  }

  Future<DashboardNumbers> getDashboardNumbers(
    String token,
  ) async {
    final response = await get(
      Uri.parse(BASE_URL + "talent/dashboard_numbers"),
      headers: <String, String>{'Authorization': token},
    );
    final activity = getDashboardNumbersApiFromJson(response.body);
    return activity;
  }

  Future<AvailableServices> getAvailableServices(
    String token,
  ) async {
    final response = await get(
      Uri.parse(BASE_URL + "app/get_services"),
      headers: <String, String>{'Authorization': token},
    );
    final activity = getAvailableServicesApiFromJson(response.body);
    return activity;
  }

  Future<AvailableCategories> getAvailableCategories(
      String token, String service) async {
    final response = await post(Uri.parse(BASE_URL + "app/get_categories"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "service": service,
        }));
    final activity = getAvailableCategoriesApiFromJson(response.body);
    return activity;
  }

  Future<UserLoginResponse> loginUser(String username) async {
    final response = await post(Uri.parse(BASE_URL + "account/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{"username": username}));
    final activity = UserLoginResponseApiFromJson(response.body);
    return activity;
  }

  Future<Success> updateUserName(String token, String name) async {
    final response = await post(Uri.parse(BASE_URL + "user/edit_name"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "name": name,
        }));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<Success> updateUserEmail(String token, String email) async {
    final response = await post(Uri.parse(BASE_URL + "user/edit_email"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "email": email,
        }));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<Success> updateUserMobile(
      String token, String code, String number, String locale) async {
    final response = await post(Uri.parse(BASE_URL + "user/edit_phone"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "code": code,
          "number": number,
          "locale": locale
        }));
    final activity = successApiFromJson(response.body);
    return activity;
  }

  Future<Updated> getVersion() async {
    final response = await get(Uri.parse(BASE_URL + "app/get_version"));
    final activity = updatedApiFromJson(response.body);
    return activity;
  }
}

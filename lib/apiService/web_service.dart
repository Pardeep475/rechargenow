import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';
import 'dart:io';

import 'package:progress_dialog/progress_dialog.dart';
// http://3.64.19.80/stations
// sarfrazmalik111@gmail.com
// MSMalik099

String BASE_URL = 'http://3.64.19.80/api/users';
String PAYMENT_BASE_URL = 'http://3.64.19.80/api/payment';
//www.rechargenow-dashboard.de
String IMAGE_BASE_URL = 'http://3.64.19.80';
//192.168.1.9

/*Future<http.Response> createLoginRequestApi(Login login) async{
  final response = await http.post('$BASE_URL/auth/login',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'XAPIKEY' : MyConstants.XAPIKEY
      },
      body: loginToJson(login)
  );
  return response;
}*/
/*http://3.125.79.59:8088/RechargeNow/api/users/
login*/
Future<http.Response> createLoginRequestApi(request) async {
  final response = await http.post('$BASE_URL/login2',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        //'XAPIKEY' : MyConstants.XAPIKEY,
        //'APPTOKEN' : apptoken
      },
      body: request);
  return response;
}

/*http://3.125.79.59:8088/RechargeNow/api/users/
verify-app-user*/
Future<http.Response> verify_app_userApi(request) async {
  final response = await http.post('$BASE_URL/verify-app-user',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: request);
  return response;
}

Future<http.Response> rentBattery_PowerbankApi(request, accessToken) async {
  final response = await http.post('$BASE_URL/rent-battery',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

Future<http.Response> getMapLocationsApi(request, accessToken) async {
  final response = await http.post('$BASE_URL/get-map-locations',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

Future<http.Response> testNotificaitonFired(accessToken) async {
  final response = await http.post('http://3.64.19.80/api/test/test-notification',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
  );
  return response;
}


Future<http.Response> getNearbyLocationsApi(request, accessToken) async {
  final response = await http.post('$BASE_URL/get-nearby-locations',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

Future<http.Response> getUserNotificationApi(
    String id, String accessToken) async {
  final response = await http.get(
    '$BASE_URL/find-user-notifications?userId=' + id,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> getUserHistoryApi(id, accessToken) async {
  final response = await http.get(
    '$BASE_URL/find-user-history?userId=' + id,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> getUserDetailsApi(id, accessToken) async {
  final response = await http.get(
    '$BASE_URL/find-user?userId=' + id,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> updateUsernameApi(request, accessToken) async {
  final response = await http.post('$BASE_URL/update-username',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

//http://www.rechargenow-dashboard.de/api/users/send-otp-to-update-phone-number

Future<http.Response> sendOtpToUpdatePhoneNumberApi(
    request, accessToken) async {
  final response = await http.post('$BASE_URL/send-otp-to-update-phone-number',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

Future<http.Response> updatePhoneNumberApi(request, accessToken) async {
  final response = await http.post('$BASE_URL/update-phone-number',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

Future<http.Response> updateEmailApi(request, accessToken) async {
  final response = await http.post('$BASE_URL/update-email',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: request);
  return response;
}

Future<http.Response> getHelpListApi(accessToken) async {
  final response = await http.get(
    '$BASE_URL/get-help-list',
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );

  print("FAQS_RESPONSE   $response");

  return response;
}

Future<http.Response> getUserMessagesApi(id, accessToken) async {
  final response = await http.get(
    '$BASE_URL/get-user-messages?userId=' + id,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> sendMessageApi(jsonReq, accessToken) async {
  final response = await http.post('$BASE_URL/send-message',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: jsonReq);
  return response;
}

Future<http.Response> uploadMessageFileApi(_image, accessToken) async {
  String apiUrl = '$BASE_URL/upload-message-file';
  final length = await _image.length();
  final request = new http.MultipartRequest('POST', Uri.parse(apiUrl))
    ..files.add(new http.MultipartFile('file', _image.openRead(), length));
  request.headers['accessToken'] = accessToken;

  http.Response response = await http.Response.fromStream(await request.send());
  print("Result: ${response.body}");
  return response;
}

Future<http.Response> resendOtpApi(jsonReq) async {
  final response = await http.post('$BASE_URL/resend-otp',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        // 'accessToken' :accessToken,
      },
      body: jsonReq);
  return response;
}

Future<http.Response> addCreditCardApi(userid, jsonReq, accessToken) async {
  final response =
      await http.post('$PAYMENT_BASE_URL/add-credit-card/' + userid,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'accessToken': accessToken,
          },
          body: jsonReq);
  return response;
}

Future<http.Response> getCreditCardListApi(userid, accessToken) async {
  final response = await http.get(
    '$PAYMENT_BASE_URL/get-credit-cards?userId=' + userid,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> deleteCreditCardApi(cardId, accessToken) async {
  final response = await http.get(
    '$PAYMENT_BASE_URL/delete-credit-card?cardId=' + cardId,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> getPromoCodeApi(userId, accessToken) async {
  final response = await http.get(
    '$PAYMENT_BASE_URL/get-promo-codes?userId=' + userId,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> redeemPromoCodeApi(jsonReq, accessToken) async {
  final response = await http.post('$PAYMENT_BASE_URL/redeem-promo-code',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'accessToken': accessToken,
      },
      body: jsonReq);
  return response;
}

Future<http.Response> getCurrentRentalDetailsApi(userId, accessToken) async {
  final response = await http.get(
    '$BASE_URL/get-current-rental-details?userId=' + userId,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> getCreateBillingAgreementApi(userId, accessToken) async {
  final response = await http.get(
    '$PAYMENT_BASE_URL/create-billing-agreement?userId=' + userId,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

//http://www.rechargenow-dashboard.de/api/users/logout?userId=1
Future<http.Response> getLogouttApi(userId, accessToken) async {
  final response = await http.get(
    '$BASE_URL/logout?userId=' + userId,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

Future<http.Response> sendAlarm(userId, accessToken) async {
  final response = await http.get(
    '$BASE_URL/send-battery-alarm?userId=' + userId,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'accessToken': accessToken,
    },
  );
  return response;
}

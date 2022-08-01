import 'dart:convert';
import 'dart:developer';

import 'package:book_my_show_clone/services/apiService/api_urls.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class BaseApi {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Uri url({required String extendedURL}) {
    return Uri.http(ApiUrl.baseUrl, extendedURL);
  }

  static Uri url1({required String extendedURL}) {
    log("http://${ApiUrl.baseUrl}$extendedURL");
    return Uri.parse("http://${ApiUrl.baseUrl}$extendedURL");
  }

  static Future getRequest({required String extendedURL}) async {
    var client = http.Client();

    return client.get(url(extendedURL: extendedURL), headers: headers);
  }

  static Future getRequest1({required String extendedURL}) async {
    var client = http.Client();

    return client.get(url1(extendedURL: extendedURL), headers: headers);
  }

  static Future postRequest({
    required String extendedURL,
    required Object body,
    required bool withToken,
  }) async {
    Map<String, String>? headers;

    if (withToken) {
      headers = headers;
    } else {
      headers = headers;
    }

    var client = http.Client();
    return client.post(url(extendedURL: extendedURL),
        headers: headers, body: jsonEncode(body));
  }
}

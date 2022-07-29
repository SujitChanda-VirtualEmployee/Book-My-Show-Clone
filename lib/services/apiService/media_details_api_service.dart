import 'dart:developer';
import 'package:book_my_show_clone/services/apiService/api_urls.dart';
import 'package:book_my_show_clone/services/apiService/base_api.dart';

class MediaDetailsApiService {
  static Future mediaDetailsApiService(String id) async {
    var response = await BaseApi.getRequest1(extendedURL: ApiUrl.detals + id);
    if (response.statusCode != 200) {
      log(response.statusCode.toString());
    }
    return response;
  }
}

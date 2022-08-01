

import 'package:book_my_show_clone/services/apiService/api_urls.dart';
import 'package:book_my_show_clone/services/apiService/base_api.dart';

class BannerListApiService {
  static Future bannerListApiService() async {
    var response =
        await BaseApi.getRequest1(extendedURL: ApiUrl.bannerList);
    if (response.statusCode != 200) {
      //log(response.statusCode.toString());
    }
    return response;
  }
}

import 'dart:developer';
import 'package:book_my_show_clone/services/apiService/api_urls.dart';
import 'package:book_my_show_clone/services/apiService/base_api.dart';

class MovieListApiService {
  static Future moviesListApiService() async {
    var response =
        await BaseApi.getRequest1(extendedURL: ApiUrl.movieList);
    if (response.statusCode != 200) {
      log(response.statusCode.toString());
    }
    return response;
  }
    static Future relatedMoviesListApiService() async {
    var response =
        await BaseApi.getRequest1(extendedURL: ApiUrl.relatedMovieList);
    if (response.statusCode != 200) {
      log(response.statusCode.toString());
    }
    return response;
  }
}

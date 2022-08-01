
import 'package:book_my_show_clone/models/banner_list_model.dart';
import 'package:book_my_show_clone/models/movie_details_model.dart';
import 'package:book_my_show_clone/models/movie_list_model.dart';
import 'package:book_my_show_clone/models/series_list_model.dart';
import 'package:book_my_show_clone/services/apiService/bannerList_api_service.dart';
import 'package:book_my_show_clone/services/apiService/media_details_api_service.dart';
import 'package:book_my_show_clone/services/apiService/movieList_api_service.dart';
import 'package:flutter/material.dart';

import '../apiService/seriesList_api_service.dart';

class ApiDataProvider with ChangeNotifier {
  MovieListModel? movieListData;
  SeriesListModel? seriesListData;
  MovieListModel? relatedMovieListData;
  SeriesListModel? relatedSeriesListData;
  BannerListSlider? bannerListData;
  MovieDetailsModel? movieDetailsData;

  ApiDataProvider() {
    getMoviesList();
    getSeriesList();
    getBannerList();
  }

  getMoviesList() {
    MovieListApiService.moviesListApiService().then((value) {
      movieListData = movieListModelFromJson(value.body);
      notifyListeners();
    });
  }

  getSeriesList() {
    SeriesListApiService.seriesListApiService().then((value) {
      seriesListData = seriesListModelFromJson(value.body);
      notifyListeners();
    });
  }

  getRelatedMoviesList() {
    MovieListApiService.relatedMoviesListApiService().then((value) {
      relatedMovieListData = movieListModelFromJson(value.body);
      notifyListeners();
    });
  }

  getRelatedSeriesList() {
    SeriesListApiService.relatedSeriesListApiService().then((value) {
      relatedSeriesListData = seriesListModelFromJson(value.body);
      notifyListeners();
    });
  }

  getBannerList() {
    BannerListApiService.bannerListApiService().then((value) {
      bannerListData = bannerListSliderFromJson(value.body);
      notifyListeners();
    });
  }

  getMediaDetails(String id) {
    MediaDetailsApiService.mediaDetailsApiService(id).then((value) {
      movieDetailsData = movieDetailsModelFromJson(value.body);
      notifyListeners();
    });
  }

  clearDetailsScreenProvider() {
    movieDetailsData = null;
    relatedMovieListData = null;  
    relatedSeriesListData = null;
    notifyListeners();
  }
}

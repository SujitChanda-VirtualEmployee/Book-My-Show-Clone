import 'dart:convert';

MovieListModel movieListModelFromJson(String str) => MovieListModel.fromJson(json.decode(str));

String movieListModelToJson(MovieListModel data) => json.encode(data.toJson());

class MovieListModel {
  List<Search>? search;
  String? totalResults;
  String? response;

  MovieListModel({this.search, this.totalResults, this.response});

  MovieListModel.fromJson(Map<String, dynamic> json) {
    if (json['Search'] != null) {
      search = <Search>[];
      json['Search'].forEach((v) {
        search!.add( Search.fromJson(v));
      });
    }
    totalResults = json['totalResults'];
    response = json['Response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    if (search != null) {
      data['Search'] = search!.map((v) => v.toJson()).toList();
    }
    data['totalResults'] = totalResults;
    data['Response'] = response;
    return data;
  }
}

class Search {
  String? title;
  String? year;
  String? imdbID;
  String? type;
  String? poster;

  Search({this.title, this.year, this.imdbID, this.type, this.poster});

  Search.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    year = json['Year'];
    imdbID = json['imdbID'];
    type = json['Type'];
    poster = json['Poster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Title'] = title;
    data['Year'] = year;
    data['imdbID'] = imdbID;
    data['Type'] = type;
    data['Poster'] = poster;
    return data;
  }
}


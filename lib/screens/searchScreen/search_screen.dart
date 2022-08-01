import 'dart:async';
import 'dart:developer';
import 'package:book_my_show_clone/models/movie_list_model.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:book_my_show_clone/utils/enum_classes.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../../services/apiService/api_urls.dart';
import '../../services/providerService/api_data_provider.dart';
import '../../utils/asset_images_strings.dart';
import '../mediaDetailsScreen/media_details_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String id = "search-screen";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  StreamController? _streamController;
  Stream? _stream;
  Timer? _debounce;
  _search() async {
    if (controller.text == null || controller.text.isEmpty) {
      _streamController!.add(null);
      _initList();
      return;
    }
    String uri = "http://${ApiUrl.baseUrl}${ApiUrl.search}${controller.text}";
    Response response = await get(Uri.parse(uri));
    if (response.statusCode == 200) {
      _streamController!.add(response.body);
    } else {
      if (kDebugMode) {
        print("bad request");
      }
    }
  }

  _initList() async {
    String uri = "http://${ApiUrl.baseUrl}${ApiUrl.search}new";
    Response response = await get(Uri.parse(uri));
    if (response.statusCode == 200) {
      log(response.body.toString());
      _streamController!.add(response.body);
    } else {
      if (kDebugMode) {
        print("bad request");
      }
    }
  }

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController!.stream;
    _initList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Search ",
          style: TextStyle(color: Colors.white, letterSpacing: 1),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.white,
            )),
        elevation: 0,
        flexibleSpace: Container(color: ColorPalette.secondary),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Column(
              children: [searchBox(), const SizedBox(height: 5)],
            )),
      ),
      body: body(),
    );
  }

  Widget searchBox() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      height: 50,
      width: SizeConfig.fullWidth,
      child: TextFormField(
        controller: controller,
        onChanged: (val) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(microseconds: 500), () {
            _search();
          });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: ColorPalette.dark),
          hintText: "Search Movies, Series...",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          fillColor: ColorPalette.background,
          filled: true,
          isDense: true,
        ),
      ),
    );
  }

  Widget body() {
    return SizedBox(
        height: SizeConfig.fullHeight,
        width: SizeConfig.fullWidth,
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                MovieListModel model = movieListModelFromJson(snapshot.data);
                if (model.search == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetImageClass.appLogo,
                          color: ColorPalette.dark,
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text("No Movies / Series to Show!",
                            style: CustomStyleClass.onboardingBodyTextStyle
                                .copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {
                          Navigator.pushNamed(context, MediaDetailsScreen.id,
                              arguments: [
                                model.search![index].title,
                                model.search![index].imdbID,
                                model.search![index].type == "movie"
                                    ? MediaType.movies
                                    : MediaType.series,
                              ]).then((value) {
                            Provider.of<ApiDataProvider>(context, listen: false)
                                .clearDetailsScreenProvider();
                          });
                        },
                        child: SizedBox(
                          height: SizeConfig.heightMultiplier * 100,
                          width: SizeConfig.fullWidth,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                ),
                                height: SizeConfig.heightMultiplier * 100,
                                width: SizeConfig.heightMultiplier * 90,
                                child: CachedNetworkImage(
                                  imageUrl: model.search![index].poster!,
                                  width: MediaQuery.of(context).size.width,
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => Center(
                                    child: Image.asset(
                                      AssetImageClass.appLogo,
                                      color: ColorPalette.dark,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Image.asset(
                                      AssetImageClass.appLogo,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      model.search![index].title.toString(),
                                      maxLines: 1,
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                              color: ColorPalette.secondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2),
                                    ),
                                    const Expanded(
                                      child: SizedBox(
                                        height: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: ColorPalette.primary
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Text(
                                              model.search![index].type
                                                  .toString()
                                                  .toUpperCase(),
                                              style: CustomStyleClass
                                                  .onboardingBodyTextStyle
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.5),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: ColorPalette.secondary
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Text(
                                              model.search![index].year
                                                  .toString()
                                                  .toUpperCase(),
                                              style: CustomStyleClass
                                                  .onboardingBodyTextStyle
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.5),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: ColorPalette.secondary
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Text(
                                              model.search![index].imdbID
                                                  .toString()
                                                  .toUpperCase(),
                                              style: CustomStyleClass
                                                  .onboardingBodyTextStyle
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.5),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: model.search!.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No Movies / Series to Show!"),
                );
              }
            } else if (snapshot.data == null) {
              return const Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  color: ColorPalette.secondary,
                ),
              );
            }
            return const Center(
              child: Text("Waiting ..."),
            );
          },
        ));
  }
}

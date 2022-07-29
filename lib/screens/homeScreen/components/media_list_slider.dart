import 'package:book_my_show_clone/screens/mediaDetailsScreen/media_details_screen.dart';
import 'package:book_my_show_clone/services/providerService/api_data_provider.dart';
import 'package:book_my_show_clone/utils/asset_images_strings.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../utils/enum_classes.dart';
import '../../../utils/size_config.dart';

class MediaListSlider extends StatefulWidget {
  final String title;
  final MediaType mediaType;

  const MediaListSlider(
      {Key? key, required this.title, required this.mediaType})
      : super(key: key);

  @override
  State<MediaListSlider> createState() => _MediaListSliderState();
}

class _MediaListSliderState extends State<MediaListSlider> {
  @override
  void initState() {
    if (widget.mediaType == MediaType.relaredMovies) {
      var dataProvider = Provider.of<ApiDataProvider>(context, listen: false);
      dataProvider.getRelatedMoviesList();
    } else if (widget.mediaType == MediaType.relatedSeries) {
      var dataProvider = Provider.of<ApiDataProvider>(context, listen: false);
      dataProvider.getRelatedSeriesList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: SizeConfig.fullWidth,
        height: SizeConfig.fullHeight / 3.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Row(
                  children: [
                    Text(
                      "See All ",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.textMultiplier * 1.5),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorPalette.primary,
                      size: 10,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Consumer<ApiDataProvider>(
                  builder: (context, apiDataProvider, child) {
                var mediaProvider;
                if (widget.mediaType == MediaType.movies) {
                  mediaProvider = apiDataProvider.movieListData;
                } else if (widget.mediaType == MediaType.series) {
                  mediaProvider = apiDataProvider.seriesListData;
                } else if (widget.mediaType == MediaType.relaredMovies) {
                  mediaProvider = apiDataProvider.relatedMovieListData;
                } else if (widget.mediaType == MediaType.relatedSeries) {
                  mediaProvider = apiDataProvider.relatedSeriesListData;
                }
                return mediaProvider == null
                    ? Container()
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: mediaProvider.search!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      color: ColorPalette.secondary,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              color: Colors.grey.shade100,
                                              height:
                                                  SizeConfig.heightMultiplier *
                                                      160,
                                              width:
                                                  SizeConfig.heightMultiplier *
                                                      160,
                                              child: ClipRRect(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(0)),
                                                child: CachedNetworkImage(
                                                  imageUrl: mediaProvider
                                                      .search![index].poster!,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: double.infinity,
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child: Image.asset(
                                                      AssetImageClass.appLogo,
                                                      color: ColorPalette.dark,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: Image.asset(
                                                      AssetImageClass.appLogo,
                                                      width: 50,
                                                      height: 50,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Year : ${mediaProvider!.search![index].year}",
                                            style: CustomStyleClass
                                                .onboardingBodyTextStyle
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig
                                                            .textMultiplier *
                                                        1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: SizeConfig.heightMultiplier * 160,
                                      height: SizeConfig.heightMultiplier * 40,
                                      child: Text(
                                        "${mediaProvider!.search![index].title}",
                                        maxLines: 2,
                                        style: CustomStyleClass
                                            .onboardingBodyTextStyle
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.6),
                                      )),
                                ],
                              ),
                              Positioned.fill(
                                  child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {
                                  if (widget.mediaType == MediaType.movies ||
                                      widget.mediaType == MediaType.series) {
                                    pushNewScreenWithRouteSettings(context,
                                            screen: MediaDetailsScreen(
                                              title: mediaProvider!
                                                  .search![index].title,
                                              mediaId: mediaProvider!
                                                  .search![index].imdbID,
                                              mediaType: widget.mediaType,
                                            ),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation
                                                    .cupertino,
                                            settings: const RouteSettings(
                                                name: MediaDetailsScreen.id))
                                        .then((value) {
                                      Provider.of<ApiDataProvider>(context,
                                              listen: false)
                                          .clearDetailsScreenProvider();
                                    });
                                  } else {
                                    Navigator.pushReplacementNamed(
                                        context, MediaDetailsScreen.id,
                                        arguments: [
                                          mediaProvider!.search![index].title,
                                          mediaProvider!.search![index].imdbID,
                                          widget.mediaType,
                                        ]);
                                  }

                                  // Navigator.pushNamed(
                                  //     context, MediaDetailsScreen.id);
                                },
                              ))
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

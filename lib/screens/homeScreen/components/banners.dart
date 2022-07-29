import 'package:book_my_show_clone/utils/asset_images_strings.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/providerService/api_data_provider.dart';

class Sliders extends StatefulWidget {
  const Sliders({Key? key}) : super(key: key);

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApiDataProvider>(
        builder: (context, apiDataProvider, child) {
      return apiDataProvider.bannerListData == null
          ? Container()
          : CarouselSlider.builder(
              itemCount: apiDataProvider.bannerListData!.search!.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Container(
                clipBehavior: Clip.antiAlias,
                margin:
                    const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorPalette.dark.withOpacity(0.2)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: apiDataProvider
                          .bannerListData!.search![itemIndex].poster!,
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      fit: BoxFit.cover,
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
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: DotsIndicator(
                        dotsCount:
                            apiDataProvider.bannerListData!.search!.length,
                        position: itemIndex.toDouble(),
                        decorator: DotsDecorator(
                            color: Colors.white,
                            size: const Size.square(3.0),
                            activeSize: const Size(40.0, 3.0),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: ColorPalette.secondary, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0)),
                            activeShape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: ColorPalette.secondary, width: 0.5),
                                borderRadius: BorderRadius.circular(5.0)),
                            activeColor: ColorPalette.white),
                      ),
                    )
                  ],
                ),
              ),
              options: CarouselOptions(
                //  height: SizeConfig.fullHeight / 6,
                aspectRatio: 1 / 0.50,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
              ),
            );
    });
  }
}

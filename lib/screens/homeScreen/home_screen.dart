import 'package:book_my_show_clone/screens/homeScreen/components/banners.dart';
import 'package:book_my_show_clone/screens/homeScreen/components/media_list_slider.dart';
import 'package:book_my_show_clone/screens/searchScreen/search_screen.dart';
import 'package:book_my_show_clone/services/providerService/location_provider.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:book_my_show_clone/utils/enum_classes.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.secondary,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: SizedBox(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "It All Started Here",
                style: CustomStyleClass.onboardingBodyTextStyle
                    .copyWith(color: Colors.white),
              ),
              Expanded(
                child: Consumer<LocationProvider>(
                    builder: (context, locProvider, child) {
                  return Row(
                    children: [
                      Text(
                        "${locProvider.pickUpLocation.locality}, ${locProvider.pickUpLocation.city} ",
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: Colors.grey.withOpacity(0.6),
                                letterSpacing: 0.6,
                                fontSize: SizeConfig.textMultiplier * 1.5),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey.withOpacity(0.6),
                        size: 10,
                      )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                pushNewScreenWithRouteSettings(context,
                    screen: const SearchScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    settings: const RouteSettings(name: SearchScreen.id));
              },
              icon: const Icon(
                CupertinoIcons.search,
                color: ColorPalette.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.bell,
                color: ColorPalette.white,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.qrcode_viewfinder,
                color: ColorPalette.white,
              ))
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.heightMultiplier * 10),
          const Sliders(),
          SizedBox(height: SizeConfig.heightMultiplier * 20),
          const MediaListSlider(
            title: 'Recommended Movies',
            mediaType: MediaType.movies,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 20),
          const MediaListSlider(
            title: 'Popular Series',
            mediaType: MediaType.series,
          )
        ],
      ),
    );
  }
}

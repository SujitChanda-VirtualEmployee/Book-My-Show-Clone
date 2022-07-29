import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/asset_images_strings.dart';
import '../utils/size_config.dart';

class OnBaordScreen extends StatefulWidget {
  @override
  _OnBaordScreenState createState() => _OnBaordScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(
          child: SizedBox(
              width: SizeConfig.fullWidth * 0.8,
              child: Image.asset(
                AssetImageClass.splashAppLogo,
              ))),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text.rich(
          TextSpan(
              text: 'Made with ',
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary),
              children: <InlineSpan>[
                TextSpan(
                  text: 'Flutter',
                  style: CustomStyleClass.onboardingBodyTextStyle
                      .copyWith(color: ColorPalette.white),
                  recognizer: TapGestureRecognizer()..onTap = () => Container(),
                )
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  ),
  Column(
    children: [
      Expanded(
          child: SizedBox(
              width: SizeConfig.fullWidth,
              child: Image.asset(
                AssetImageClass.splashAppLogo,
              ))),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text.rich(
          TextSpan(
              text: 'Backend  ',
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary),
              children: <InlineSpan>[
                TextSpan(
                  text: 'Firebase',
                  style: CustomStyleClass.onboardingBodyTextStyle
                      .copyWith(color: ColorPalette.white),
                  recognizer: TapGestureRecognizer()..onTap = () => Container(),
                )
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  ),
  Column(
    children: [
      Expanded(
          child: SizedBox(
              width: SizeConfig.fullWidth,
              child: Image.asset(
                AssetImageClass.splashAppLogo,
              ))),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text.rich(
          TextSpan(
              text: 'Movies API  ',
              style: CustomStyleClass.onboardingBodyTextStyle
                  .copyWith(color: ColorPalette.secondary),
              children: <InlineSpan>[
                TextSpan(
                  text: 'OMDB',
                  style: CustomStyleClass.onboardingBodyTextStyle
                      .copyWith(color: ColorPalette.white),
                  recognizer: TapGestureRecognizer()..onTap = () => Container(),
                )
              ]),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  ),
];

class _OnBaordScreenState extends State<OnBaordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorPalette.primary,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
                color: Colors.white,
                size: const Size.square(9.0),
                activeSize: const Size(22.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                activeColor: ColorPalette.secondary),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

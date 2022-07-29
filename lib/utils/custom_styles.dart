import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:flutter/material.dart';


class CustomStyleClass {
  static final TextStyle onboardingHeadingStyle = TextStyle(
      color: ColorPalette.primary,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
      fontSize: SizeConfig.textMultiplier * 4);

  static final TextStyle onboardingBodyTextStyle = TextStyle(
      
      color: ColorPalette.dark,
      fontSize: SizeConfig.textMultiplier * 2.3);

  static final TextStyle onboardingSkipButtonStyle = TextStyle(
      color: ColorPalette.secondary,
      fontSize: SizeConfig.textMultiplier * 2.3,
      fontWeight: FontWeight.bold);
}

import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.fullHeight,
      width: SizeConfig.fullWidth,
      color: ColorPalette.secondary.withOpacity(0.2),
      child: SizedBox(
        height: SizeConfig.heightMultiplier * 60,
        width: SizeConfig.fullWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SafeArea(
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  tileColor: Colors.red,
                  leading: const Icon(
                      Icons
                          .signal_wifi_statusbar_connected_no_internet_4_rounded,
                      color: ColorPalette.white),
                  title: Text("No Internet!",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.white,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text("Please Check your Internet connection",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: ColorPalette.white,
                        letterSpacing: 0.3,
                        fontSize: SizeConfig.textMultiplier * 1.5,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

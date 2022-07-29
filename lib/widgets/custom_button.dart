import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:flutter/material.dart';

Widget customButton({
  required BuildContext context,
  required Function() onPressed,
  required String title,
  Color btnColor = ColorPalette.primary,
  double letterSpacing = 4,
  double buttonRadius = 8,
  double leftPadding = 15,
  double rightPadding = 15,
  IconData? icon,
}) {
  return Padding(
    padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
    child: SizedBox(
      height: 45,

      // width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          enableFeedback: true,
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(

              // side: BorderSide(color: bgColor, width: 0.0),
              borderRadius: BorderRadius.circular(buttonRadius)),
          elevation: 1,
          primary: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(buttonRadius),
            ),
            border: Border.all(color: Colors.black, width: 0.3),
            // image: DecorationImage(
            //     image: AssetImage("assets/buttonSkin.png"),
            //     fit: BoxFit.cover)
          ),
          child: Container(
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.all(
                Radius.circular(buttonRadius),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 10),
                Text(title,
                    style:
                        shadowbodyText1(context, size: 18, letterSpacing: 4)),
                if (icon != null) Container(width: 10),
                if (icon != null)
                  Icon(
                    icon,
                    size: 25,
                    color: Colors.white,
                  ),
                Container(width: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

TextStyle shadowbodyText1(
  context, {
  double? size,
  double? letterSpacing,
  Color? textColor,
  Color? shadowColor,
  String? fontFamity,
}) {
  return Theme.of(context).textTheme.bodyText1!.copyWith(
      fontSize: size,
      letterSpacing: letterSpacing ?? 0.8,
      fontFamily: fontFamity,
      shadows: [
        BoxShadow(
            color: shadowColor ?? Colors.black,
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0.7, 0.7))
      ],
      color: textColor ?? Colors.white,
      fontWeight: FontWeight.bold);
}

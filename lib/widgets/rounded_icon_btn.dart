import 'package:flutter/material.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key ?key,
    required this.icon,
    required this.press,
    this.radius = 17.5,
    required this.bgColor,
    this.iconSize = 20,
    this.iconColor = Colors.black,
    this.showShadow = false,
    this.border = true,
    this.borderColor = Colors.black,
    this.borderWidth = 0.2,
  }) : super(key: key);

  final IconData icon;
  final GestureTapCancelCallback press;
  final bool showShadow;
  final Color bgColor;
  final Color iconColor;
  final double iconSize;
  final double radius;
  final bool border;
  final Color borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          showShadow
              ? BoxShadow(
                  offset: Offset(0.0,0.0),
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: Colors.grey.withOpacity(0.5),
                )
              : BoxShadow(color: Colors.transparent)
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          primary: bgColor,
          shape: RoundedRectangleBorder(
              side: border
                  ? BorderSide(color: borderColor, width: borderWidth)
                  : BorderSide(color: bgColor, width: 0.0),
              borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: press,
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}

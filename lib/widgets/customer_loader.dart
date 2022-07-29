import 'dart:ui';

import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget glassLoading() {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
              BoxDecoration(color: ColorPalette.primary.withOpacity(0.2)),
          child: Center(
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      //color: Colors.blue.withOpacity(0.3),
                      color: ColorPalette.primary.withOpacity(0.5),
                      blurRadius: 3,
                      spreadRadius: 2,
                      offset: const Offset(0.7, 0.7),
                    )
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: Colors.black87),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const[
                  SpinKitCircle(
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 10),
                  Text("Please wait...", style: TextStyle(color: Colors.white)),
                ],
              ),
              //  CupertinoActivityIndicator(
              //   animating: true,
              //   radius: 20,

              //   // valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              //   // strokeWidth: 2,
              // ),
            ),
          )),
    ),
  );
}
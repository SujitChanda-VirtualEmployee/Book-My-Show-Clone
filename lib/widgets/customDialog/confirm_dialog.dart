import 'package:flutter/material.dart';
import 'dialog_content.dart';

class ConfirmDialog {
  static showCustomDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return const DialogContent();
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 0.8), end: const Offset(0, 0))
              .animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    ).whenComplete(() {
      // Navigator.of(context).pop();
    });
  }
}

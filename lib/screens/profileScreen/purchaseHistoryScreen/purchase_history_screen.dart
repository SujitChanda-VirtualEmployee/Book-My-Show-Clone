import 'dart:convert';
import 'dart:developer';

import 'package:book_my_show_clone/screens/EmptyScreen/empty_screen.dart';
import 'package:book_my_show_clone/services/firebaseServices/firebase_services.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/purchase_history_model.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/size_config.dart';
import 'components/purchase_history_tile.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  static const String id = "PurchaseHistory-screen";
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  FirebaseServices firebaseServices = FirebaseServices();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.secondary,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.white,
            )),
        centerTitle: true,
        title: Text(
          "Purchase History",
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.white,
              fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return FutureBuilder(
      future: firebaseServices.booking
          .where("customerID", isEqualTo: firebaseAuth.currentUser!.uid)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const EmptyScreen();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
                animating: true, color: ColorPalette.secondary),
          );
        }
        if (snapshot.data!.size == 0) {
          return const EmptyScreen();
        }
        log(snapshot.data!.size.toString());

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: snapshot.data!.size,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return PurchaseHistoryTile(
                model: purchaseHistoryModelFromJson(
                    jsonEncode(snapshot.data!.docs[index].data())));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: SizeConfig.heightMultiplier * 20,
            );
          },
        );
      },
    );
  }
}

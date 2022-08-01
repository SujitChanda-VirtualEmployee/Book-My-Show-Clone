import 'dart:convert';
import 'dart:developer';

import 'package:book_my_show_clone/services/providerService/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;

  Future makePayment({
    required String amount,
    required String currency,
    required AuthProvider dataProvider,
  }) async {
    try {
      dataProvider.paymentSuccess = false;
      EasyLoading.show(status: "Loading...");
      paymentIntentData = await createPaymentIntent(
        amount,
        currency,
      );
      EasyLoading.dismiss();
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
                customerId: null,
                merchantDisplayName: "Book My Show"));
        await displayPaymentSheet(dataProvider);
      }
    } catch (e, s) {
      if (kDebugMode) {
        print("Exception: $e: $s");
      }
    }
  }

  displayPaymentSheet(AuthProvider dataProvider) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      dataProvider.paymentSuccess = true;
      Get.snackbar(
        "Success",
        "Payment Successful",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        dataProvider.paymentSuccess = false;
        if (kDebugMode) {
          print("Error From Stripe: ${e.error.localizedMessage}");
        }
        Get.snackbar(
          "Payment Failed",
          "${e.error.localizedMessage}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 4),
        );
      } else {
        dataProvider.paymentSuccess = false;
        if (kDebugMode) {
          print(" Unseen Error From Stripe: $e");
        }
        Get.snackbar(
          "Payment Failed",
          "$e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      dataProvider.paymentSuccess = false;
      if (kDebugMode) {
        print(" Unseen Error From Stripe: $e");
      }
      Get.snackbar(
        "Payment Failed",
        "$e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 4),
      );
    }
  }

  createPaymentIntent(String aounnt, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': aounnt,
        'currency': currency,
        'payment_method_types[]': "card",
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_tR3PYbcVNZZ796tH88S4VQ2u',
            'Content-Type': 'application/x-www-form-urlencoded',
          });
      log(response.body);
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('Err charging user : ${err.toString()}');
      }
    }
  }

  calculateAmount(String aounnt) {
    final a = (double.parse(aounnt)) * 100;
    return a.toStringAsFixed(0);
  }
}

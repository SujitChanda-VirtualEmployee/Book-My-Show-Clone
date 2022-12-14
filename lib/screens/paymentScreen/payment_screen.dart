import 'dart:developer';

import 'package:book_my_show_clone/main.dart';
import 'package:book_my_show_clone/screens/paymentScreen/payment_success.dart';
import 'package:book_my_show_clone/services/firebaseServices/firebase_services.dart';
import 'package:book_my_show_clone/services/providerService/auth_provider.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/hall_details_model.dart';
import '../../models/movie_details_model.dart';
import '../../services/paymentServices/payment_controller.dart';
import '../../services/providerService/location_provider.dart';
import '../../utils/asset_images_strings.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_styles.dart';
import '../../utils/dashed_line.dart';
import '../ticketBookingScreen/ticket_booking_screen.dart';

class PaymentScreen extends StatefulWidget {
  static const String id = 'payment-screen';
  final MovieDetailsModel movieDetailsData;
  final CinemaHallClass theatreDetailsData;
  final DateTime selectedDate;
  final String selectedTime;
  final List<ChairList> chairList;
  const PaymentScreen({
    Key? key,
    required this.movieDetailsData,
    required this.theatreDetailsData,
    required this.selectedDate,
    required this.selectedTime,
    required this.chairList,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController pickupLoc = TextEditingController();
  TextEditingController dropLoc = TextEditingController();
  TextEditingController notes = TextEditingController();
  double subtotalAmount = 0;
  double totalPayable = 0;
  double baseAmount = 0;
  double gst = 0;
  double convenienceFees = 0;
  int bookASmileFees = 0;
  FirebaseServices firebaseServices = FirebaseServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String tickets = "";
  @override
  void initState() {
    calculateAmount();
    super.initState();
  }

  calculateAmount() {
    for (int i = 0; i < widget.chairList.length; i++) {
      subtotalAmount = subtotalAmount + widget.chairList[i].price;

      tickets = "$tickets | ${widget.chairList[i].id}";
    }
    gst = (18 / 100) * subtotalAmount;
    baseAmount = (10 / 100) * subtotalAmount;
    bookASmileFees = widget.chairList.length;
    convenienceFees = gst + baseAmount;
    totalPayable = convenienceFees + subtotalAmount + bookASmileFees;
    log(tickets.substring(2));
  }

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.put(PaymentController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorPalette.background,
      bottomSheet: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: const Offset(0, -2),
                color: ColorPalette.secondary.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 0),
          ]),
          height: 60,
          width: SizeConfig.fullWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child:
                Consumer<AuthProvider>(builder: (context, dataProvider, child) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ColorPalette.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    paymentController
                        .makePayment(
                            amount: paymentController.calculateAmount(
                                totalPayable.toStringAsFixed(2)),
                            currency: "INR",
                            dataProvider: dataProvider)
                        .whenComplete(() async {
                      if (dataProvider.paymentSuccess == true) {
                        EasyLoading.show(status: "Processing Order");
                        String bookingID =
                            await firebaseServices.getAndSetCurrentBookingID();
                        log(bookingID);
                        firebaseServices.createNewBookingData({
                          'bookingID': bookingID,
                          'customerID': _firebaseAuth.currentUser!.uid,
                          'moviveName': widget.movieDetailsData.title,
                          'moviePoster': widget.movieDetailsData.poster,
                          'movieRating': widget.movieDetailsData.imdbRating,
                          'movieDate':
                              DateFormat.yMMMEd().format(widget.selectedDate),
                          "movieTime": widget.selectedTime,
                          "movieTheaterName":
                              widget.theatreDetailsData.hallName,
                          "movieTheaterAddress":
                              widget.theatreDetailsData.address,
                          "movieTheaterLat": widget.theatreDetailsData.lat,
                          "movieTheaterLng": widget.theatreDetailsData.lng,
                          "numberOfTickets": widget.chairList.length,
                          "tickets": tickets.substring(2),
                          "subtotalAmount":
                              "??? ${subtotalAmount.toStringAsFixed(2)}",
                          "conveniemcefees":
                              "??? ${convenienceFees.toStringAsFixed(2)}",
                          "baseAmount": "??? ${baseAmount.toStringAsFixed(2)}",
                          "gst": "??? ${gst.toStringAsFixed(2)}",
                          "contributionToBookASmile":
                              "??? ${bookASmileFees.toStringAsFixed(2)}",
                          "totalPayable":
                              "??? ${totalPayable.toStringAsFixed(2)}",
                        }).whenComplete(() {
                          EasyLoading.dismiss();

                          Navigator.pushNamed(context, PaymentSuccessScreen.id,
                              arguments: [
                                widget.movieDetailsData,
                                widget.theatreDetailsData,
                                widget.selectedDate,
                                widget.selectedTime,
                                widget.chairList,
                                bookingID,
                              ]);
                        });
                      }
                    });
                  },
                  child: Text(
                    "Pay ??? ${totalPayable.toStringAsFixed(2)}",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 2,
                    ),
                  ));
            }),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.background,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorPalette.secondary,
            )),
        centerTitle: false,
        title: Text(
          "Almost there!",
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.secondary,
              fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      color: ColorPalette.background,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          decoration: BoxDecoration(
              color: ColorPalette.white,
              borderRadius: BorderRadius.circular(0)),
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              Positioned(
                top: SizeConfig.fullHeight / 6,
                bottom: SizeConfig.fullHeight / 6,
                left: SizeConfig.fullWidth / 6,
                right: SizeConfig.fullWidth / 6,
                child: Image.asset(
                  AssetImageClass.appLogo,
                  height: SizeConfig.imageSizeMultiplier * 30,
                  width: SizeConfig.imageSizeMultiplier * 30,
                  color: Colors.grey.shade200,
                ),
              ),
              Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 20,
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 150,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(children: [
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 150,
                            width: SizeConfig.heightMultiplier * 95,
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(2)),
                              child: CachedNetworkImage(
                                imageUrl: widget.movieDetailsData.poster!,
                                width: MediaQuery.of(context).size.width,
                                height: double.infinity,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => Center(
                                  child: Image.asset(
                                    AssetImageClass.appLogo,
                                    color: ColorPalette.dark,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Image.asset(
                                    AssetImageClass.appLogo,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.movieDetailsData.title!,
                                    maxLines: 2,
                                    style: CustomStyleClass
                                        .onboardingBodyTextStyle
                                        .copyWith(
                                      fontSize: SizeConfig.textMultiplier * 2,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette.secondary,
                                    )),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      color: ColorPalette.primary,
                                      size: 15,
                                    ),
                                    Text(
                                      " ${(double.parse(widget.movieDetailsData.imdbRating!) * 10).toStringAsFixed(0)}%    ",
                                      style: CustomStyleClass
                                          .onboardingBodyTextStyle
                                          .copyWith(
                                        color: Colors.black,
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                    "${DateFormat.yMMMEd().format(widget.selectedDate)} | ${widget.selectedTime}",
                                    style: CustomStyleClass
                                        .onboardingBodyTextStyle
                                        .copyWith(
                                            color: ColorPalette.secondary,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.5)),
                                Text(widget.theatreDetailsData.hallName,
                                    style: CustomStyleClass
                                        .onboardingBodyTextStyle
                                        .copyWith(
                                            color: ColorPalette.secondary,
                                            fontSize:
                                                SizeConfig.textMultiplier *
                                                    1.5)),
                              ],
                            ),
                          )
                        ]),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(widget.chairList.length.toString(),
                              style: CustomStyleClass.onboardingSkipButtonStyle
                                  .copyWith(
                                color: ColorPalette.secondary,
                              )),
                          Text("\nM-Ticket",
                              style: CustomStyleClass.onboardingBodyTextStyle
                                  .copyWith(
                                      color: ColorPalette.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.5)),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                ),
                halfCircleDivider(),
                contactDetailsSection(),
                const MySeparator(
                  height: 1.5,
                  color: ColorPalette.background,
                  direction: Axis.horizontal,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 10,
                ),
                amountSection(),
                const Divider(
                  height: 10,
                  thickness: 1,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 30,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 60,
                ),
              ]),
              Positioned(
                top: -(SizeConfig.heightMultiplier * 15),
                left: 10,
                right: 10,
                child: printHalfCircles(),
              ),
              Positioned(
                bottom: -(SizeConfig.heightMultiplier * 15),
                left: 10,
                right: 10,
                child: printHalfCircles(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget printHalfCircles() {
    double totalWidth = SizeConfig.fullHeight - 30;
    double remainingLength = 0;
    double circleSize = SizeConfig.heightMultiplier * 25;
    List<Widget> circleList = [];

    while (remainingLength < totalWidth) {
      // log(remainingLength.toString());
      circleList.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            color: ColorPalette.background),
        height: SizeConfig.heightMultiplier * 25,
        width: SizeConfig.heightMultiplier * 25,
      ));
      remainingLength = (remainingLength + circleSize * 4);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: circleList,
    );
    //return Container();
  }

  Widget halfCircleDivider() {
    return SizedBox(
      height: SizeConfig.heightMultiplier * 60,
      width: SizeConfig.fullWidth,
      child: Stack(
        children: [
          const Center(
            child: MySeparator(
              height: 1.5,
              color: ColorPalette.background,
              direction: Axis.horizontal,
            ),
          ),
          Positioned(
              left: -(SizeConfig.heightMultiplier * 30),
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: ColorPalette.background,
                radius: SizeConfig.heightMultiplier * 30,
              )),
          Positioned(
              right: -(SizeConfig.heightMultiplier * 30),
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: ColorPalette.background,
                radius: SizeConfig.heightMultiplier * 30,
              ))
        ],
      ),
    );
  }

  Widget contactDetailsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 8,
        ),
        Text(
          'Contact Details',
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.secondary,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.textMultiplier * 1.8),
        ),
        const Divider(
          color: ColorPalette.background,
          thickness: 1,
          height: 15,
        ),
        Text(
          preferences!.getString("_userName")!,
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.secondary,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.textMultiplier * 1.5),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 8,
        ),
        Text(
          preferences!.getString("_userEmail")!,
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: ColorPalette.secondary,
              fontSize: SizeConfig.textMultiplier * 1.5),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              preferences!.getString("_userPhone")!,
              maxLines: 1,
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.5),
            ),
            Consumer<LocationProvider>(builder: (context, locProvider, child) {
              return Text(
                "  |  ${locProvider.pickUpLocation.locality}, ${locProvider.pickUpLocation.city} ",
                maxLines: 1,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: ColorPalette.secondary,
                    letterSpacing: 0.6,
                    fontSize: SizeConfig.textMultiplier * 1.5),
              );
            }),
            const Expanded(child: SizedBox())
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 15,
        ),
      ]),
    );
  }

  Widget amountSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(children: [
        SizedBox(
          height: SizeConfig.heightMultiplier * 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sub Total',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.8),
            ),
            Text(
              "??? ${subtotalAmount.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.9),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Convenience fees',
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.secondary,
                      fontSize: SizeConfig.textMultiplier * 1.8),
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  color: ColorPalette.secondary,
                  size: 18,
                )
              ],
            ),
            Text(
              "??? ${convenienceFees.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.8),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Base Amount',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.dark,
                  fontSize: SizeConfig.textMultiplier * 1.7),
            ),
            Text(
              "??? ${baseAmount.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.dark,
                  fontSize: SizeConfig.textMultiplier * 1.7),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Integrated GST (IGST) @ 18%',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.dark,
                  fontSize: SizeConfig.textMultiplier * 1.7),
            ),
            Text(
              "??? ${gst.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.dark,
                  fontSize: SizeConfig.textMultiplier * 1.7),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AssetImageClass.appLogo,
                      height: 18,
                      width: 18,
                    ),
                    Text(
                      ' Contribution to BookASmile',
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.textMultiplier * 1.5),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 5,
                ),
                Text(
                  '   (???1 per ticket has been added)',
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.dark,
                      //fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 1.5),
                ),
              ],
            ),
            Text(
              "??? ${bookASmileFees.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontSize: SizeConfig.textMultiplier * 1.8),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 10,
        ),
        const Divider(
          thickness: 1,
          height: 15,
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Payable Amount',
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.8),
            ),
            Text(
              "??? ${totalPayable.toStringAsFixed(2)}",
              style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                  color: ColorPalette.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.textMultiplier * 1.8),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 15,
        ),
      ]),
    );
  }
}

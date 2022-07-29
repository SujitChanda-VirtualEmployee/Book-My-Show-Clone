import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../models/hall_details_model.dart';
import '../../../models/movie_details_model.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/size_config.dart';
import '../../ticketBookingScreen/ticket_booking_screen.dart';

class SelectTicketCountSheetComponent extends StatefulWidget {
  final MovieDetailsModel movieDetailsData;
  final CinemaHallClass theatreDetailsData;
  final DateTime selectedDate;
  final String selectedTime;

  const SelectTicketCountSheetComponent({
    Key? key,
    required this.movieDetailsData,
    required this.theatreDetailsData,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  State<SelectTicketCountSheetComponent> createState() =>
      _SelectTicketCountSheetComponentState();
}

class _SelectTicketCountSheetComponentState
    extends State<SelectTicketCountSheetComponent> {
  int imageSelected = 0;
  List countList = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List iconList = [
    "assets/icons/cycling.png",
    "assets/icons/scooter.png",
    "assets/icons/motorbike.png",
    "assets/icons/car.png",
    "assets/icons/car.png",
    "assets/icons/suv.png",
    "assets/icons/car-2.png",
    "assets/icons/car-2.png",
    "assets/icons/bus.png",
    "assets/icons/bus.png",
  ];
  @override
  void initState() {
    log("Selected Date : ${widget.selectedDate}");
    log("Selected Time : ${widget.selectedTime}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.fullHeight / 2,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorPalette.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.heightMultiplier * 15),
            Container(
              height: 2,
              width: SizeConfig.fullWidth / 3.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPalette.secondary),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "How many Seats ? ",
                  style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: ColorPalette.secondary,
                      fontSize: SizeConfig.textMultiplier * 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 30),
            Expanded(
              child: SizedBox(
                  child: Image.asset(
                iconList[imageSelected],
                height: SizeConfig.heightMultiplier * 40,
              )),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 30),
            SizedBox(
              height: SizeConfig.heightMultiplier * 32,
              width: SizeConfig.fullWidth,
              child: Center(
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        imageSelected = index;
                        for (int i = 0; i < countList.length; i++) {
                          if (i == index) {
                            setState(() {
                              countList[i] = true;
                            });
                          } else {
                            setState(() {
                              countList[i] = false;
                            });
                          }
                        }
                        log(countList.toString());
                      },
                      child: Container(
                        height: SizeConfig.heightMultiplier * 32,
                        width: SizeConfig.heightMultiplier * 32,
                        decoration: BoxDecoration(
                            color: countList[index] == true
                                ? ColorPalette.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(500)),
                        child: Center(
                            child: Text(
                          "${index + 1}",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  fontWeight: FontWeight.bold,
                                  color: countList[index] == true
                                      ? Colors.white
                                      : Colors.black),
                        )),
                      ),
                    );
                  },
                  itemCount: countList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: SizeConfig.widthMultiplier * 25,
                    );
                  },
                ),
              ),
            ),
            Divider(
              height: SizeConfig.heightMultiplier * 30,
              thickness: 1,
            ),
            // SizedBox(height: SizeConfig.heightMultiplier * 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SILVER",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: SizeConfig.textMultiplier * 1.5,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 10),
                    Text(
                      "₹ 100.00",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 10),
                    Text(
                      "Available".toUpperCase(),
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.green,
                        fontSize: SizeConfig.textMultiplier * 1.4,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "GOLD",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: SizeConfig.textMultiplier * 1.5,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 10),
                    Text(
                      "₹ 130.00",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 10),
                    Text(
                      "Available".toUpperCase(),
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.green,
                        fontSize: SizeConfig.textMultiplier * 1.4,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BALCONY - US",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.black,
                        fontSize: SizeConfig.textMultiplier * 1.5,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 10),
                    Text(
                      "₹ 110.00",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2,
                      ),
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 10),
                    Text(
                      "Available".toUpperCase(),
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.green,
                        fontSize: SizeConfig.textMultiplier * 1.4,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 20,
            ),
            Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorPalette.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        TicketBookingScreen.id,
                        arguments: [
                          widget.movieDetailsData,
                          widget.theatreDetailsData,
                          widget.selectedDate,
                          widget.selectedTime,
                          (imageSelected + 1),
                        ],
                      );
                    },
                    child: Text(
                      "Select Seats",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 2,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

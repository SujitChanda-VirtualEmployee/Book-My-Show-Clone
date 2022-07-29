import 'dart:math';

import 'package:book_my_show_clone/screens/paymentScreen/payment_screen.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/hall_details_model.dart';
import '../../models/movie_details_model.dart';
import '../../utils/color_palette.dart';
import '../../utils/custom_styles.dart';

class TicketBookingScreen extends StatefulWidget {
  static const String id = "ticketBooking-screen";

  final MovieDetailsModel movieDetailsData;
  final CinemaHallClass theatreDetailsData;
  final DateTime selectedDate;
  final String selectedTime;
  final int ticketCount;

  const TicketBookingScreen(
      {Key? key,
      required this.movieDetailsData,
      required this.ticketCount,
      required this.theatreDetailsData,
      required this.selectedDate,
      required this.selectedTime})
      : super(key: key);

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  List<ChairList> selectedSeats = [];
  double amountNeedTopay = 0;
  List<TopLeftChairList> topLeftChairList = [];
  List<TopRightChairList> topRightChairList = [];
  List<TopCenterChairList> topCenterChairList = [];
  List<MidRightChairList> midRightChairList = [];
  List<MidLeftChairList> midLeftChairList = [];
  List<MidCenterChairList> midCenterChairList = [];
  List<BottomLeftChairList> bottomLeftChairList = [];
  List<BottomRightChairList> bottomRightChairList = [];
  List<BottomCenterChairList> bottomCenterChairList = [];

  @override
  void initState() {
    setTopLeftChairList();
    setTopRightChairList();
    setTopCenterChairList();

    setMidLeftChairList();
    setMidRightChairList();
    setMidCenterChairList();

    setBottomLeftChairList();
    setBottomRightChairList();
    setBottomCenterChairList();

    super.initState();
  }

  setTopLeftChairList() {
    for (int i = 0; i < 28; i++) {
      if (i == 24 ||
          i == 25 ||
          i == 26 ||
          i == 27 ||
          i == 0 ||
          i == 1 ||
          i == 6 ||
          i == 7) {
        topLeftChairList.add(TopLeftChairList(
            id: "TLS ${i + 1}", price: 110, selected: false, occupied: true));
      } else {
        topLeftChairList.add(TopLeftChairList(
            id: "TLS ${i + 1}", price: 110, selected: false, occupied: false));
      }
    }
  }

  setTopRightChairList() {
    for (int i = 0; i < 28; i++) {
      if (i == 24 ||
          i == 25 ||
          i == 26 ||
          i == 27 ||
          i == 12 ||
          i == 19 ||
          i == 20 ||
          i == 7) {
        topRightChairList.add(TopRightChairList(
            id: "TRS ${i + 1}", price: 110, selected: false, occupied: true));
      } else {
        topRightChairList.add(TopRightChairList(
            id: "TRS ${i + 1}", price: 110, selected: false, occupied: false));
      }
    }
  }

  setTopCenterChairList() {
    for (int i = 0; i < 36; i++) {
      if (i == 6 ||
          i == 13 ||
          i == 14 ||
          i == 15 ||
          i == 16 ||
          i == 17 ||
          i == 12 ||
          i == 11 ||
          i == 10 ||
          i == 9 ||
          i == 8 ||
          i == 7) {
        topCenterChairList.add(TopCenterChairList(
            id: "TCS ${i + 1}", price: 110, selected: false, occupied: true));
      } else {
        topCenterChairList.add(TopCenterChairList(
            id: "TCS ${i + 1}", price: 110, selected: false, occupied: false));
      }
    }
  }

  setMidRightChairList() {
    for (int i = 0; i < 28; i++) {
      midRightChairList.add(MidRightChairList(
          id: "MRS ${i + 1}", price: 130, selected: false, occupied: false));
    }
  }

  setMidLeftChairList() {
    for (int i = 0; i < 28; i++) {
      if (i == 23 ||
          i == 22 ||
          i == 21 ||
          i == 20 ||
          i == 19 ||
          i == 18 ||
          i == 0 ||
          i == 5 ||
          i == 4 ||
          i == 3 ||
          i == 2 ||
          i == 1) {
        midLeftChairList.add(MidLeftChairList(
            id: "MLS ${i + 1}", price: 130, selected: false, occupied: true));
      } else {
        midLeftChairList.add(MidLeftChairList(
            id: "MLS ${i + 1}", price: 130, selected: false, occupied: false));
      }
    }
  }

  setMidCenterChairList() {
    for (int i = 0; i < 36; i++) {
      if (i == 23 ||
          i == 22 ||
          i == 21 ||
          i == 20 ||
          i == 19 ||
          i == 18 ||
          i == 0 ||
          i == 5 ||
          i == 4 ||
          i == 3 ||
          i == 2 ||
          i == 1) {
        midCenterChairList.add(MidCenterChairList(
            id: "MCS ${i + 1}", price: 130, selected: false, occupied: true));
      } else {
        midCenterChairList.add(MidCenterChairList(
            id: "MCS ${i + 1}", price: 130, selected: false, occupied: false));
      }
    }
  }

  setBottomLeftChairList() {
    for (int i = 0; i < 24; i++) {
      bottomLeftChairList.add(BottomLeftChairList(
          id: "BLS ${i + 1}", price: 100, selected: false, occupied: false));
    }
  }

  setBottomRightChairList() {
    for (int i = 0; i < 24; i++) {
      if (i == 13 ||
          i == 12 ||
          i == 11 ||
          i == 10 ||
          i == 19 ||
          i == 18 ||
          i == 0 ||
          i == 5 ||
          i == 4 ||
          i == 3 ||
          i == 2 ||
          i == 1) {
        bottomRightChairList.add(BottomRightChairList(
            id: "BRS ${i + 1}", price: 100, selected: false, occupied: true));
      } else {
        bottomRightChairList.add(BottomRightChairList(
            id: "BRS ${i + 1}", price: 100, selected: false, occupied: false));
      }
    }
  }

  setBottomCenterChairList() {
    for (int i = 0; i < 30; i++) {
      if (i == 14 || i == 15) {
        bottomCenterChairList.add(BottomCenterChairList(
            id: "BCS ${i + 1}", price: 100, selected: false, occupied: true));
      } else {
        bottomCenterChairList.add(BottomCenterChairList(
            id: "BCS ${i + 1}", price: 100, selected: false, occupied: false));
      }
    }
  }

  _showToast() {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: "Sorry, this seat is not available",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorPalette.secondary,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 1.6);
  }

  _sheatOnTap({required int index, required List<ChairList> chairList}) {
    if (chairList[index].occupied == true) {
      _showToast();
    } else {
      if (chairList[index].selected == false &&
          selectedSeats.length < widget.ticketCount) {
        setState(() {
          chairList[index].selected = true;
          selectedSeats.add(chairList[index]);
          amountNeedTopay = amountNeedTopay + chairList[index].price;
        });
      } else if (chairList[index].selected == true) {
        setState(() {
          chairList[index].selected = false;
          selectedSeats.remove(chairList[index]);
          amountNeedTopay = amountNeedTopay - chairList[index].price;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Visibility(
        visible: widget.ticketCount == selectedSeats.length,
        child: SafeArea(
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
                    Navigator.pushNamed(context, PaymentScreen.id, arguments: [
                      widget.movieDetailsData,
                      widget.theatreDetailsData,
                      widget.selectedDate,
                      widget.selectedTime,
                      selectedSeats,
                    ]);
                  },
                  child: Text(
                    "Pay ₹ ${amountNeedTopay.toStringAsFixed(2)}",
                    style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.textMultiplier * 2,
                    ),
                  )),
            ),
          ),
        ),
      ),
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
              color: Colors.white,
              shadows: [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: ColorPalette.secondary,
                    spreadRadius: 10,
                    blurRadius: 10),
              ],
            )),
        centerTitle: false,
        title: Text(
          widget.movieDetailsData.title!,
          style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
              color: Colors.white, fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    return SizedBox(
      height: SizeConfig.fullHeight,
      width: SizeConfig.fullWidth,
      child: Column(children: [
        Expanded(
          flex: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Text(
                "   ₹ 110.00 - BALCONY - US".toUpperCase(),
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.secondary),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig.fullWidth * 0.28,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: topLeftChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: topLeftChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: topLeftChairList, index: index);
                              },
                              occupied: topLeftChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),

                    Container(
                      width: SizeConfig.fullWidth * 0.44,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: topCenterChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: topCenterChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: topCenterChairList,
                                    index: index);
                                // for (int i = 0;
                                //     i < topCenterChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (topCenterChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         topCenterChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(topCenterChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             topCenterChairList[index].price;
                                //       });
                                //     } else if (topCenterChairList[i].selected ==
                                //         true) {
                                //       setState(() {
                                //         topCenterChairList[i].selected = false;
                                //         selectedSeats
                                //             .remove(topCenterChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             topCenterChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: topCenterChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: SizeConfig.widthMultiplier * 5,
                    // ),
                    Container(
                      width: SizeConfig.fullWidth * 0.28,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: topRightChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: topRightChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: topRightChairList, index: index);
                                // for (int i = 0;
                                //     i < topRightChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (topRightChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         topRightChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(topRightChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             topRightChairList[index].price;
                                //       });
                                //     } else if (topRightChairList[i].selected ==
                                //         true) {
                                //       setState(() {
                                //         topRightChairList[i].selected = false;
                                //         selectedSeats
                                //             .remove(topRightChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             topRightChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: topRightChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: SizeConfig.widthMultiplier * 5,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        Expanded(
          flex: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Text(
                "   ₹ 130.00 - Gold ",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.secondary),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig.fullWidth * 0.28,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: midLeftChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: midLeftChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: midLeftChairList, index: index);
                                // for (int i = 0;
                                //     i < midLeftChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (midLeftChairList[i].selected == false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         midLeftChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(midLeftChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             midLeftChairList[index].price;
                                //       });
                                //     } else if (midLeftChairList[i].selected ==
                                //         true) {
                                //       setState(() {
                                //         midLeftChairList[i].selected = false;
                                //         selectedSeats
                                //             .remove(midLeftChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             midLeftChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: midLeftChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.fullWidth * 0.44,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: midCenterChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: midCenterChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: midCenterChairList,
                                    index: index);
                                // for (int i = 0;
                                //     i < midCenterChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (midCenterChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         midCenterChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(midCenterChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             midCenterChairList[index].price;
                                //       });
                                //     } else if (midCenterChairList[i].selected ==
                                //         true) {
                                //       setState(() {
                                //         midCenterChairList[i].selected = false;
                                //         selectedSeats
                                //             .remove(midCenterChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             midCenterChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: midCenterChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.fullWidth * 0.28,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: midRightChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: midRightChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: midRightChairList, index: index);
                                // for (int i = 0;
                                //     i < midRightChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (midRightChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         midRightChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(midRightChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             midRightChairList[index].price;
                                //       });
                                //     } else if (midRightChairList[i].selected ==
                                //         true) {
                                //       setState(() {
                                //         midRightChairList[i].selected = false;
                                //         selectedSeats
                                //             .remove(midRightChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             midRightChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: midRightChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
        ),
        Expanded(
          flex: 9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Text(
                "   ₹ 100.00 - Silver",
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    fontSize: SizeConfig.textMultiplier * 1.6,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.secondary),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig.fullWidth * 0.28,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: bottomLeftChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: bottomLeftChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: bottomLeftChairList,
                                    index: index);
                                // for (int i = 0;
                                //     i < bottomLeftChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (bottomLeftChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         bottomLeftChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(bottomLeftChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             bottomLeftChairList[index].price;
                                //       });
                                //     } else if (bottomLeftChairList[i]
                                //             .selected ==
                                //         true) {
                                //       setState(() {
                                //         bottomLeftChairList[i].selected = false;
                                //         selectedSeats
                                //             .remove(bottomLeftChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             bottomLeftChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: bottomLeftChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.fullWidth * 0.44,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: bottomCenterChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: bottomCenterChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: bottomCenterChairList,
                                    index: index);
                                // for (int i = 0;
                                //     i < bottomCenterChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (bottomCenterChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         bottomCenterChairList[i].selected =
                                //             true;
                                //         selectedSeats
                                //             .add(bottomCenterChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             bottomCenterChairList[index].price;
                                //       });
                                //     } else if (bottomCenterChairList[i]
                                //             .selected ==
                                //         true) {
                                //       setState(() {
                                //         bottomCenterChairList[i].selected =
                                //             false;
                                //         selectedSeats.remove(
                                //             bottomCenterChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             bottomCenterChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: bottomCenterChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.fullWidth * 0.28,
                      color: Colors.white,
                      child: Center(
                        child: GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: bottomRightChairList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChairWidget(
                              title: (index + 1).toString(),
                              selected: bottomRightChairList[index].selected,
                              onTap: () {
                                _sheatOnTap(
                                    chairList: bottomRightChairList,
                                    index: index);
                                // for (int i = 0;
                                //     i < bottomRightChairList.length;
                                //     i++) {
                                //   if (i == index) {
                                //     if (bottomRightChairList[i].selected ==
                                //             false &&
                                //         selectedSeats.length <
                                //             widget.ticketCount) {
                                //       setState(() {
                                //         bottomRightChairList[i].selected = true;
                                //         selectedSeats
                                //             .add(bottomRightChairList[index]);
                                //         amountNeedTopay = amountNeedTopay +
                                //             bottomRightChairList[index].price;
                                //       });
                                //     } else if (bottomRightChairList[i]
                                //             .selected ==
                                //         true) {
                                //       setState(() {
                                //         bottomRightChairList[i].selected =
                                //             false;
                                //         selectedSeats.remove(
                                //             bottomRightChairList[index]);
                                //         amountNeedTopay = amountNeedTopay -
                                //             bottomRightChairList[index].price;
                                //       });
                                //     }
                                //   }
                                // }
                              },
                              occupied: bottomRightChairList[index].occupied,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            // color: ColorPalette.primary,
            height: 35,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, -2),
                            color: ColorPalette.primary.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 1,
                          )
                        ],
                        color: ColorPalette.secondary.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.elliptical(80, 10),
                            bottomRight: Radius.elliptical(80, 10))),
                    height: 10,
                    width: SizeConfig.fullWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ]),
    );
  }
}

class ChairWidget extends StatefulWidget {
  final String title;
  final bool occupied;
  final bool selected;

  final Function() onTap;
  const ChairWidget({
    Key? key,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.occupied,
  }) : super(key: key);

  @override
  State<ChairWidget> createState() => _ChairWidgetState();
}

class _ChairWidgetState extends State<ChairWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 5,
        width: SizeConfig.heightMultiplier * 5,
        //padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.occupied ? ColorPalette.primary : Colors.green,
                width: 1),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0.7, 0.7),
                color: ColorPalette.dark.withOpacity(0.5),
              ),
            ],
            color: widget.occupied
                ? ColorPalette.primary.withOpacity(0.8)
                : widget.selected
                    ? Colors.green
                    : Colors.white,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            widget.title,
            style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                fontSize: SizeConfig.textMultiplier * 1.2,
                fontWeight: FontWeight.bold,
                color: widget.occupied
                    ? ColorPalette.white
                    : widget.selected
                        ? Colors.white
                        : Colors.black),
          ),
        )),
      ),
    );
  }
}

class ChairList {
  final String id;
  final double price;
  bool selected;
  bool occupied;

  ChairList(
      {required this.id,
      required this.price,
      required this.selected,
      required this.occupied});
}

class TopLeftChairList extends ChairList {
  TopLeftChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class TopRightChairList extends ChairList {
  TopRightChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class TopCenterChairList extends ChairList {
  TopCenterChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class MidRightChairList extends ChairList {
  MidRightChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class MidLeftChairList extends ChairList {
  MidLeftChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class MidCenterChairList extends ChairList {
  MidCenterChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class BottomRightChairList extends ChairList {
  BottomRightChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class BottomLeftChairList extends ChairList {
  BottomLeftChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

class BottomCenterChairList extends ChairList {
  BottomCenterChairList(
      {required super.id,
      required super.price,
      required super.selected,
      required super.occupied});
}

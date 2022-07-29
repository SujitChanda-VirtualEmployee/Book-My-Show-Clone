import 'dart:developer';
import 'package:book_my_show_clone/screens/selectMovieHallScreen/components/tile_info_sheet_content.dart';
import 'package:book_my_show_clone/utils/custom_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/hall_details_model.dart';
import '../../../utils/color_palette.dart';
import '../../../utils/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CinemaHallTile extends StatefulWidget {
  final CinemaHallClass data;

  final Function(String selectedTime) onTimeSelect;
  const CinemaHallTile({
    Key? key,
    required this.data,
    required this.onTimeSelect,
  }) : super(key: key);

  @override
  State<CinemaHallTile> createState() => _CinemaHallTileState();
}

class _CinemaHallTileState extends State<CinemaHallTile> {
  tileInfoCountSheet(BuildContext context) {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return TileInfoSheetContent(
            hallData: widget.data,
          );
        }).then((val) {
      log("=============================================================");
      if (val != null) {
        if (val == true) {
          // Navigator.pushNamed(context, NewBookingDetailsScreen.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(widget.data.hallName,
                        style: CustomStyleClass.onboardingBodyTextStyle
                            .copyWith(
                                color: ColorPalette.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.textMultiplier * 1.8))),
                SizedBox(
                  height: 20,
                  child: TextButton.icon(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        tileInfoCountSheet(context);
                      },
                      icon: Icon(
                        widget.data.covidSecure
                            ? CupertinoIcons.checkmark_shield_fill
                            : Icons.info_outline,
                        size: 15,
                        color: widget.data.covidSecure
                            ? Colors.green
                            : ColorPalette.secondary,
                      ),
                      label: Text("INFO",
                          style: CustomStyleClass.onboardingBodyTextStyle
                              .copyWith(
                                  color: ColorPalette.secondary,
                                  fontSize: SizeConfig.textMultiplier * 1.5))),
                )
              ],
            ),
            Visibility(
              visible: widget.data.cancellationAvailable,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 5),
                  child: Text("Cancellation Available",
                      style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                          color: ColorPalette.secondary,
                          fontSize: SizeConfig.textMultiplier * 1.5)),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 15,
            ),
            timeList()
          ],
        ),
      ),
    );
  }

  Widget timeList() {
    List<Widget> timeWidgetList = [];

    for (int i = 0; i < widget.data.timeSlot.length; i++) {
      timeWidgetList.add(InkWell(
        onTap: () {
          if (widget.data.timeSlot[i].soldOut) {
            _showToast();
          } else {
            widget.onTimeSelect(widget.data.timeSlot[i].timeSlot);
          }
        },
        child: Container(
          width: SizeConfig.fullWidth / 4.9,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorPalette.dark),
          ),
          child: Center(
            child: Text(widget.data.timeSlot[i].timeSlot,
                style: CustomStyleClass.onboardingBodyTextStyle.copyWith(
                    color: widget.data.timeSlot[i].soldOut
                        ? ColorPalette.dark
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.textMultiplier * 1.6)),
          ),
        ),
      ));
    }
    return SizedBox(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: timeWidgetList,
      ),
    );
  }

  _showToast() {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: "All the Tickets for this show are Sold Out",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorPalette.secondary,
        textColor: Colors.white,
        fontSize: SizeConfig.textMultiplier * 1.6);
  }
}

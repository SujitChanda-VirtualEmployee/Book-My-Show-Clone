import 'dart:developer';
import 'package:book_my_show_clone/models/hall_details_model.dart';
import 'package:book_my_show_clone/models/movie_details_model.dart';
import 'package:book_my_show_clone/utils/color_palette.dart';
import 'package:book_my_show_clone/utils/size_config.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mediaDetailsScreen/components/select_ticket_count.dart';
import 'components/cinema_hall_tile.dart';



class SelectMovieHallScreen extends StatefulWidget {
  final MovieDetailsModel movieDetailsData;
  static const String id = "selectMovieHall-screen";
  const SelectMovieHallScreen({Key? key, required this.movieDetailsData})
      : super(key: key);

  @override
  State<SelectMovieHallScreen> createState() => _SelectMovieHallScreenState();
}

class _SelectMovieHallScreenState extends State<SelectMovieHallScreen> {
  DateTime now = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  selctTicketCountSheet({
    required BuildContext context,
    required CinemaHallClass theatreDetailsData,
    required DateTime date,
    required String time,
  }) {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SelectTicketCountSheetComponent(
            movieDetailsData: widget.movieDetailsData,
            theatreDetailsData: theatreDetailsData,
            selectedDate: date,
            selectedTime: time,
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
  void initState() {
    endDate = now.add(const Duration(days: 15));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette.secondary,
        centerTitle: true,
        title: Text(
          widget.movieDetailsData.title.toString(),
          style: TextStyle(
              color: Colors.white, fontSize: SizeConfig.textMultiplier * 2),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          color: Colors.white,
          child: CalendarTimeline(
            initialDate: DateTime(
              now.year,
              now.month,
              now.day,
            ),
            firstDate: DateTime(now.year, now.month, now.day),
            lastDate: DateTime(endDate.year, endDate.month, endDate.day),
            onDateSelected: (date) {
              selectedDate = date;
            },
            leftMargin: 10,
            monthColor: ColorPalette.secondary,
            dayColor: ColorPalette.dark,
            activeDayColor: ColorPalette.white,
            activeBackgroundDayColor: ColorPalette.primary,
            dotsColor: ColorPalette.white,
            //  selectableDayPredicate: (date) => date.day != 23,
            locale: 'en_ISO',
          ),
        ),
        const Divider(
          thickness: 1,
          height: 0,
        ),
        Expanded(
            child: ListView.separated(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          itemCount: demoCinemaHallList.length,
          itemBuilder: (BuildContext context, int index) {
            return CinemaHallTile(
              data: demoCinemaHallList[index],
              onTimeSelect: (selectedTime) {
                Fluttertoast.cancel();
                selctTicketCountSheet(
                    context: context,
                    theatreDetailsData: demoCinemaHallList[index],
                    date: selectedDate,
                    time: selectedTime);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: SizeConfig.heightMultiplier * 15,
            );
          },
        ))
      ],
    );
  }
}

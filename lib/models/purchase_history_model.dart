// To parse this JSON data, do
//
//     final purchaseHistoryModel = purchaseHistoryModelFromJson(jsonString);

import 'dart:convert';

PurchaseHistoryModel purchaseHistoryModelFromJson(String str) =>
    PurchaseHistoryModel.fromJson(json.decode(str));

String purchaseHistoryModelToJson(PurchaseHistoryModel data) =>
    json.encode(data.toJson());

class PurchaseHistoryModel {
  PurchaseHistoryModel({
    this.contributionToBookASmile,
    this.tickets,
    this.movieRating,
    this.movieTheaterLng,
    this.gst,
    this.movieTheaterAddress,
    this.bookingId,
    this.baseAmount,
    this.subtotalAmount,
    this.totalPayable,
    this.movieTime,
    this.numberOfTickets,
    this.moviveName,
    this.moviePoster,
    this.customerId,
    this.conveniemcefees,
    this.movieTheaterName,
    this.movieTheaterLat,
    this.movieDate,
  });

  String? contributionToBookASmile;
  String? tickets;
  String? movieRating;
  double? movieTheaterLng;
  String? gst;
  String? movieTheaterAddress;
  String? bookingId;
  String? baseAmount;
  String? subtotalAmount;
  String? totalPayable;
  String? movieTime;
  int? numberOfTickets;
  String? moviveName;
  String? moviePoster;
  String? customerId;
  String? conveniemcefees;
  String? movieTheaterName;
  double? movieTheaterLat;
  String? movieDate;

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) =>
      PurchaseHistoryModel(
        contributionToBookASmile: json["contributionToBookASmile"] == null
            ? null
            : json["contributionToBookASmile"],
        tickets: json["tickets"] == null ? null : json["tickets"],
        movieRating: json["movieRating"] == null ? null : json["movieRating"],
        movieTheaterLng: json["movieTheaterLng"] == null
            ? null
            : json["movieTheaterLng"].toDouble(),
        gst: json["gst"] == null ? null : json["gst"],
        movieTheaterAddress: json["movieTheaterAddress"] == null
            ? null
            : json["movieTheaterAddress"],
        bookingId: json["bookingID"] == null ? null : json["bookingID"],
        baseAmount: json["baseAmount"] == null ? null : json["baseAmount"],
        subtotalAmount:
            json["subtotalAmount"] == null ? null : json["subtotalAmount"],
        totalPayable:
            json["totalPayable"] == null ? null : json["totalPayable"],
        movieTime: json["movieTime"] == null ? null : json["movieTime"],
        numberOfTickets:
            json["numberOfTickets"] == null ? null : json["numberOfTickets"],
        moviveName: json["moviveName"] == null ? null : json["moviveName"],
        moviePoster: json["moviePoster"] == null ? null : json["moviePoster"],
        customerId: json["customerID"] == null ? null : json["customerID"],
        conveniemcefees:
            json["conveniemcefees"] == null ? null : json["conveniemcefees"],
        movieTheaterName:
            json["movieTheaterName"] == null ? null : json["movieTheaterName"],
        movieTheaterLat: json["movieTheaterLat"] == null
            ? null
            : json["movieTheaterLat"].toDouble(),
        movieDate: json["movieDate"] == null ? null : json["movieDate"],
      );

  Map<String, dynamic> toJson() => {
        "contributionToBookASmile":
            contributionToBookASmile == null ? null : contributionToBookASmile,
        "tickets": tickets == null ? null : tickets,
        "movieRating": movieRating == null ? null : movieRating,
        "movieTheaterLng": movieTheaterLng == null ? null : movieTheaterLng,
        "gst": gst == null ? null : gst,
        "movieTheaterAddress":
            movieTheaterAddress == null ? null : movieTheaterAddress,
        "bookingID": bookingId == null ? null : bookingId,
        "baseAmount": baseAmount == null ? null : baseAmount,
        "subtotalAmount": subtotalAmount == null ? null : subtotalAmount,
        "totalPayable": totalPayable == null ? null : totalPayable,
        "movieTime": movieTime == null ? null : movieTime,
        "numberOfTickets": numberOfTickets == null ? null : numberOfTickets,
        "moviveName": moviveName == null ? null : moviveName,
        "moviePoster": moviePoster == null ? null : moviePoster,
        "customerID": customerId == null ? null : customerId,
        "conveniemcefees": conveniemcefees == null ? null : conveniemcefees,
        "movieTheaterName": movieTheaterName == null ? null : movieTheaterName,
        "movieTheaterLat": movieTheaterLat == null ? null : movieTheaterLat,
        "movieDate": movieDate == null ? null : movieDate,
      };
}

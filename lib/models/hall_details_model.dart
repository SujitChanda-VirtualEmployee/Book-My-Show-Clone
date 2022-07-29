import 'package:intl/intl.dart';

class CinemaHallClass {
  final String hallName;
  final double lat;
  final double lng;
  final String address;
  final bool cancellationAvailable;
  final bool covidSecure;
  final List<CinemaTimeSlot> timeSlot;

  CinemaHallClass({
    required this.hallName,
    required this.timeSlot,
    required this.lat,
    required this.lng,
    required this.address,
    required this.cancellationAvailable,
    required this.covidSecure,
  });
}

class CinemaTimeSlot {
  final String timeSlot;
  final bool soldOut;

  CinemaTimeSlot({required this.timeSlot, required this.soldOut});
}

List<CinemaHallClass> demoCinemaHallList = [
  CinemaHallClass(
      address:
          '4th floor, Syed Amir Ali Avenue, Opposite Our Lady Queen of The Mission School, Kolkata, West Bengal, India',
      cancellationAvailable: false,
      covidSecure: true,
      hallName: 'INOX Quest Mall, Ballygunge',
      lat:22.539986726825106, 
      lng: 88.36523924447606,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 11:45:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 14:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 17:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 19:30:00")),
        )
      ]),
  CinemaHallClass(
      address:
          '2th floor, South City Mall, 375,Prince Anwar Shah Road, Kolkata, West Bengal, India',
      cancellationAvailable: true,
      covidSecure: true,
      hallName: 'INOX South City Mall',
      lat:22.501700686190862,
      lng:  88.36173308310327,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 09:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 10:15:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 11:45:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 14:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 16:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 17:15:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 18:45:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 20:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 21:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 22:45:00")),
        ),
      ]),
  CinemaHallClass(
      address:
          'Diamond City Mall, %th Floor, 68 Jassore Road, Kolkata, West Bengal, India, 700055',
      cancellationAvailable: true,
      covidSecure: false,
      hallName: 'PVR Diamond Plaza, Jassore Road',
      lat: 22.615783700953436,
      lng:  88.4124173934361,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 09:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 10:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 11:55:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 13:15:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 15:45:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 17:20:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 18:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 19:55:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 22:30:00")),
        ),
      ]),
  CinemaHallClass(
      address:
          'No: 30, Diamond Harbour Road, Behala, Kolkata, West Bengal, 700038, India',
      cancellationAvailable: false,
      covidSecure: false,
      hallName: 'Ajanta Cinema, Behala',
      lat: 22.5083907745603, 
      lng: 88.32025419429688,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 09:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 10:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 13:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 15:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 16:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 18:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 19:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 21:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 22:30:00")),
        ),
      ]),
  CinemaHallClass(
      address: 'No: 124A, AJC Bose Road, Kolkata, West Bengal, 700014',
      cancellationAvailable: true,
      covidSecure: false,
      hallName: 'Prachi Cinema, AJC Bose Road',
      lat:22.565148042648957, 
      lng: 88.36833461728065,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 10:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 13:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 15:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 16:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 18:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 19:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 21:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 22:30:00")),
        ),
      ]),
  CinemaHallClass(
      address:
          'Mani Square Mall, Plot no 164/1, Nr.Apollo Hospital, EM Bypass Road, Kolkata, West Bengal 700054, India',
      cancellationAvailable: true,
      covidSecure: true,
      hallName: 'IPVR Mani Square Mall',
      lat: 22.57790622967295, 
      lng: 88.4011345002976,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 09:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 10:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 11:45:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 13:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 14:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 15:45:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 17:15:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 18:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 20:00:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 21:15:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 22:45:00")),
        ),
      ]),
  CinemaHallClass(
    address:
        '83, Bidhan Sarani, Near Shyambazar Post Office, Kolkata, West Bengal, 700004, India',
    cancellationAvailable: false,
    covidSecure: true,
    hallName: 'Mitra Cinema, Shyam Bazar',
    lat:22.59743562720531, 
    lng: 88.37215516730785,
    timeSlot: [
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 09:00:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 10:15:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 11:45:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 14:30:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 16:00:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 17:15:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 18:45:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 20:00:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 21:30:00")),
      ),
      CinemaTimeSlot(
        soldOut: false,
        timeSlot: DateFormat.jm().format(DateTime.parse("2012-02-27 22:45:00")),
      ),
    ],
  ),
  CinemaHallClass(
      address:
          'Plot No. BG/12, AA-!B, New Town, Rajarhat, Kolkata, West Bengal, 700156, India',
      cancellationAvailable: false,
      covidSecure: true,
      hallName: 'Miraj Cinemas, Newtown, Kolkata',
      lat: 22.576373, 
      lng: 88.476343,
      timeSlot: [
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 09:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 10:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 13:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 15:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 16:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 18:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 19:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: true,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 21:30:00")),
        ),
        CinemaTimeSlot(
          soldOut: false,
          timeSlot:
              DateFormat.jm().format(DateTime.parse("2012-02-27 22:30:00")),
        ),
      ]),
];

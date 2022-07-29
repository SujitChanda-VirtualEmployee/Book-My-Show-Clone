class Address {
  String? placeFormattedAddress;
  String? placeName;
  String? street;
  String? city;
  String? stateOrProvince;
  String? postalCode;
  String? locality;
  String? country;
  String? placeId;
  double? latitude;
  double? longitude;

  Address({
    this.placeFormattedAddress,
    this.placeName,
    this.placeId,
    this.latitude,
    this.longitude,
    this.country,
    this.city,
    this.street,
    this.stateOrProvince,
    this.postalCode,
    this.locality,
  });
}

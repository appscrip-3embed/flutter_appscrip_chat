import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

extension MatchString on String {
  bool didMatch(String other) => toLowerCase().contains(other.toLowerCase());

  String get convertToValidUrl =>
      'https://${replaceAll('http://', '').replaceAll('https://', '')}';
}

extension DateConvertor on int {
  DateTime toDate() => DateTime.fromMillisecondsSinceEpoch(this);

  String toDateString() =>
      DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(this));
}

extension DateFormats on DateTime {
  String toDateString() => DateFormat.jm().format(this);
}

extension ChildWidget on CustomMessageType {
  Widget messageType(ChatMessageModel message) {
    switch (this) {
      case CustomMessageType.text:
        return TextMessage(message);

      case CustomMessageType.reply:
        return ReplyMessage(message);

      case CustomMessageType.forward:
        return ForwardMessage(message);

      case CustomMessageType.image:
        return ImageMessage(message);

      case CustomMessageType.video:
        return VideoMessage(message);

      case CustomMessageType.audio:
        return AudioMessage(message);

      case CustomMessageType.file:
        return FileMessage(message);

      case CustomMessageType.location:
        return LocationMessage(message);

      case CustomMessageType.block:
        return BlockedMessage(message);

      case CustomMessageType.unblock:
        return BlockedMessage(message);

      case CustomMessageType.deletedForMe:
        return DeletedMessage(message);

      case CustomMessageType.deletedForEveryone:
        return DeletedMessage(message);

      case CustomMessageType.link:
        return LinkMessage(message);

      case CustomMessageType.date:
        return DateMessage(message);
    }
  }
}

extension GetLink on String {
  /// Here we are extracting location coordinates from the url of the app
  /// <BaseUrl>?<Params>&query=`Lat`%2C`Lng`&<Rest Params>
  LatLng get position {
    if (!contains('map')) {
      throw const InvalidMapUrlException(
          "Invalid url, link doesn't contains map link to extract position coordinates");
    }
    var position = split('query=')
        .last
        .split('&')
        .first
        .split('%2C')
        .map(double.parse)
        .toList();

    return LatLng(position.first, position.last);
  }
}

extension AddressString on Placemark {
  /// This function is an extension on `Placemark` class from [geocoding](https://pub.dev/packages/geocoding) package
  /// This will return a formatted address
  String toAddress() => [
        name,
        street,
        subLocality,
        locality,
        administrativeArea,
        country,
        postalCode
      ].join(', ');
}

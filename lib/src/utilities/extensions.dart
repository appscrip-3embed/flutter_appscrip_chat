import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

extension MatchString on String {
  bool didMatch(String other) => toLowerCase().contains(other.toLowerCase());

  String get convertToValidUrl =>
      'https://${replaceAll('http://', '').replaceAll('https://', '')}';
}

extension DateConvertor on int {
  DateTime toDate() => DateTime.fromMillisecondsSinceEpoch(this);

  String toTimeString() =>
      DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(this));

  String toCurrentTimeStirng() {
    final timeStamp = DateTime.fromMillisecondsSinceEpoch(this);
    final currentTime = DateTime.now();
    final currentDay = int.parse(DateFormat('d').format(currentTime));
    final currentDayFromStamp = int.parse(DateFormat('d').format(timeStamp));
    var timeFormate = '';
    if (currentDay == currentDayFromStamp) {
      timeFormate =
          '${ChatStrings.lastSeen} ${ChatStrings.today} ${ChatStrings.at} ${DateFormat.jm().format(timeStamp)}';
    } else if (((currentDay - currentDayFromStamp) == 1) ||
        (currentDayFromStamp == 31)) {
      timeFormate =
          '${ChatStrings.lastSeen} ${ChatStrings.yestarday} ${ChatStrings.at} ${DateFormat.jm().format(timeStamp)}';
    } else if (((currentDay - currentDayFromStamp) > 1 &&
            (currentDay - currentDayFromStamp) < 7) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate =
          '${ChatStrings.lastSeen} ${ChatStrings.at} ${DateFormat('E h:mm a').format(timeStamp)}';
    } else if (((currentDay - currentDayFromStamp) > 7) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate = '${ChatStrings.lastSeen} ${ChatStrings.on} ${DateFormat('MMM d, yyyy h:mm a').format(timeStamp)}';
    }
    return timeFormate;
  }

  String toLastMessageTimeString() {
    final timeStamp = DateTime.fromMillisecondsSinceEpoch(this);
    final currentTime = DateTime.now();
    final currentDay = int.parse(DateFormat('d').format(currentTime));
    final currentDayFromStamp = int.parse(DateFormat('d').format(timeStamp));
    var timeFormate = '';
    if (currentDay == currentDayFromStamp) {
      timeFormate =DateFormat.jm().format(timeStamp);
    
    } else if (((currentDay - currentDayFromStamp) == 1) ||
        (currentDayFromStamp == 31)) {
      timeFormate = ChatStrings.yestarday.capitalizeFirst!;
  
    } else if (((currentDay - currentDayFromStamp) > 1) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate = DateFormat('dd/MM/yyyy').format(timeStamp);
    
    }
    return timeFormate;

  }

  String get weekDayString {
    if (this > 7 || this < 1) {
      throw const InvalidWeekdayNumber('Value should be between 1 & 7');
    }
    var weekDays = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    return weekDays[this]!;
  }

  String toMessageDateString() {
    var now = DateTime.now();
    var date = toDate();
    if (now.isSameDay(date)) {
      return 'Today';
    }
    if (now.isSameMonth(date)) {
      if (now.day - date.day == 1) {
        return 'Yesterday';
      }
      if (now.difference(date) < const Duration(days: 8)) {
        return date.weekday.weekDayString;
      }
      return date.toDateString();
    }
    return date.toDateString();
  }
}

extension DateFormats on DateTime {
  String toTimeString() => DateFormat.jm().format(this);

  bool isSameDay(DateTime other) => isSameMonth(other) && day == other.day;

  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  String toDateString() => DateFormat('dd MMM yyyy').format(this);
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

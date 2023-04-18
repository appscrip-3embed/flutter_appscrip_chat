import 'dart:math';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

extension MatchString on String {
  bool didMatch(String other) => toLowerCase().contains(other.toLowerCase());

  String get convertToValidUrl =>
      'https://${replaceAll('http://', '').replaceAll('https://', '')}';

  bool get isValidUrl =>
      toLowerCase().contains('https') || toLowerCase().contains('www');
}

extension MessagePagination on int {
  int pagination({int endValue = 20}) {
    if (this == 0) {
      return this;
    }
    if (this <= endValue) {
      return endValue;
    }
    endValue = endValue + 20;
    return pagination(endValue: endValue);
  }
}

extension DistanceLatLng on LatLng {
  double getDistance(LatLng other) {
    var lat1 = latitude,
        lon1 = longitude,
        lat2 = other.latitude,
        lon2 = other.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

extension DurationExtensions on Duration {
  String formatDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    var twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    var hour = num.parse(twoDigits(inHours));
    if (hour > 0) {
      return '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }
}

extension IntToTimeLeft on int {
  String getTimerRecord(int value) {
    int h, m, s;
    h = value ~/ 3600;
    m = (value - h * 3600) ~/ 60;
    s = value - (h * 3600) - (m * 60);
    var minuteLeft = m.toString().length < 2 ? '0$m' : m.toString();
    var secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();
    var result = '$minuteLeft:$secondsLeft';
    return result;
  }
}

extension FlashIcon on FlashMode {
  IconData get icon {
    switch (this) {
      case FlashMode.off:
        return Icons.flash_off_rounded;
      case FlashMode.auto:
        return Icons.flash_auto_rounded;
      case FlashMode.always:
      case FlashMode.torch:
        return Icons.flash_on_rounded;
    }
  }
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
          '${IsmChatStrings.lastSeen} ${IsmChatStrings.today} ${IsmChatStrings.at} ${DateFormat.jm().format(timeStamp)}';
    } else if (((currentDay - currentDayFromStamp) == 1) ||
        (currentDayFromStamp == 31)) {
      timeFormate =
          '${IsmChatStrings.lastSeen} ${IsmChatStrings.yestarday} ${IsmChatStrings.at} ${DateFormat.jm().format(timeStamp)}';
    } else if (((currentDay - currentDayFromStamp) > 1 &&
            (currentDay - currentDayFromStamp) < 7) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate =
          '${IsmChatStrings.lastSeen} ${IsmChatStrings.at} ${DateFormat('E h:mm a').format(timeStamp)}';
    } else if (((currentDay - currentDayFromStamp) > 7) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate =
          '${IsmChatStrings.lastSeen} ${IsmChatStrings.on} ${DateFormat('MMM d, yyyy h:mm a').format(timeStamp)}';
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
      timeFormate = DateFormat.jm().format(timeStamp);
    } else if (((currentDay - currentDayFromStamp) == 1) ||
        (currentDayFromStamp == 31)) {
      timeFormate = IsmChatStrings.yestarday.capitalizeFirst!;
    } else if (((currentDay - currentDayFromStamp) > 1) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate = DateFormat('dd/MM/yyyy').format(timeStamp);
    }
    return timeFormate;
  }

  String get weekDayString {
    if (this > 7 || this < 1) {
      throw const IsmChatInvalidWeekdayNumber('Value should be between 1 & 7');
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

extension ChildWidget on IsmChatCustomMessageType {
  Widget messageType(IsmChatChatMessageModel message) {
    switch (this) {
      case IsmChatCustomMessageType.text:
        return IsmChatTextMessage(message);

      case IsmChatCustomMessageType.reply:
        return IsmChatReplyMessage(message);

      case IsmChatCustomMessageType.forward:
        return IsmChatForwardMessage(message);

      case IsmChatCustomMessageType.image:
        return IsmChatImageMessage(message);

      case IsmChatCustomMessageType.video:
        return IsmChatVideoMessage(message);

      case IsmChatCustomMessageType.audio:
        return IsmChatAudioMessage(message);

      case IsmChatCustomMessageType.file:
        return IsmChatFileMessage(message);

      case IsmChatCustomMessageType.location:
        return IsmChatLocationMessage(message);

      case IsmChatCustomMessageType.block:
        return IsmChatBlockedMessage(message);

      case IsmChatCustomMessageType.unblock:
        return IsmChatBlockedMessage(message);

      case IsmChatCustomMessageType.deletedForMe:
        return IsmChatDeletedMessage(message);

      case IsmChatCustomMessageType.deletedForEveryone:
        return IsmChatDeletedMessage(message);

      case IsmChatCustomMessageType.link:
        return IsmChatLinkMessage(message);

      case IsmChatCustomMessageType.date:
        return IsmChatDateMessage(message);
    }
  }

  bool get canCopy => [
        IsmChatCustomMessageType.text,
        IsmChatCustomMessageType.link,
        IsmChatCustomMessageType.location,
        IsmChatCustomMessageType.reply,
      ].contains(this);
}

extension GetLink on String {
  /// Here we are extracting location coordinates from the url of the app
  /// <BaseUrl>?<Params>&query=`Lat`%2C`Lng`&<Rest Params>
  LatLng get position {
    if (!contains('map')) {
      throw const IsmChatInvalidMapUrlException(
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

extension BlockStatus on IsmChatConversationModel {
  bool get isChattingAllowed => !(messagingDisabled ?? false);

  bool get isBlockedByMe {
    if (isChattingAllowed) {
      return false;
    }
    var controller = Get.find<IsmChatConversationsController>();
    var blockedList = controller.blockUsers.map((e) => e.userId);
    return blockedList.contains(opponentDetails!.userId);
  }
}

extension MenuIcon on IsmChatFocusMenuType {
  IconData get icon {
    switch (this) {
      case IsmChatFocusMenuType.info:
        return Icons.info_outline_rounded;
      case IsmChatFocusMenuType.reply:
        return Icons.reply_rounded;
      case IsmChatFocusMenuType.forward:
        return Icons.shortcut_rounded;
      case IsmChatFocusMenuType.copy:
        return Icons.copy_rounded;
      case IsmChatFocusMenuType.delete:
        return Icons.delete_outline_rounded;
      case IsmChatFocusMenuType.selectMessage:
        return Icons.select_all_rounded;
    }
  }
}

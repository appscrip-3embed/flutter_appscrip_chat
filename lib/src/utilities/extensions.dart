import 'dart:math';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

extension ScaffoldExtenstion on Scaffold {
  Widget withUnfocusGestureDetctor(BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: this,
      );
}

extension NullCheck<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

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
    if (this == 0 || this == -1) {
      return '';
    }
    final timeStamp = toDate().removeTime();
    final now = DateTime.now().removeTime();

    if (now.day == timeStamp.day) {
      return '${IsmChatStrings.lastSeen} ${IsmChatStrings.today} ${IsmChatStrings.at} ${DateFormat.jm().format(toDate())}';
    }
    if (now.difference(timeStamp) <= const Duration(days: 1)) {
      return '${IsmChatStrings.lastSeen} ${IsmChatStrings.yestarday} ${IsmChatStrings.at} ${DateFormat.jm().format(toDate())}';
    }
    if (now.difference(timeStamp) <= const Duration(days: 7)) {
      return '${IsmChatStrings.lastSeen} ${IsmChatStrings.at} ${DateFormat('E h:mm a').format(toDate())}';
    }
    return '${IsmChatStrings.lastSeen} ${IsmChatStrings.on} ${DateFormat('MMM d, yyyy h:mm a').format(toDate())}';
  }

  String toLastMessageTimeString() {
    if (this == 0 || this == -1) {
      return '';
    }
    final timeStamp = toDate().removeTime();
    final now = DateTime.now().removeTime();
    if (now.day == timeStamp.day) {
      return DateFormat.jm().format(toDate());
    }
    if (now.difference(timeStamp) <= const Duration(days: 1)) {
      return IsmChatStrings.yestarday.capitalizeFirst!;
    }
    return DateFormat('dd/MM/yyyy').format(toDate());
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
    if (this == 0 || this == -1) {
      return '';
    }
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

  // String toMessageMonthString() {
  //   if (this == 0 || this == -1) {
  //     return '';
  //   }
  //   var now = DateTime.now();
  //   var date = toDate();
  //   if (now.isSameMonth(date)) {
  //     return 'This Month';
  //   }
  //     late DateFormat dateFormat;
  //     dateFormat = DateFormat('yMMMM');
  //     return dateFormat.format(date);
  // }

  String toMessageMonthString() {
    if (this == 0 || this == -1) {
      return '';
    }
    var now = DateTime.now();
    var date = toDate();

    if (now.isSameDay(date)) {
      return 'Today';
    } else if (now.difference(date) < const Duration(days: 8)) {
      return date.weekday.weekDayString;
    }
    return date.toDateString();
  }

  String get deliverTime {
    if (this == 0 || this == -1) {
      return '';
    }
    var now = DateTime.now();
    var timestamp = toDate();
    late DateFormat dateFormat;
    if (now.difference(timestamp) > const Duration(days: 365)) {
      dateFormat = DateFormat('EEEE, MMM d, yyyy');
    } else if (now.difference(timestamp) > const Duration(days: 7)) {
      dateFormat = DateFormat('E, d MMM yyyy, h:mm aa');
    } else {
      dateFormat = DateFormat('EEEE h:mm aa');
    }

    return dateFormat.format(timestamp);
  }
}

extension DateFormats on DateTime {
  String toTimeString() => DateFormat.jm().format(this);

  bool isSameDay(DateTime other) => isSameMonth(other) && day == other.day;

  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  String toDateString() => DateFormat('dd MMM yyyy').format(this);

  DateTime removeTime() => DateTime(year, month, day);
}

extension ChildWidget on IsmChatCustomMessageType {
  Widget messageType(IsmChatMessageModel message) {
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

      case IsmChatCustomMessageType.conversationCreated:
        return IsmChatConversationCreatedMessage(message);

      case IsmChatCustomMessageType.removeMember:
        return IsmChatAddRemoveMember(message, isAdded: false);

      case IsmChatCustomMessageType.addMember:
        return IsmChatAddRemoveMember(message);

      case IsmChatCustomMessageType.addAdmin:
        return IsmChatAddRevokeAdmin(message);

      case IsmChatCustomMessageType.removeAdmin:
        return IsmChatAddRevokeAdmin(message, isAdded: false);

      case IsmChatCustomMessageType.memberLeave:
        return IsmChatAddRemoveMember(message, didLeft: true);
    }
  }

  bool get canCopy => [
        IsmChatCustomMessageType.text,
        IsmChatCustomMessageType.link,
        IsmChatCustomMessageType.location,
        IsmChatCustomMessageType.reply,
      ].contains(this);
}

extension LastMessageWidget on String {
  Widget lastMessageType(LastMessageDetails message) {
    switch (this) {
      case 'Image':
        return Row(
          children: [
            Icon(
              Icons.image,
              size: IsmChatDimens.sixteen,
            ),
            IsmChatDimens.boxWidth2,
            Text(
              'Image',
              style: IsmChatStyles.w400Black12,
            )
          ],
        );

      case 'Video':
        return Row(
          children: [
            Icon(
              Icons.video_call,
              size: IsmChatDimens.sixteen,
            ),
            IsmChatDimens.boxWidth2,
            Text(
              'Video',
              style: IsmChatStyles.w400Black12,
            )
          ],
        );

      case 'Audio':
        return Row(
          children: [
            Icon(
              Icons.audio_file,
              size: IsmChatDimens.sixteen,
            ),
            IsmChatDimens.boxWidth2,
            Text(
              'Audio',
              style: IsmChatStyles.w400Black12,
            )
          ],
        );

      case 'Document':
        return Row(
          children: [
            Icon(
              Icons.file_copy_outlined,
              size: IsmChatDimens.sixteen,
            ),
            IsmChatDimens.boxWidth2,
            Text(
              'Document',
              style: IsmChatStyles.w400Black12,
            )
          ],
        );
    }
    if (contains('https://www.google.com/maps/')) {
      return Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: IsmChatDimens.sixteen,
          ),
          IsmChatDimens.boxWidth2,
          Text(
            'Location',
            style: IsmChatStyles.w400Black12,
          )
        ],
      );
    }
    return Text(
      message.body,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: IsmChatStyles.w400Black12,
    );
  }
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

extension SelectedUsers on List<SelectedForwardUser> {
  List<SelectedForwardUser> get selectedUsers =>
      where((e) => e.isUserSelected).toList();
}

extension UniqueElements<T> on List<T> {
  List<T> unique() => [
        ...{...this}
      ];
}

extension ModelConversion on IsmChatConversationModel {
  IsmChatMqttController get _mqttController =>
      Get.find<IsmChatMqttController>();

  DBConversationModel convertToDbModel(List<String>? messages) =>
      DBConversationModel(
        conversationId: conversationId,
        conversationImageUrl: conversationImageUrl,
        conversationTitle: conversationTitle,
        isGroup: isGroup,
        lastMessageSentAt: lastMessageSentAt,
        messagingDisabled: messagingDisabled,
        membersCount: membersCount,
        unreadMessagesCount: unreadMessagesCount,
        messages: messages ?? [],
      );

  String get typingUsers {
    var users = _mqttController.typingUsers
        .where(
          (u) => u.conversationId == conversationId,
        )
        .toList()
        .unique();
    users.sort(
      (a, b) => a.userName.toLowerCase().compareTo(b.userName.toLowerCase()),
    );

    return isGroup!
        ? '${users.map((e) => e.userName).join(', ')} is ${IsmChatStrings.typing}'
        : IsmChatStrings.typing;
  }

  bool get isSomeoneTyping => _mqttController.typingUsers
      .map((e) => e.conversationId)
      .contains(conversationId);

  Widget get sender {
    if (!isGroup! ||
        lastMessageDetails!.messageBody.isEmpty ||
        [IsmChatCustomMessageType.memberLeave]
            .contains(lastMessageDetails!.customType)) {
      return const SizedBox.shrink();
    }

    var senderName =
        lastMessageDetails!.sentByMe ? 'You' : lastMessageDetails!.senderName;

    return Text(
      '$senderName: ',
      style: IsmChatStyles.w500Black12,
    );
  }

  Widget get readCheck {
    try {
      if (!lastMessageDetails!.sentByMe ||
          lastMessageDetails!.messageBody.isEmpty ||
          lastMessageDetails!.customType == IsmChatCustomMessageType.unblock ||
          lastMessageDetails!.customType == IsmChatCustomMessageType.block ||
          lastMessageDetails!.customType ==
              IsmChatCustomMessageType.deletedForEveryone ||
          [IsmChatCustomMessageType.addMember]
              .contains(lastMessageDetails!.customType)) {
        return const SizedBox.shrink();
      }
      var deliveredToAll = false;
      var readByAll = false;
      if (!isGroup!) {
        // this means not recieved by the user
        if (lastMessageDetails?.deliverCount != 0) {
          deliveredToAll = true;
          // this means not read by the user
          if (lastMessageDetails?.readCount != 0) {
            readByAll = true;
          }
        }
      } else {
        if (membersCount == lastMessageDetails?.deliverCount) {
          deliveredToAll = true;
          if (membersCount == lastMessageDetails?.readCount) {
            readByAll = true;
          }
        }
      }

      return Icon(
        deliveredToAll ? Icons.done_all_rounded : Icons.done_rounded,
        color: readByAll ? Colors.blue : Colors.grey,
        size: 16,
      );
    } catch (e, st) {
      IsmChatLog.error(e, st);
      return const SizedBox.shrink();
    }
  }
}

extension LastMessageBody on LastMessageDetails {
  String get messageBody {
    switch (customType) {
      case IsmChatCustomMessageType.reply:
        return 'Replied to $body';
      case IsmChatCustomMessageType.image:
        return 'Image';
      case IsmChatCustomMessageType.video:
        return 'Video';
      case IsmChatCustomMessageType.audio:
        return 'Audio';
      case IsmChatCustomMessageType.file:
        return 'File';
      case IsmChatCustomMessageType.location:
        return 'Location';
      case IsmChatCustomMessageType.block:
        return 'Blocked';
      case IsmChatCustomMessageType.unblock:
        return 'Unblocked';
      case IsmChatCustomMessageType.conversationCreated:
        return 'Conversation created';
      case IsmChatCustomMessageType.removeMember:
        return 'Removed ${(members ?? []).join(', ')}';
      case IsmChatCustomMessageType.addMember:
        return 'Added ${(members ?? []).join(', ')}';
      case IsmChatCustomMessageType.addAdmin:
        return '';
      case IsmChatCustomMessageType.removeAdmin:
        return '';
      case IsmChatCustomMessageType.memberLeave:
        return '$senderName left';
      case IsmChatCustomMessageType.deletedForMe:
      case IsmChatCustomMessageType.deletedForEveryone:
        return sentByMe
            ? IsmChatStrings.deletedMessage
            : IsmChatStrings.wasDeletedMessage;
      case IsmChatCustomMessageType.link:
      case IsmChatCustomMessageType.forward:
      case IsmChatCustomMessageType.date:
      case IsmChatCustomMessageType.text:
      default:
        var isReacted = action == IsmChatActionEvents.reactionAdd.name;
        return reactionType?.isNotEmpty == true
            ? sentByMe
                ? 'You ${isReacted ? 'reacted' : 'removed'} ${reactionType?.reactionString} ${isReacted ? 'to' : 'from'} a message'
                : '${isReacted ? 'Reacted' : 'Removed'} ${reactionType?.reactionString} ${isReacted ? 'to' : 'from'} a message'
            : body;
    }
  }

  Widget get icon {
    IconData? iconData;
    switch (customType) {
      case IsmChatCustomMessageType.reply:
        iconData = Icons.reply_rounded;
        break;
      case IsmChatCustomMessageType.image:
        iconData = Icons.image_rounded;
        break;
      case IsmChatCustomMessageType.video:
        iconData = Icons.videocam_rounded;
        break;
      case IsmChatCustomMessageType.audio:
        iconData = Icons.audiotrack_rounded;
        break;
      case IsmChatCustomMessageType.file:
        iconData = Icons.description_rounded;
        break;
      case IsmChatCustomMessageType.location:
        iconData = Icons.location_on_rounded;
        break;
      case IsmChatCustomMessageType.block:
      case IsmChatCustomMessageType.unblock:
        iconData = Icons.block_rounded;
        break;
      case IsmChatCustomMessageType.conversationCreated:
        iconData = Icons.how_to_reg_rounded;
        break;
      case IsmChatCustomMessageType.addMember:
        iconData = Icons.waving_hand_rounded;
        break;
      case IsmChatCustomMessageType.memberLeave:
        iconData = Icons.directions_walk_rounded;
        break;
      case IsmChatCustomMessageType.link:
        iconData = Icons.link_rounded;
        break;
      case IsmChatCustomMessageType.forward:
        iconData = Icons.shortcut_rounded;
        break;
      case IsmChatCustomMessageType.removeMember:
        iconData = Icons.group_remove_outlined;
        break;
      case IsmChatCustomMessageType.deletedForEveryone:
        iconData = Icons.remove_circle_outline_rounded;
        break;
      case IsmChatCustomMessageType.addAdmin:
      case IsmChatCustomMessageType.removeAdmin:
      case IsmChatCustomMessageType.deletedForMe:
      case IsmChatCustomMessageType.date:
      case IsmChatCustomMessageType.text:
      default:
    }

    if (iconData != null) {
      return Icon(
        iconData,
        size: IsmChatDimens.fifteen,
        color: IsmChatColors.blackColor,
      );
    }
    return const SizedBox.shrink();
  }
}

extension ReactionLastMessgae on String {
  String get reactionString {
    var reactionValue = IsmChatEmoji.values.firstWhere((e) => e.value == this);

    var reaction = Get.find<IsmChatConversationsController>()
        .reactions
        .firstWhere((e) => e.name == reactionValue.emojiKeyword);

    return reaction.emoji;
  }
}

extension MentionMessage on IsmChatMessageModel {
  List<LocalMention> get mentionList {
    try {
      var splitMessages = body.split('@');
      var messageList = <LocalMention>[];
      messageList.add(
        LocalMention(
          text: splitMessages.first,
          isMentioned: false,
        ),
      );
      var length = mentionedUsers!.length;

      var splitLength = splitMessages.length;

      for (var i = 0; i < length; i++) {
        var mention = mentionedUsers![i];
        messageList.add(
          LocalMention(
            text: '@${mention.userName.capitalizeFirst}',
            isMentioned: true,
          ),
        );

        if (splitLength < length || i < length) {
          messageList.add(
            LocalMention(
              text: splitMessages[i + 1]
                  .split(mention.userName.capitalizeFirst!)
                  .last,
              isMentioned: false,
            ),
          );
        }
      }
      return messageList;
    } catch (e, st) {
      IsmChatLog.error(e, st);
      return [];
    }
  }

  List<IsmChatFocusMenuType> get focusMenuList {
    var menu = [...IsmChatFocusMenuType.values];
    if (!sentByMe) {
      menu.remove(IsmChatFocusMenuType.info);
    }
    if ([
      IsmChatCustomMessageType.video,
      IsmChatCustomMessageType.image,
      IsmChatCustomMessageType.audio,
      IsmChatCustomMessageType.file
    ].contains(customType)) {
      menu.remove(IsmChatFocusMenuType.copy);
    }
    if (!IsmChatConfig.features.contains(IsmChatFeature.reply)) {
      menu.remove(IsmChatFocusMenuType.reply);
    }
    if (!IsmChatConfig.features.contains(IsmChatFeature.forward)) {
      menu.remove(IsmChatFocusMenuType.forward);
    }
    return menu;
  }

  TextStyle get style {
    var theme = IsmChatConfig.chatTheme.chatPageTheme;
    if (sentByMe) {
      return (theme?.selfMessageTheme?.textStyle ?? IsmChatStyles.w500White14)
          .copyWith(
        color: theme?.selfMessageTheme?.textColor,
      );
    }
    return (theme?.opponentMessageTheme?.textStyle ?? IsmChatStyles.w500Black14)
        .copyWith(
      color: theme?.opponentMessageTheme?.textColor,
    );
  }

  Color? get backgroundColor {
    var theme = IsmChatConfig.chatTheme.chatPageTheme;
    if (sentByMe) {
      return theme?.selfMessageTheme?.backgroundColor ??
          IsmChatConfig.chatTheme.primaryColor;
    }
    return theme?.opponentMessageTheme?.backgroundColor ??
        IsmChatConfig.chatTheme.backgroundColor;
  }

  Color? get borderColor {
    var theme = IsmChatConfig.chatTheme.chatPageTheme;
    if (sentByMe) {
      return theme?.selfMessageTheme?.borderColor ??
          IsmChatConfig.chatTheme.primaryColor;
    }
    return theme?.opponentMessageTheme?.borderColor ??
        IsmChatConfig.chatTheme.backgroundColor;
  }
}

extension SizeOfMedia on String {
  bool size({double limit = 20}) {
    if ((double.parse(split(' ').first) >= limit) ||
        (split(' ').last == 'KB')) {
      return true;
    }

    return false;
  }
}

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IsmChatRouteManagement {
  const IsmChatRouteManagement._();

  static void goToChatPage() {
    Get.toNamed(IsmChatPageView.route);
  }

  static void goToBroadcastMessagePage() {
    Get.toNamed(IsmChatBoradcastMessagePage.route);
  }

  static void goToCreateChat({required bool isGroupConversation}) {
    Get.toNamed(IsmChatCreateConversationView.route,
        arguments: {'isGroupConversation': isGroupConversation});
  }

  static void goToBlockView() {
    Get.toNamed(IsmChatBlockedUsersView.route);
  }

  static void goToForwardView(
      {required IsmChatMessageModel message,
      required IsmChatConversationModel conversation}) {
    Get.toNamed(IsmChatForwardView.route,
        arguments: {'message': message, 'conversation': conversation});
  }

  static void goToBroadcastView() {
    Get.toNamed(IsmChatBroadCastView.route);
  }

  static void goToPublicView() {
    Get.toNamed(IsmChatPublicView.route);
  }

  static void goToConversationInfo() {
    Get.toNamed(IsmChatConverstaionInfoView.route);
  }

  static void goToEligibleUser() {
    Get.toNamed(IsmChatGroupEligibleUser.route);
  }

  static void goToLocation() {
    Get.toNamed(IsmChatLocationWidget.route);
  }

  static void goToMediaPreview({
    required List<IsmChatMessageModel> messageData,
    required String mediaUserName,
    required bool initiated,
    required int mediaTime,
    required int mediaIndex,
  }) {
    Get.toNamed(IsmMediaPreview.route, arguments: {
      'messageData': messageData,
      'mediaUserName': mediaUserName,
      'initiated': initiated,
      'mediaTime': mediaTime,
      'mediaIndex': mediaIndex,
    });
  }

  static void goToMessageInfo({
    required IsmChatMessageModel? message,
    required bool? isGroup,
  }) {
    Get.toNamed(IsmChatMessageInfo.route, arguments: {
      'message': message,
      'isGroup': isGroup,
    });
  }

  static void goToUserInfo(
      {required UserDetails user, required String conversationId}) {
    Get.toNamed(
      IsmChatUserInfo.route,
      arguments: {'user': user, 'conversationId': conversationId},
    );
  }

  static void goToMedia(
      {required List<IsmChatMessageModel>? mediaList,
      required List<IsmChatMessageModel>? mediaListLinks,
      required List<IsmChatMessageModel>? mediaListDocs,
      d}) {
    Get.toNamed(
      IsmMedia.route,
      arguments: {
        'mediaList': mediaList,
        'mediaListLinks': mediaListLinks,
        'mediaListDocs': mediaListDocs
      },
    );
  }

  static void goToWallpaperPreview(
      {required String? backgroundColor,
      required XFile? imagePath,
      required int? assetSrNo}) {
    Get.toNamed(IsmChatWallpaperPreview.route, arguments: {
      'backgroundColor': backgroundColor,
      'imagePath': imagePath,
      'assetSrNo': assetSrNo
    });
  }

  static void goToWebMediaMessagePreview({
    required List<IsmChatMessageModel>? messageData,
    required String? mediaUserName,
    required bool? initiated,
    required int? mediaTime,
    final int? mediaIndex,
  }) {
    Get.toNamed(IsmWebMessageMediaPreview.route, arguments: {
      'messageData': messageData,
      'mediaUserName': mediaUserName,
      'mediaTime': mediaTime,
      'mediaIndex': mediaIndex,
    });
  }

  static void goToWebMediaPreview() {
    Get.toNamed(
      WebMediaPreview.route,
    );
  }

  static void goToCameraView() {
    Get.toNamed(
      IsmChatCameraView.route,
    );
  }

  static void goToContactView() {
    Get.toNamed(IsmChatContactView.route);
  }

  static void goToContactInfoView({required List<Contact> contacts}) {
    Get.toNamed(
      IsmChatContactsInfoView.route,
      arguments: {'contacts': contacts},
    );
  }

  static void goToSearchMessageView() {
    Get.toNamed(IsmChatSearchMessgae.route);
  }
}

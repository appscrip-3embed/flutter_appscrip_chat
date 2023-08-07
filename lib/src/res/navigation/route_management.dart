import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatRouteManagement {
  const IsmChatRouteManagement._();

  static void goToChatPage() {
    Get.toNamed(IsmChatPageView.route);
  }

  static void goToCreateChat() {
    Get.toNamed(IsmChatCreateConversationView.route);
  }

  static void goToForwardView() {
    Get.toNamed(IsmChatForwardView.route);
  }

  static void goToBlockView() {
    Get.toNamed(IsmChatBlockedUsersView.route);
  }

  static void goToConversationInfo() {
    Get.toNamed(IsmChatConverstaionInfoView.route);
  }

  static void goToEligibleUser() {
    Get.toNamed(IsmChatGroupEligibleUser.route);
  }

  static void goToMediaPreview() {
    Get.toNamed(IsmMediaPreview.route);
  }

  static void goToMessageInfo() {
    Get.toNamed(IsmChatMessageInfo.route);
  }

  static void goToUserInfo() {
    Get.toNamed(IsmChatUserInfo.route);
  }

  static void goToWallpaperPreview() {
    Get.toNamed(IsmChatWallpaperPreview.route);
  }
}

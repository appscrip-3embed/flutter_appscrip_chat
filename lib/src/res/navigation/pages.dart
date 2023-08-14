import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/views/views.dart';
import 'package:get/get.dart';

class IsmChatPages {
  static final pages = [
    GetPage(
      name: IsmChatConversations.route,
      page: IsmChatConversations.new,
      binding: IsmChatConversationsBinding(),
    ),
    GetPage(
      name: IsmChatPageView.route,
      page: IsmChatPageView.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatCreateConversationView.route,
      page: IsmChatCreateConversationView.new,
      binding: IsmChatConversationsBinding(),
    ),
    GetPage(
      name: IsmChatForwardView.route,
      page: IsmChatForwardView.new,
      binding: IsmChatConversationsBinding(),
    ),
    GetPage(
      name: IsmChatBlockedUsersView.route,
      page: IsmChatBlockedUsersView.new,
      binding: IsmChatConversationsBinding(),
    ),
    GetPage(
      name: IsmChatConverstaionInfoView.route,
      page: IsmChatConverstaionInfoView.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatGroupEligibleUser.route,
      page: IsmChatGroupEligibleUser.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmMediaPreview.route,
      page: IsmMediaPreview.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatMessageInfo.route,
      page: IsmChatMessageInfo.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatUserInfo.route,
      page: IsmChatUserInfo.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatWallpaperPreview.route,
      page: IsmChatWallpaperPreview.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmMedia.route,
      page: IsmMedia.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatLocationWidget.route,
      page: IsmChatLocationWidget.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmWebMessageMediaPreview.route,
      page: IsmWebMessageMediaPreview.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: WebMediaPreview.route,
      page: WebMediaPreview.new,
      binding: IsmChatPageBinding(),
    ),
    GetPage(
      name: IsmChatCameraView.route,
      page: IsmChatCameraView.new,
      binding: IsmChatPageBinding(),
    ),
  ];
}

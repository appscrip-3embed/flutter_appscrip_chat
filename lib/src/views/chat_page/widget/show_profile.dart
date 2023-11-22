import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatProfilePicView extends StatelessWidget {
  IsmChatProfilePicView({super.key});

  static const String route = IsmPageRoutes.profilePicView;

  final argument = Get.arguments as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    final user = argument['user'] as UserDetails;
    return Scaffold(
      backgroundColor: IsmChatColors.blackColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: IsmChatColors.whiteColor,
            )),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: IsmChatColors.blackColor,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: IsmChatColors.blackColor,
        title: Text(
          user.userName,
          style: IsmChatStyles.w600White18,
        ),
      ),
      body: Center(
        child: Image.network(user.profileUrl),
      ),
    );
  }
}

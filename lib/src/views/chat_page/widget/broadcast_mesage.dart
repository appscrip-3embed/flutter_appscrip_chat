import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:appscrip_chat_component/src/views/views.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBoradcastMessagePage extends StatelessWidget {
  const IsmChatBoradcastMessagePage({super.key});

  static const String route = IsmPageRoutes.boradCastMessagePage;

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
      builder: (controller) => Scaffold(
            appBar: AppBar(
              leading: IsmChatTapHandler(
                onTap: Get.back,
                child: Icon(
                  Responsive.isWebAndTablet(context)
                      ? Icons.close_rounded
                      : Icons.arrow_back_rounded,
                ),
              ),
              titleSpacing: IsmChatDimens.four,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: IsmChatDimens.forty,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(IsmChatDimens.fifty),
                      child: Image.asset(
                        IsmChatAssets.noImage,
                      ),
                    ),
                  ),
                  IsmChatDimens.boxWidth12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.conversation?.chatName ?? '',
                          style: IsmChatConfig
                                  .chatTheme.chatPageHeaderTheme?.titleStyle ??
                              IsmChatStyles.w600White16,
                        ),
                        Text(
                          (controller.conversation?.members ?? [])
                              .map((e) => e.userName)
                              .join(','),
                          style: IsmChatConfig.chatTheme.chatPageHeaderTheme
                                  ?.subtileStyle ??
                              IsmChatStyles.w400White12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: IsmChatConfig.chatTheme.primaryColor,
              iconTheme: const IconThemeData(color: IsmChatColors.whiteColor),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: controller.conversation?.members?.length ?? 0,
                  itemBuilder: (_, index) {
                    var data = controller.conversation?.members?[index];
                    return ListTile(
                      leading:
                          IsmChatImage.profile(data?.userProfileImageUrl ?? ''),
                      title: Text(
                        data?.userName ?? '',
                      ),
                      subtitle: Text(data?.userIdentifier ?? ''),
                    );
                  },
                )),
                Container(
                  padding:
                      IsmChatConfig.chatTheme.chatPageTheme?.textfieldInsets,
                  decoration: IsmChatConfig
                      .chatTheme.chatPageTheme?.textfieldDecoration,
                  child: const SafeArea(
                    child: IsmChatMessageField(),
                  ),
                ),
              ],
            ),
          ));
}

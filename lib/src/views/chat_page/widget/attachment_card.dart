import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//TODO: Refactor Attachment Bottom sheet UI
class IsmChatAttachmentCard extends StatelessWidget {
  const IsmChatAttachmentCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: IsmChatDimens.edgeInsets10,
        decoration: BoxDecoration(
          color: IsmChatColors.whiteColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.twentyFour),
        ),
        padding: IsmChatDimens.edgeInsets10,
        height: 250,
        alignment: Alignment.center,
        child: GetBuilder<IsmChatPageController>(
          builder: (controller) => GridView.builder(
            itemCount: controller.attachments.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: IsmChatDimens.eight,
              mainAxisSpacing: IsmChatDimens.four,
            ),
            itemBuilder: (_, index) {
              var attachment = controller.attachments[index];
              return IsmChatTapHandler(
                onTap: () => controller
                    .onBottomAttachmentTapped(attachment.attachmentType),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: IsmChatDimens.fifty,
                      width: IsmChatDimens.fifty,
                      decoration: BoxDecoration(
                        color: attachment.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        attachment.icon,
                        color: IsmChatColors.whiteColor,
                      ),
                    ),
                    IsmChatDimens.boxHeight4,
                    Text(
                      attachment.label,
                      style: IsmChatStyles.w400Black14,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
}

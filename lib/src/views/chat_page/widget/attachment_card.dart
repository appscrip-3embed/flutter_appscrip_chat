import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatAttachmentCard extends StatelessWidget {
  const IsmChatAttachmentCard(this.attachments, {super.key});

  final List<IsmChatAttachmentType> attachments;

  double getWidgetHight() {
    var maxPerLine = IsmChatConfig.attachmentConfig?.attachmentShowperLine ??
        IsmChatConstants.attachmentShowLine;
    var height = IsmChatConfig.attachmentConfig?.attachmentHight ??
        IsmChatConstants.attachmentShowLine;
    var result = (attachments.length / maxPerLine).ceil();
    return (result * height).toDouble();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Container(
          margin: IsmChatDimens.edgeInsets10,
          decoration: BoxDecoration(
            color: IsmChatColors.whiteColor,
            borderRadius: BorderRadius.circular(IsmChatDimens.twentyFour),
          ),
          padding: IsmChatDimens.edgeInsets10,
          height: getWidgetHight(),
          alignment: Alignment.center,
          child: GetBuilder<IsmChatPageController>(
            builder: (controller) {
              var allowedAttachments = controller.attachments
                  .where((e) => attachments.contains(e.attachmentType))
                  .toList();
              return GridView.builder(
                itemCount: allowedAttachments.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: IsmChatDimens.eight,
                  mainAxisSpacing: IsmChatDimens.four,
                ),
                itemBuilder: (_, index) {
                  var attachment = allowedAttachments[index];
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
              );
            },
          ),
        ),
      );
}

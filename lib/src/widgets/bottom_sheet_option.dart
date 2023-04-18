import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBottomSheet extends StatelessWidget {
  const IsmChatBottomSheet({
    super.key,
    required this.onClearTap,
    required this.onDeleteTap,
  });

  final VoidCallback onClearTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmChatDimens.edgeInsetsBottom10,
        child: Container(
          margin: IsmChatDimens.edgeInsets10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: IsmChatColors.whiteColor,
                  borderRadius: BorderRadius.circular(IsmChatDimens.twenty),
                ),
                padding: IsmChatDimens.edgeInsets20,
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back<void>();
                        onClearTap.call();
                      },
                      child: Text(
                        IsmChatStrings.clearChat,
                        overflow: TextOverflow.ellipsis,
                        style: IsmChatStyles.w600Black16,
                      ),
                    ),
                    IsmChatDimens.boxHeight16,
                    InkWell(
                      onTap: () {
                        Get.back<void>();
                        onDeleteTap.call();
                      },
                      child: Text(
                        IsmChatStrings.deleteChat,
                        overflow: TextOverflow.ellipsis,
                        style: IsmChatStyles.w600Black16,
                      ),
                    ),
                  ],
                ),
              ),
              IsmChatDimens.boxHeight4,
              InkWell(
                onTap: Get.back,
                child: Container(
                  padding: IsmChatDimens.edgeInsets10,
                  decoration: BoxDecoration(
                    color: IsmChatColors.whiteColor,
                    borderRadius: BorderRadius.circular(IsmChatDimens.twenty),
                  ),
                  child: Center(
                    child: Text(
                      IsmChatStrings.cancel,
                      style: IsmChatStyles.w600Black16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

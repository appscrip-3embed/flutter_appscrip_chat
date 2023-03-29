import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatBottomSheetOption extends StatelessWidget {
  const IsmChatBottomSheetOption(
      {super.key, required this.tapFristTitle, required this.tapSecondTitle});

  final void Function() tapFristTitle;
  final void Function() tapSecondTitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmChatDimens.edgeInsetsBottom10,
        child: Container(
          height: 160,
          margin: IsmChatDimens.egdeInsets10,
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(
                    color: IsmChatColors.whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: IsmChatDimens.egdeInsets20,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back<void>();
                          tapFristTitle.call();
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
                          tapSecondTitle.call();
                        },
                        child: Text(
                          IsmChatStrings.deleteChat,
                          overflow: TextOverflow.ellipsis,
                          style: IsmChatStyles.w600Black16,
                        ),
                      ),
                    ],
                  )),
              IsmChatDimens.boxHeight4,
              InkWell(
                onTap: () {
                  Get.back<void>();
                },
                child: Container(
                  padding: IsmChatDimens.egdeInsets10,
                  decoration: const BoxDecoration(
                    color: IsmChatColors.whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  // height: 55,
                  child: Center(
                    child: Text(
                      IsmChatStrings.cancel,
                      style: IsmChatStyles.w600Black16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

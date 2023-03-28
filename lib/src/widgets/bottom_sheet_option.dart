import 'package:appscrip_chat_component/src/models/chat_conversation_model.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetOption extends StatelessWidget {
  const BottomSheetOption(
      {super.key, required this.tapFristTitle, required this.tapSecondTitle});

  final void Function() tapFristTitle;
  final void Function() tapSecondTitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: ChatDimens.edgeInsetsBottom10,
        child: Container(
          height: 160,
          margin: ChatDimens.egdeInsets10,
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(
                    color: ChatColors.whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  padding: ChatDimens.egdeInsets20,
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
                          ChatStrings.clearChat,
                          overflow: TextOverflow.ellipsis,
                          style: ChatStyles.w600Black16,
                        ),
                      ),
                      ChatDimens.boxHeight16,
                      InkWell(
                        onTap: () {
                          Get.back<void>();
                          tapSecondTitle.call();
                        },
                        child: Text(
                          ChatStrings.deleteChat,
                          overflow: TextOverflow.ellipsis,
                          style: ChatStyles.w600Black16,
                        ),
                      ),
                    ],
                  )),
              ChatDimens.boxHeight4,
              InkWell(
                onTap: () {
                  Get.back<void>();
                },
                child: Container(
                  padding: ChatDimens.egdeInsets10,
                  decoration: const BoxDecoration(
                    color: ChatColors.whiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  // height: 55,
                  child: Center(
                    child: Text(
                      ChatStrings.cancel,
                      style: ChatStyles.w600Black16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

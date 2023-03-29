import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatAlertDialogBox extends StatelessWidget {
  const IsmChatAlertDialogBox(
      {super.key,
      required this.onTapFunction,
      required this.subTitleOne,
      required this.subTitleTwo,
      required this.titile,
      this.subTitleThree,
      this.onTapFunctionTwo,
      this.threeAction = true});

  final void Function() onTapFunction;
  final void Function()? onTapFunctionTwo;
  final String titile;
  final String subTitleOne;
  final String subTitleTwo;
  final String? subTitleThree;
  final bool threeAction;

  @override
  Widget build(BuildContext context) => threeAction
      ? AlertDialog(
          actionsPadding: IsmChatDimens.egdeInsets16,
          title: Text(titile),
          backgroundColor: IsmChatColors.whiteColor,
          titleTextStyle: IsmChatStyles.w600Black14,
          actions: [
            IsmChatTapHandler(
              onTap: () {
                Get.back<void>();
              },
              child: Text(subTitleOne, style: IsmChatStyles.w400Black14),
            ),
            IsmChatDimens.boxWidth8,
            IsmChatTapHandler(
                onTap: () {
                  Get.back<void>();
                  onTapFunction.call();
                },
                child: Text(subTitleTwo, style: IsmChatStyles.w400Black14)),
          ],
          // content: Text("Saved successfully"),
        )
      : SimpleDialog(
          title: Text(
            titile,
            style: IsmChatStyles.w600Black14,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SimpleDialogOption(
                  child: IsmChatTapHandler(
                    onTap: () {
                      Get.back<void>();
                      onTapFunction.call();
                    },
                    child: Text(subTitleOne),
                  ),
                ),
                SimpleDialogOption(
                  child: IsmChatTapHandler(
                    onTap: () {
                      Get.back<void>();

                      onTapFunctionTwo?.call();
                    },
                    child: Text(subTitleTwo),
                  ),
                ),
                SimpleDialogOption(
                  child: IsmChatTapHandler(
                    onTap: () {
                      Get.back<void>();
                    },
                    child: Text(subTitleThree ?? ''),
                  ),
                ),
              ],
            )
          ],
        );
}

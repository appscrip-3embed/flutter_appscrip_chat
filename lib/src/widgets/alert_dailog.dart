import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertDialogBox extends StatelessWidget {
  const AlertDialogBox(
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
          actionsPadding: ChatDimens.egdeInsets16,
          title: Text(titile),
          backgroundColor: ChatColors.whiteColor,
          titleTextStyle: ChatStyles.w600Black14,
          actions: [
            IsmTapHandler(
              onTap: () {
                Get.back<void>();
              },
              child: Text(subTitleOne, style: ChatStyles.w400Black14),
            ),
            ChatDimens.boxWidth8,
            IsmTapHandler(
                onTap: () {
                  Get.back<void>();
                  onTapFunction.call();
                },
                child: Text(subTitleTwo, style: ChatStyles.w400Black14)),
          ],
          // content: Text("Saved successfully"),
        )
      : SimpleDialog(
          title: Text(
            titile,
            style: ChatStyles.w600Black14,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SimpleDialogOption(
                  child: IsmTapHandler(
                    onTap: () {
                      Get.back<void>();
                      onTapFunction.call();
                    },
                    child: Text(subTitleOne),
                  ),
                ),
                SimpleDialogOption(
                  child: IsmTapHandler(
                    onTap: () {
                      Get.back<void>();

                      onTapFunctionTwo?.call();
                    },
                    child: Text(subTitleTwo),
                  ),
                ),
                SimpleDialogOption(
                  child: IsmTapHandler(
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

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertDialogBox extends StatelessWidget {
  const AlertDialogBox({super.key, required this.onTapFunction,required this.actionOneString,required this.actionSecondString, required this.titile});

  final void Function() onTapFunction;
  final String titile;
  final String actionOneString;
  final String actionSecondString;

  @override
  Widget build(BuildContext context) => AlertDialog(
        actionsPadding: ChatDimens.egdeInsets16,
        title:  Text(titile),
        backgroundColor: ChatColors.whiteColor,
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: ChatColors.blackColor,
            fontSize: ChatDimens.twenty),
        actions: [
          InkWell(
            onTap: () {
              Get.back<void>();
            },
            child: Text(actionOneString, style: ChatStyles.w400Black14),
          ),
          ChatDimens.boxWidth8,
          InkWell(
              onTap: () {
                onTapFunction();
                Get.back<void>();
              },
              child:
                  Text(actionSecondString, style: ChatStyles.w400Black14)),
        ],
        // content: Text("Saved successfully"),
      );
}

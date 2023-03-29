import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatAlertDialogBox extends StatelessWidget {
  const IsmChatAlertDialogBox({
    super.key,
    this.titile = 'Are you sure?',
    required this.actionLabels,
    required this.callbackActions,
    this.cancelLabel = IsmChatStrings.cancel,
    this.onCancel,
  }) : assert(
          actionLabels.length == callbackActions.length &&
              actionLabels.length != 0,
          'Atleast one callback action and action label must be passed\n And number of actionLabels must be equal to number of callbackActions',
        );

  final String titile;
  final List<String> actionLabels;
  final List<VoidCallback> callbackActions;
  final String cancelLabel;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) => actionLabels.length <= 1
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
              child: Text(
                cancelLabel,
                style: IsmChatStyles.w400Black14,
              ),
            ),
            IsmChatDimens.boxWidth8,
            IsmChatTapHandler(
              onTap: () {
                Get.back<void>();
                callbackActions.first.call();
              },
              child: Text(
                actionLabels.first,
                style: IsmChatStyles.w400Black14,
              ),
            ),
          ],
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
                ...actionLabels.map<Widget>((label) {
                  var action = callbackActions[actionLabels.indexOf(label)];
                  return SimpleDialogOption(
                    child: IsmChatTapHandler(
                      onTap: () {
                        Get.back<void>();
                        action();
                      },
                      child: Text(label),
                    ),
                  );
                }).toList(),
                SimpleDialogOption(
                  child: IsmChatTapHandler(
                    onTap: onCancel ?? Get.back,
                    child: Text(cancelLabel),
                  ),
                ),
              ],
            )
          ],
        );
}

import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IsmChatWallpaperPreview extends StatelessWidget {
  const IsmChatWallpaperPreview({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: Get.back, icon: const Icon(Icons.arrow_back_rounded)),
          title: Text(
            'Preview',
            style: IsmChatStyles.w600Black20,
          ),
        ),
        body: Padding(
          padding: IsmChatDimens.edgeInsets10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: IsmChatDimens.edgeInsets4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(IsmChatDimens.five),
                    border: Border.all(color: IsmChatColors.greyColor),
                    color: IsmChatColors.whiteColor),
                child: Text(
                  'Today',
                  style: IsmChatStyles.w500Black14,
                ),
              ),
              IsmChatDimens.boxHeight10,
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: IsmChatDimens.percentWidth(.4),
                    padding: IsmChatDimens.edgeInsets4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(IsmChatDimens.ten),
                        bottomLeft: Radius.circular(IsmChatDimens.ten),
                        bottomRight: Radius.circular(IsmChatDimens.ten),
                      ),
                      border: Border.all(color: IsmChatColors.greyColor),
                      color: IsmChatColors.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Hiiiiii',
                          style: IsmChatStyles.w400Black14,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(
                            DateTime.now(),
                          ),
                        )
                      ],
                    )),
              ),
              IsmChatDimens.boxHeight10,
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    width: IsmChatDimens.percentWidth(.4),
                    padding: IsmChatDimens.edgeInsets4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(IsmChatDimens.ten),
                        bottomLeft: Radius.circular(IsmChatDimens.ten),
                        bottomRight: Radius.circular(IsmChatDimens.ten),
                      ),
                      border: Border.all(color: IsmChatColors.greyColor),
                      color: IsmChatColors.whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Hello....',
                          style: IsmChatStyles.w400Black14,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(
                                DateTime.now(),
                              ),
                            ),
                            const Icon(
                              Icons.done_all_rounded,
                              size: 16,
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
        bottomSheet: SafeArea(
          child: Container(
            padding: IsmChatDimens.edgeInsets4,
            margin: EdgeInsets.only(bottom: 100),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(IsmChatDimens.five),
                border: Border.all(color: IsmChatColors.greyColor),
                color: IsmChatColors.whiteColor),
            child: Text(
              'Today',
              style: IsmChatStyles.w500Black14,
            ),
          ),
        ),
      );
}

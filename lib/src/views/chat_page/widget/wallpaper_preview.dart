import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class IsmChatWallpaperPreview extends StatelessWidget {
  IsmChatWallpaperPreview(
      {super.key, String? backgroundColor, XFile? imagePath, int? assetSrNo})
      : _backgroundColor = backgroundColor ??
            (Get.arguments as Map<String, dynamic>?)?['backgroundColor'] ??
            '',
        _imagePath = imagePath ??
            (Get.arguments as Map<String, dynamic>?)?['imagePath'] ??
            XFile,
        _assetSrNo = assetSrNo ??
            (Get.arguments as Map<String, dynamic>?)?['assetSrNo'] ??
            0;

  final String? _backgroundColor;
  final XFile? _imagePath;
  final int? _assetSrNo;

  static const String route = IsmPageRoutes.wallpaperPreview;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: IsmChatConfig.chatTheme.primaryColor,
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: IsmChatColors.whiteColor,
            ),
          ),
          title: Text(
            'Preview',
            style: IsmChatStyles.w400White18,
          ),
          centerTitle: false,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: _backgroundColor?.isNotEmpty == true
                ? _backgroundColor?.toColor
                : null,
            image: _imagePath != null
                ? DecorationImage(
                    image: _imagePath!.path.contains('blob')
                        ? NetworkImage(_imagePath!.path)
                        : _imagePath!.path.contains(
                                'packages/appscrip_chat_component/assets')
                            ? AssetImage(
                                _imagePath!.path,
                              ) as ImageProvider
                            : FileImage(
                                File(_imagePath!.path),
                              ),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: IsmChatDimens.edgeInsets10_20_10_0,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: IsmChatConfig.chatTheme.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(IsmChatDimens.eight),
                        ),
                        padding: IsmChatDimens.edgeInsets8_4,
                        child: Text(
                          'Today',
                          style: IsmChatStyles.w500Black12.copyWith(
                            color: IsmChatConfig.chatTheme.primaryColor,
                          ),
                        ),
                      ),
                      IsmChatDimens.boxHeight10,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            width: IsmChatDimens.percentWidth(
                                Responsive.isWebAndTablet(context) ? .08 : .3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(IsmChatDimens.ten),
                                bottomLeft: Radius.circular(IsmChatDimens.ten),
                                bottomRight: Radius.circular(IsmChatDimens.ten),
                              ),
                              border: Border.all(
                                  color: IsmChatConfig.chatTheme.primaryColor!),
                              color: IsmChatConfig.chatTheme.backgroundColor,
                            ),
                            alignment: Alignment.centerLeft,
                            constraints: BoxConstraints(
                              minHeight:
                                  IsmChatDimens.thirtyTwo + IsmChatDimens.four,
                            ),
                            padding: IsmChatDimens.edgeInsets4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: IsmChatDimens.edgeInsetsR4
                                      .copyWith(right: 50),
                                  child: Text(
                                    'Hiiiiii',
                                    style: IsmChatStyles.w400Black14,
                                  ),
                                ),
                                Text(
                                  DateFormat('hh:mm a').format(
                                    DateTime.now(),
                                  ),
                                  style: IsmChatConfig.chatTheme.chatPageTheme
                                          ?.opponentMessageTheme?.textStyle ??
                                      IsmChatStyles.w500Black12,
                                )
                              ],
                            )),
                      ),
                      IsmChatDimens.boxHeight10,
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            width: IsmChatDimens.percentWidth(
                                Responsive.isWebAndTablet(context) ? .07 : .3),
                            padding: IsmChatDimens.edgeInsets4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(IsmChatDimens.ten),
                                  bottomLeft:
                                      Radius.circular(IsmChatDimens.ten),
                                  bottomRight:
                                      Radius.circular(IsmChatDimens.ten),
                                ),
                                color: IsmChatConfig.chatTheme.primaryColor,
                                border:
                                    Border.all(color: IsmChatColors.greyColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Hello....',
                                  style: IsmChatConfig.chatTheme.chatPageTheme
                                          ?.selfMessageTheme?.textStyle ??
                                      IsmChatStyles.w500White14,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('hh:mm a').format(
                                        DateTime.now()
                                            .add(const Duration(minutes: 1)),
                                      ),
                                      style: IsmChatConfig
                                              .chatTheme
                                              .chatPageTheme
                                              ?.selfMessageTheme
                                              ?.textStyle ??
                                          IsmChatStyles.w500White14
                                              .copyWith(fontSize: 12),
                                    ),
                                    Icon(
                                      Icons.done_all_rounded,
                                      size: IsmChatDimens.sixteen,
                                      color: Colors.blue,
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: IsmChatDimens.hundred,
                width: IsmChatDimens.percentWidth(1),
                decoration: BoxDecoration(
                  color: IsmChatColors.blackColor.withOpacity(.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(IsmChatDimens.twenty),
                    topRight: Radius.circular(IsmChatDimens.twenty),
                  ),
                ),
                child: IsmChatTapHandler(
                  onTap: () async {
                    final pageController = Get.find<IsmChatPageController>();
                    final conversationController =
                        Get.find<IsmChatConversationsController>();
                    if (_imagePath != null) {
                      IsmChatUtility.showLoader();
                      pageController.backgroundImage = _imagePath!.path;
                      pageController.backgroundColor = '';
                      if (_assetSrNo == 100) {
                        var file = _imagePath;
                        var bytes = await file?.readAsBytes();
                        var fileExtension = file?.path.split('.').last;
                        await conversationController.getPresignedUrl(
                            fileExtension!, bytes!);
                      }
                      var assetList = conversationController
                              .userDetails?.metaData?.assetList ??
                          [];
                      var assetIndex = assetList.indexWhere((e) => e.keys
                          .contains(
                              pageController.conversation?.conversationId));
                      if (assetIndex != -1) {
                        assetList[assetIndex] = {
                          '${pageController.conversation?.conversationId}':
                              IsmChatBackgroundModel(
                            isImage: true,
                            imageUrl: _assetSrNo == 100
                                ? conversationController.profileImage
                                : _imagePath!.path,
                            srNoBackgroundAssset:
                                _assetSrNo == 100 ? 100 : _assetSrNo,
                          )
                        };
                      } else {
                        assetList.add({
                          '${pageController.conversation?.conversationId}':
                              IsmChatBackgroundModel(
                            isImage: true,
                            imageUrl: _assetSrNo == 100
                                ? conversationController.profileImage
                                : _imagePath!.path,
                            srNoBackgroundAssset:
                                _assetSrNo == 100 ? 100 : _assetSrNo,
                          )
                        });
                      }
                      await conversationController.updateUserData(
                        metaData: {'assetList': assetList},
                      );

                      IsmChatUtility.closeLoader();
                    } else {
                      IsmChatUtility.showLoader();
                      pageController.backgroundColor = _backgroundColor!;
                      pageController.backgroundImage = '';
                      var assetList = conversationController
                              .userDetails?.metaData?.assetList ??
                          [];
                      var assetIndex = assetList.indexWhere((e) => e.keys
                          .contains(
                              pageController.conversation?.conversationId));

                      if (assetIndex != -1) {
                        assetList[assetIndex] = {
                          '${pageController.conversation?.conversationId}':
                              IsmChatBackgroundModel(
                            color: _backgroundColor!,
                            isImage: false,
                            srNoBackgroundAssset: _assetSrNo,
                          )
                        };
                      } else {
                        assetList.add({
                          '${pageController.conversation?.conversationId}':
                              IsmChatBackgroundModel(
                            color: _backgroundColor!,
                            isImage: false,
                            srNoBackgroundAssset: _assetSrNo,
                          )
                        });
                      }
                      await conversationController.updateUserData(
                        metaData: {'assetList': assetList},
                      );
                      IsmChatUtility.closeLoader();
                    }
                    await conversationController.getUserData(isLoading: true);
                    if (_assetSrNo != 100) Get.back();
                    Get.back();
                  },
                  child: Container(
                    padding: IsmChatDimens.edgeInsets20_15,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(IsmChatDimens.fifteen),
                      border: Border.all(color: IsmChatColors.whiteColor),
                      color: IsmChatColors.blackColor.withOpacity(.3),
                    ),
                    child: Text(
                      'Set wallpaper',
                      style: IsmChatStyles.w500White14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

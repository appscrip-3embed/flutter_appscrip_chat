// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show
        AssetEntity,
        DefaultAssetPickerBuilderDelegate,
        DefaultAssetPickerProvider;

@optionalTypeArgs
mixin GalleryPageMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);
  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    isDisplayingDetail.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  int get maxAssetsCount;

  List<AssetEntity> assets = <AssetEntity>[];

  IsmChatPickMethod get pickMethods;

  final ismChatPageController = Get.find<IsmChatPageController>();

  /// These fields are for the keep scroll position feature.
  late DefaultAssetPickerProvider keepScrollProvider =
      DefaultAssetPickerProvider();
  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  Future<void> selectAssets(IsmChatPickMethod model) async {
    final result = await model.method(context, assets);
    if (result != null) {
      for (var x in result) {
        var file = await x.file;
        if (IsmChatConstants.imageExtensions
            .contains(file!.path.split('.').last)) {
          ismChatPageController.listOfAssetsPath.add(AttachmentModel(
              mediaUrl: file.path.toString(),
              attachmentType: IsmChatMediaType.image));
        } else {
          var thumbTempPath = await VideoCompress.getFileThumbnail(
              file.path.toString(),
              quality: 50,
              position: -1);
          // var videoCompressPath = await VideoCompress.compressVideo(
          //     file.path.toString(),
          //     quality: VideoQuality.MediumQuality);
          ismChatPageController.listOfAssetsPath.add(AttachmentModel(
              thumbnailUrl: thumbTempPath.path,
              mediaUrl: file.path.toString(),
              attachmentType: IsmChatMediaType.video));
        }
      }
    } else {
      Get.back<void>();
    }
    ismChatPageController.update();
  }

  @override
  void initState() {
    selectAssets(pickMethods);
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    // ismChatPageController.keyBoardOpenOrNot = !_focus.hasFocus;
    // ismChatPageController.update();
    debugPrint('Focus: ${_focus.hasFocus.toString()}');
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) =>
      GetX<IsmChatPageController>(builder: (controller) {
        // super.build(context);
        if (controller.listOfAssetsPath.isNotEmpty) {
          return WillPopScope(
            onWillPop: () async {
              controller.listOfAssetsPath.clear();
              return true;
            },
            // shouldAddCallback: true,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                leading: InkWell(
                  child: const Icon(
                    Icons.clear,
                    color: IsmChatColors.whiteColor,
                  ),
                  onTap: () {
                    Get.back<void>();
                    controller.listOfAssetsPath.clear();
                  },
                ),
                actions: [
                  IsmChatConstants.imageExtensions.contains(controller
                          .listOfAssetsPath[controller.assetsIndex].mediaUrl!
                          .split('.')
                          .last)
                      ? Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                await controller.cropImage(File(controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .mediaUrl!));
                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(
                                        mediaUrl: controller.imagePath?.path);
                              },
                              child: const Icon(
                                Icons.crop,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                            IsmChatDimens.boxWidth16,
                            InkWell(
                              onTap: () async {
                                var mediaFile = await Get.to<File>(
                                  IsmChatImagePainterWidget(
                                    file: File(
                                      controller
                                          .listOfAssetsPath[
                                              controller.assetsIndex]
                                          .mediaUrl!,
                                    ),
                                  ),
                                );
                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(mediaUrl: mediaFile!.path);
                              },
                              child: const Icon(
                                Icons.edit,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                            IsmChatDimens.boxWidth16,
                            InkWell(
                              onTap: () {
                                controller.listOfAssetsPath
                                    .removeAt(controller.assetsIndex);
                                controller.assetsIndex =
                                    controller.listOfAssetsPath.length - 1;
                                if (controller.listOfAssetsPath.isEmpty) {
                                  controller.assetsIndex = 0;
                                  Get.back<void>();
                                }
                              },
                              child: const Icon(
                                Icons.delete_forever,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                          ],
                        )
                      : Row(
                        children: [
                          // Todo add  video trimmer
                          // IconButton(
                          //     onPressed: ()  async{
                          //     var mediaFile = await Get.to<File>(    IsmVideoTrimmerView(
                          //   index: controller.assetsIndex,
                          //   file: File(
                          //     controller
                          //         .listOfAssetsPath[controller.assetsIndex]
                          //         .mediaUrl
                          //         .toString(),
                          //   ),
                          //   durationInSeconds: 30,
                          //   showButtonVolumnClose: false,
                          // ));
                          //  controller.listOfAssetsPath[
                          //           controller
                          //               .assetsIndex] = controller
                          //           .listOfAssetsPath[controller.assetsIndex]
                          //           .copyWith(mediaUrl: mediaFile!.path);
                          //     },
                          //     icon: const Icon(
                          //       Icons.content_cut_rounded,
                          //       color: IsmChatColors.whiteColor,
                          //     ),
                          //   ),

                          IconButton(
                              onPressed: () {
                                controller.listOfAssetsPath
                                    .removeAt(controller.assetsIndex);
                                controller.assetsIndex =
                                    controller.listOfAssetsPath.length - 1;
                                if (controller.listOfAssetsPath.isEmpty) {
                                  controller.assetsIndex = 0;
                                  Get.back<void>();
                                }
                              },
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                        ],
                      ),
                  IsmChatDimens.boxWidth20
                ],
              ),
              backgroundColor: IsmChatColors.blackColor,
              body: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    IsmChatConstants.imageExtensions.contains(controller
                            .listOfAssetsPath[controller.assetsIndex].mediaUrl!
                            .split('.')
                            .last)
                        ? SizedBox(
                            height: IsmChatDimens.percentHeight(1),
                            child: Image.file(
                              File(controller
                                  .listOfAssetsPath[controller.assetsIndex]
                                  .mediaUrl
                                  .toString()),
                              fit: BoxFit.contain,
                            ),
                          )
                        :
                       
                    VideoViewPage(
                        showVideoPlaying: true,
                        path: controller
                            .listOfAssetsPath[controller.assetsIndex]
                            .mediaUrl
                            .toString(),
                      ),
                    Positioned(
                      bottom: IsmChatDimens.ten,
                      child: Container(
                        width: Get.width,
                        alignment: Alignment.center,
                        height: IsmChatDimens.sixty,
                        margin: IsmChatDimens.edgeInsets10,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              IsmChatDimens.boxWidth8,
                          itemCount: controller.listOfAssetsPath.length,
                          itemBuilder: (context, index) {
                            var media = controller.listOfAssetsPath[index];
                            return InkWell(
                              onTap: () async {
                                controller.assetsIndex = index;
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: IsmChatDimens.sixty,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(IsmChatDimens.ten)),
                                        border: controller.assetsIndex == index
                                            ? Border.all(
                                                color: Get
                                                    .theme.secondaryHeaderColor,
                                                width: IsmChatDimens.two)
                                            : null),
                                    width: IsmChatDimens.sixty,
                                    child: IsmChatImage(
                                      media.attachmentType ==
                                              IsmChatMediaType.video
                                          ? media.thumbnailUrl.toString()
                                          : media.mediaUrl.toString(),
                                      isNetworkImage: false,
                                    ),
                                  ),
                                  if (media.attachmentType ==
                                      IsmChatMediaType.video)
                                    Container(
                                      alignment: Alignment.center,
                                      width: IsmChatDimens.thirtyTwo,
                                      height: IsmChatDimens.thirtyTwo,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.play_arrow,
                                          color: Colors.black),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: IsmChatDimens.eighty,
                      right: IsmChatDimens.ten,
                      child: InkWell(
                        onTap: () {
                          Get.back<void>();
                          controller.sendPhotoAndVideo();
                        },
                        child: Container(
                          margin: IsmChatDimens.edgeInsets10,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: IsmChatConfig.chatTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(IsmChatDimens.fifty))),
                          width: IsmChatDimens.fifty,
                          height: IsmChatDimens.fifty,
                          child: const Icon(
                            Icons.send,
                            color: IsmChatColors.whiteColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class IsmChatGalleryAssetsView extends StatelessWidget {
  IsmChatGalleryAssetsView({
    super.key,
  });

  static const String route = IsmPageRoutes.alleryAssetsView;

  final argument = Get.arguments['fileList'] as List<XFile?>? ?? [];

  @override
  Widget build(BuildContext context) =>
      GetX<IsmChatPageController>(initState: (state) {
        state.controller?.selectAssets(argument);
      }, builder: (controller) {
        if (controller.listOfAssetsPath.isNotEmpty) {
          return WillPopScope(
            onWillPop: () async {
              controller.listOfAssetsPath.clear();
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  controller.dataSize,
                  style: IsmChatStyles.w600White14,
                ),
                centerTitle: true,
                backgroundColor: IsmChatConfig.chatTheme.primaryColor,
                leading: InkWell(
                  child: const Icon(
                    Icons.clear,
                    color: IsmChatColors.whiteColor,
                  ),
                  onTap: () {
                    Get.back<void>();
                    controller.listOfAssetsPath.clear();
                    controller.isVideoVisible = false;
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
                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .mediaUrl!),
                                );
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
                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .mediaUrl!),
                                );
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
                                if (controller.listOfAssetsPath.isEmpty) {
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
                            IconButton(
                              onPressed: () async {
                                controller.isVideoVisible = true;
                                var mediaFile = await Get.to<File>(
                                  IsmVideoTrimmerView(
                                    index: controller.assetsIndex,
                                    file: File(
                                      controller
                                          .listOfAssetsPath[
                                              controller.assetsIndex]
                                          .mediaUrl
                                          .toString(),
                                    ),
                                    durationInSeconds: 30,
                                  ),
                                );

                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(mediaUrl: mediaFile?.path);
                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .mediaUrl!),
                                );
                              },
                              icon: const Icon(
                                Icons.content_cut_rounded,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
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
                    CarouselSlider.builder(
                      carouselController: controller.carouselController,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        final url =
                            controller.listOfAssetsPath[realIndex].mediaUrl ??
                                '';
                        return IsmChatConstants.imageExtensions.contains(
                                controller.listOfAssetsPath[realIndex].mediaUrl!
                                    .split('.')
                                    .last)
                            ? PhotoView(
                                imageProvider: url.isValidUrl
                                    ? NetworkImage(url) as ImageProvider
                                    : FileImage(File(url)),
                                loadingBuilder: (context, event) =>
                                    const IsmChatLoadingDialog(),
                                wantKeepAlive: true,
                              )
                            : VideoViewPage(
                                path: url,
                                showVideoPlaying: true,
                              );
                      },
                      options: CarouselOptions(
                        height: IsmChatDimens.percentHeight(1),
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, _) async {
                          controller.assetsIndex = index;
                          controller.isVideoVisible = false;
                          controller.dataSize = await IsmChatUtility.fileToSize(
                            File(controller
                                .listOfAssetsPath[controller.assetsIndex]
                                .mediaUrl!),
                          );
                        },
                      ),
                      itemCount: controller.listOfAssetsPath.length,
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
                                controller.isVideoVisible = false;
                                await controller.carouselController
                                    .animateToPage(index);
                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .mediaUrl!),
                                );
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
                          controller.sendMedia();
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

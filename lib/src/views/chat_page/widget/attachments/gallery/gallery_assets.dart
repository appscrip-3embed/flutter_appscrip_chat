import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class IsmChatGalleryAssetsView extends StatelessWidget {
  IsmChatGalleryAssetsView({
    super.key,
  });

  static const String route = IsmPageRoutes.alleryAssetsView;

  final argument = Get.arguments['fileList'] as List<XFile?>? ?? [];

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        initState: (state) {
          state.controller?.listOfAssetsPath.clear();
          state.controller?.selectAssets(argument);
          state.controller?.textEditingController.clear();
        },
        builder: (controller) {
          if (controller.listOfAssetsPath.isNotEmpty) {
            return 
            Scaffold(
              resizeToAvoidBottomInset: true,
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
                          .listOfAssetsPath[controller.assetsIndex]
                          .attachmentModel
                          .mediaUrl!
                          .split('.')
                          .last)
                      ? Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                await controller.cropImage(File(controller
                                        .listOfAssetsPath[
                                            controller.assetsIndex]
                                        .attachmentModel
                                        .mediaUrl ??
                                    ''));
                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(
                                  attachmentModel: controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .attachmentModel
                                      .copyWith(
                                          mediaUrl: controller.imagePath?.path),
                                );

                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                          .listOfAssetsPath[
                                              controller.assetsIndex]
                                          .attachmentModel
                                          .mediaUrl ??
                                      ''),
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
                                              .attachmentModel
                                              .mediaUrl ??
                                          '',
                                    ),
                                  ),
                                );
                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(
                                  attachmentModel: controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .attachmentModel
                                      .copyWith(mediaUrl: mediaFile?.path),
                                );
                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                          .listOfAssetsPath[
                                              controller.assetsIndex]
                                          .attachmentModel
                                          .mediaUrl ??
                                      ''),
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
                                              .attachmentModel
                                              .mediaUrl ??
                                          '',
                                    ),
                                    durationInSeconds: 30,
                                  ),
                                );

                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(
                                  attachmentModel: controller
                                      .listOfAssetsPath[controller.assetsIndex]
                                      .attachmentModel
                                      .copyWith(mediaUrl: mediaFile?.path),
                                );
                                controller.dataSize =
                                    await IsmChatUtility.fileToSize(
                                  File(controller
                                          .listOfAssetsPath[
                                              controller.assetsIndex]
                                          .attachmentModel
                                          .mediaUrl ??
                                      ''),
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
                child: CarouselSlider.builder(
                  carouselController: controller.carouselController,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    final url = controller.listOfAssetsPath[realIndex]
                            .attachmentModel.mediaUrl ??
                        '';
                    return IsmChatConstants.imageExtensions.contains(controller
                            .listOfAssetsPath[realIndex]
                            .attachmentModel
                            .mediaUrl!
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
                      controller.textEditingController.text =
                          controller.listOfAssetsPath[index].caption;
                      controller.assetsIndex = index;
                      controller.isVideoVisible = false;
                      controller.dataSize = await IsmChatUtility.fileToSize(
                        File(controller.listOfAssetsPath[controller.assetsIndex]
                                .attachmentModel.mediaUrl ??
                            ''),
                      );
                    },
                  ),
                  itemCount: controller.listOfAssetsPath.length,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: ColoredBox(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IsmChatDimens.boxHeight10,
                    Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      height: IsmChatDimens.sixty,
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
                              controller.textEditingController.text =
                                  media.caption;
                              controller.assetsIndex = index;
                              controller.isVideoVisible = false;
                              await controller.carouselController
                                  .animateToPage(index);
                              controller.dataSize =
                                  await IsmChatUtility.fileToSize(
                                File(controller
                                        .listOfAssetsPath[
                                            controller.assetsIndex]
                                        .attachmentModel
                                        .mediaUrl ??
                                    ''),
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
                                    media.attachmentModel.attachmentType ==
                                            IsmChatMediaType.video
                                        ? media.attachmentModel.thumbnailUrl ??
                                            ''
                                        : media.attachmentModel.mediaUrl ?? '',
                                    isNetworkImage: false,
                                  ),
                                ),
                                if (media.attachmentModel.attachmentType ==
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
                    Padding(
                      padding: IsmChatDimens.edgeInsets10_0,
                      child: Row(
                        children: [
                          Expanded(
                            child: IsmChatInputField(
                              fillColor: IsmChatColors.greyColor,
                              autofocus: false,
                              padding: IsmChatDimens.edgeInsets0,
                              hint: IsmChatStrings.addCaption,
                              hintStyle: IsmChatStyles.w400White16,
                              cursorColor: IsmChatColors.whiteColor,
                              style: IsmChatStyles.w400White16,
                              controller: controller.textEditingController,
                              onChanged: (value) {
                                controller.listOfAssetsPath[
                                    controller
                                        .assetsIndex] = controller
                                    .listOfAssetsPath[controller.assetsIndex]
                                    .copyWith(
                                  caption: value,
                                );
                              },
                            ),
                          ),
                          IsmChatDimens.boxWidth8,
                          IsmChatStartChatFAB(
                            onTap: () async {
                              controller.sendMedia();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: IsmChatColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
}

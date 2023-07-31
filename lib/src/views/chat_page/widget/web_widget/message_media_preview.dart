import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/utilities/blob_io.dart'
    if (dart.library.html) 'package:appscrip_chat_component/src/utilities/blob_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class IsmWebMessageMediaPreview extends StatefulWidget {
  const IsmWebMessageMediaPreview({
    Key? key,
    required this.messageData,
    required this.mediaIndex,
    required this.mediaUserName,
    required this.initiated,
    required this.mediaTime,
  }) : super(key: key);

  final List<IsmChatMessageModel> messageData;

  final String mediaUserName;

  final bool initiated;

  final int mediaTime;

  final int mediaIndex;

  @override
  State<IsmWebMessageMediaPreview> createState() =>
      _WebMessageMediaPreviewState();
}

class _WebMessageMediaPreviewState extends State<IsmWebMessageMediaPreview> {
  /// Page controller for handing the PageView pages
  PageController pageController = PageController();
  final chatPageController = Get.find<IsmChatPageController>();
  late CarouselController carouselController;

  String mediaTime = '';

  bool initiated = false;

  @override
  void initState() {
    super.initState();
    startInit();
  }

  startInit() {
    carouselController = CarouselController();
    initiated = widget.initiated;
    chatPageController.assetsIndex = widget.mediaIndex;
    final timeStamp = DateTime.fromMillisecondsSinceEpoch(widget.mediaTime);
    final time = DateFormat.jm().format(timeStamp);
    final monthDay = DateFormat.MMMd().format(timeStamp);
    mediaTime = '$monthDay, $time';
  }

  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  initiated
                      ? IsmChatStrings.you
                      : widget.mediaUserName.toString(),
                  style: IsmChatStyles.w400Black16,
                ),
                Text(
                  mediaTime,
                  style: IsmChatStyles.w400Black14,
                )
              ],
            ),
            centerTitle: false,
            leading: InkWell(
              child: Icon(
                Icons.adaptive.arrow_back,
                color: IsmChatColors.blackColor,
              ),
              onTap: () {
                Get.back<void>();
              },
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(
                    right: IsmChatDimens.five, top: IsmChatDimens.two),
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: IsmChatColors.blackColor,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.save_rounded,
                            color: IsmChatColors.blackColor,
                          ),
                          IsmChatDimens.boxWidth8,
                          const Text(IsmChatStrings.save)
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_rounded,
                            color: IsmChatColors.blackColor,
                          ),
                          IsmChatDimens.boxWidth8,
                          const Text(IsmChatStrings.delete)
                        ],
                      ),
                    ),
                  ],
                  elevation: 1,
                  onSelected: (value) async {
                    if (value == 1) {
                      if (widget.messageData[chatPageController.assetsIndex]
                          .attachments!.first.mediaUrl!.isValidUrl) {
                        IsmChatBlob.fileDownloadWithUrl(widget
                            .messageData[chatPageController.assetsIndex]
                            .attachments!
                            .first
                            .mediaUrl!);
                      } else {
                        IsmChatBlob.fileDownloadWithBytes(
                            widget.messageData[chatPageController.assetsIndex]
                                .attachments!.first.mediaUrl!.strigToUnit8List,
                            downloadName:
                                '${widget.messageData[chatPageController.assetsIndex].attachments!.first.name}.${widget.messageData[chatPageController.assetsIndex].attachments!.first.extension}');
                      }
                    } else if (value == 2) {
                      await chatPageController.showDialogForMessageDelete(
                          widget.messageData[chatPageController.assetsIndex],
                          fromMediaPrivew: true);
                    }
                  },
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: IsmChatDimens.percentHeight(.7),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        var url = widget.messageData[index].attachments!.first
                                .mediaUrl ??
                            '';
                        return widget.messageData[index].customType ==
                                IsmChatCustomMessageType.image
                            ? PhotoView(
                                imageProvider: url.isValidUrl
                                    ? NetworkImage(url)
                                    : kIsWeb
                                        ? MemoryImage(url.strigToUnit8List)
                                            as ImageProvider
                                        : AssetImage(url),
                                loadingBuilder: (context, event) =>
                                    const IsmChatLoadingDialog(),
                                wantKeepAlive: true,
                              )
                            : VideoViewPage(path: url);
                      },
                      options: CarouselOptions(
                        height: IsmChatDimens.percentHeight(1),
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                        initialPage: widget.mediaIndex,
                        enableInfiniteScroll: false,
                        animateToClosest: false,
                        onPageChanged: (index, _) {
                          initiated = widget.messageData[index].sentByMe;
                          mediaTime =
                              widget.messageData[index].sentAt.deliverTime;
                          chatPageController.assetsIndex = index;
                          updateState();
                        },
                      ),
                      itemCount: widget.messageData.length,
                    ),
                    Padding(
                      padding: IsmChatDimens.edgeInsets0_20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (chatPageController.assetsIndex == 0) {
                                return;
                              }
                              chatPageController.assetsIndex--;
                              initiated = widget
                                  .messageData[chatPageController.assetsIndex]
                                  .sentByMe;
                              mediaTime = widget
                                  .messageData[chatPageController.assetsIndex]
                                  .sentAt
                                  .deliverTime;
                              updateState();
                              await carouselController.animateToPage(
                                  chatPageController.assetsIndex,
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 1000));
                            },
                            icon: Container(
                              height: IsmChatDimens.fifty,
                              width: IsmChatDimens.fifty,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.fifty),
                                color: IsmChatColors.whiteColor,
                                border: Border.all(
                                  color: IsmChatColors.blackColor,
                                ),
                              ),
                              child: const Icon(Icons.chevron_left_rounded,
                                  color: IsmChatColors.blackColor),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (chatPageController.assetsIndex ==
                                  widget.messageData.length - 1) {
                                return;
                              }
                              chatPageController.assetsIndex++;
                              initiated = widget
                                  .messageData[chatPageController.assetsIndex]
                                  .sentByMe;
                              mediaTime = widget
                                  .messageData[chatPageController.assetsIndex]
                                  .sentAt
                                  .deliverTime;
                              updateState();
                              await carouselController.animateToPage(
                                  chatPageController.assetsIndex,
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 1000));
                            },
                            icon: Container(
                              height: IsmChatDimens.fifty,
                              width: IsmChatDimens.fifty,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.fifty),
                                color: IsmChatColors.whiteColor,
                                border: Border.all(
                                  color: IsmChatColors.blackColor,
                                ),
                              ),
                              child: const Icon(
                                Icons.chevron_right_rounded,
                                color: IsmChatColors.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                alignment: Alignment.center,
                height: IsmChatDimens.sixty,
                margin: IsmChatDimens.edgeInsets10,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => IsmChatDimens.boxWidth8,
                  itemCount: widget.messageData.length,
                  itemBuilder: (context, index) {
                    var media = widget.messageData[index].attachments;
                    var isVideo = IsmChatConstants.videoExtensions.contains(
                      media?.first.extension,
                    );
                    return InkWell(
                      onTap: () async {
                        initiated = widget.messageData[index].sentByMe;
                        mediaTime =
                            widget.messageData[index].sentAt.deliverTime;

                        chatPageController.assetsIndex = index;
                        chatPageController.isVideoVisible = false;
                        await carouselController.animateToPage(index,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 1000));
                        updateState();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: IsmChatDimens.sixty,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(IsmChatDimens.ten),
                                ),
                                border: chatPageController.assetsIndex == index
                                    ? Border.all(
                                        color: IsmChatColors.blackColor,
                                        width: IsmChatDimens.two)
                                    : null),
                            width: IsmChatDimens.sixty,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(IsmChatDimens.ten),
                              ),
                              child: media?.first.mediaUrl?.isValidUrl == true
                                  ? Image.network(
                                      isVideo
                                          ? media?.first.thumbnailUrl ?? ''
                                          : media?.first.mediaUrl ?? '',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.memory(
                                      isVideo
                                          ? media?.first.thumbnailUrl!
                                                  .strigToUnit8List ??
                                              Uint8List(0)
                                          : media?.first.mediaUrl!
                                                  .strigToUnit8List ??
                                              Uint8List(0),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          if (isVideo)
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
            ],
          ),
        ),
      );
}

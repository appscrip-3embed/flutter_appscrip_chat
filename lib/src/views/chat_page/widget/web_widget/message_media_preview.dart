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
  IsmWebMessageMediaPreview({
    super.key,
    List<IsmChatMessageModel>? messageData,
    int? mediaIndex,
    String? mediaUserName,
    bool? initiated,
    int? mediaTime,
  })  : _mediaIndex = mediaIndex ??
            (Get.arguments as Map<String, dynamic>?)?['mediaIndex'] ??
            0,
        _mediaTime = mediaTime ??
            (Get.arguments as Map<String, dynamic>?)?['mediaTime'] ??
            0,
        _initiated = initiated ??
            (Get.arguments as Map<String, dynamic>?)?['initiated'] ??
            false,
        _mediaUserName = mediaUserName ??
            (Get.arguments as Map<String, dynamic>?)?['mediaUserName'] ??
            '',
        _messageData = messageData ??
            (Get.arguments as Map<String, dynamic>?)?['messageData'] ??
            [];

  final List<IsmChatMessageModel>? _messageData;

  final String? _mediaUserName;

  final bool? _initiated;

  final int? _mediaTime;

  final int? _mediaIndex;

  static const String route = IsmPageRoutes.messageMediaPreivew;

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
    initiated = widget._initiated ?? false;
    chatPageController.assetsIndex = widget._mediaIndex ?? 0;
    final timeStamp =
        DateTime.fromMillisecondsSinceEpoch(widget._mediaTime ?? 0);
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
                      : widget._mediaUserName.toString(),
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
              Tooltip(
                message: 'Save media',
                triggerMode: TooltipTriggerMode.tap,
                child: IconButton(
                  onPressed: () async {
                    if (widget._messageData?[chatPageController.assetsIndex]
                            .attachments!.first.mediaUrl!.isValidUrl ??
                        false) {
                      IsmChatBlob.fileDownloadWithUrl(widget
                          ._messageData![chatPageController.assetsIndex]
                          .attachments!
                          .first
                          .mediaUrl!);
                    } else {
                      IsmChatBlob.fileDownloadWithBytes(
                          widget
                                  ._messageData?[chatPageController.assetsIndex]
                                  .attachments!
                                  .first
                                  .mediaUrl!
                                  .strigToUnit8List ??
                              List.empty(),
                          downloadName:
                              '${widget._messageData?[chatPageController.assetsIndex].attachments!.first.name}.${widget._messageData?[chatPageController.assetsIndex].attachments!.first.extension}');
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                ),
              ),
              IsmChatDimens.boxWidth8,
              Tooltip(
                message: 'Delete media',
                triggerMode: TooltipTriggerMode.tap,
                child: IconButton(
                  onPressed: () async {
                    await chatPageController.showDialogForMessageDelete(
                        widget._messageData![chatPageController.assetsIndex],
                        fromMediaPrivew: true);
                  },
                  icon: const Icon(Icons.delete_rounded),
                ),
              ),
              IsmChatDimens.boxWidth32
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: IsmChatDimens.percentHeight(.75),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        var url = widget._messageData?[index].attachments!.first
                                .mediaUrl ??
                            '';
                        return widget._messageData?[index].customType ==
                                IsmChatCustomMessageType.image
                            ? PhotoView(
                                backgroundDecoration: const BoxDecoration(
                                    color: Colors.transparent),
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
                        initialPage: widget._mediaIndex ?? 0,
                        enableInfiniteScroll: false,
                        animateToClosest: false,
                        onPageChanged: (index, _) {
                          initiated =
                              widget._messageData?[index].sentByMe ?? false;
                          mediaTime =
                              widget._messageData?[index].sentAt.deliverTime ??
                                  '';
                          chatPageController.assetsIndex = index;
                          updateState();
                        },
                      ),
                      itemCount: widget._messageData?.length ?? 0,
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
                                      ._messageData?[
                                          chatPageController.assetsIndex]
                                      .sentByMe ??
                                  false;
                              mediaTime = widget
                                      ._messageData?[
                                          chatPageController.assetsIndex]
                                      .sentAt
                                      .deliverTime ??
                                  '';
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
                                  (widget._messageData?.length ?? 0) - 1) {
                                return;
                              }
                              chatPageController.assetsIndex++;
                              initiated = widget
                                      ._messageData?[
                                          chatPageController.assetsIndex]
                                      .sentByMe ??
                                  false;
                              mediaTime = widget
                                      ._messageData?[
                                          chatPageController.assetsIndex]
                                      .sentAt
                                      .deliverTime ??
                                  '';
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
                  itemCount: widget._messageData?.length ?? 0,
                  itemBuilder: (context, index) {
                    var media = widget._messageData?[index].attachments;
                    var isVideo = IsmChatConstants.videoExtensions.contains(
                      media?.first.extension,
                    );
                    return InkWell(
                      onTap: () async {
                        initiated =
                            widget._messageData?[index].sentByMe ?? false;
                        mediaTime =
                            widget._messageData?[index].sentAt.deliverTime ??
                                '';

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

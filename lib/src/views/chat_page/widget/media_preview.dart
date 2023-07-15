import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

/// show the All media Preview view page
class IsmMediaPreview extends StatefulWidget {
  const IsmMediaPreview({
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
  State<IsmMediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<IsmMediaPreview> {
  /// Page controller for handing the PageView pages
  PageController pageController = PageController();
  final chatPageController = Get.find<IsmChatPageController>();

  String mediaTime = '';

  bool initiated = false;

  int mediaIndex = -1;

  @override
  void initState() {
    super.initState();
    initiated = widget.initiated;
    mediaIndex = widget.mediaIndex;
    final timeStamp = DateTime.fromMillisecondsSinceEpoch(widget.mediaTime);
    final time = DateFormat.jm().format(timeStamp);
    final monthDay = DateFormat.MMMd().format(timeStamp);
    mediaTime = '$monthDay, $time';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.blackColor,
        appBar: AppBar(
          backgroundColor: IsmChatColors.blackColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                initiated
                    ? IsmChatStrings.you
                    : widget.mediaUserName.toString(),
                style: IsmChatStyles.w400White16,
              ),
              Text(
                mediaTime,
                style: IsmChatStyles.w400White14,
              )
            ],
          ),
          centerTitle: false,
          leading: InkWell(
            child: Icon(
              Icons.adaptive.arrow_back,
              color: IsmChatColors.whiteColor,
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
                  color: IsmChatColors.whiteColor,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.share_rounded,
                          color: IsmChatColors.blackColor,
                        ),
                        IsmChatDimens.boxWidth8,
                        const Text(IsmChatStrings.share)
                      ],
                    ),
                  ),
                  if (widget.messageData[mediaIndex].attachments!.first
                      .mediaUrl!.isValidUrl)
                    PopupMenuItem(
                      value: 2,
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
                    value: 3,
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
                    await chatPageController
                        .shareMedia(widget.messageData[mediaIndex]);
                  } else if (value == 2) {
                    await chatPageController
                        .saveMedia(widget.messageData[mediaIndex]);
                  } else if (value == 3) {
                    await chatPageController.showDialogForMessageDelete(
                        widget.messageData[mediaIndex],
                        fromMediaPrivew: true);
                  }
                },
              ),
            ),
          ],
        ),
        body: SizedBox(
          height: IsmChatDimens.percentHeight(1),
          width: IsmChatDimens.percentWidth(1),
          child: CarouselSlider.builder(
            itemBuilder: (BuildContext context, int index, int realIndex) {
              var url =
                  widget.messageData[index].attachments!.first.mediaUrl ?? '';
              return widget.messageData[index].customType ==
                      IsmChatCustomMessageType.image
                  ? PhotoView(
                      imageProvider: url.isValidUrl
                          ? NetworkImage(url) as ImageProvider
                          : AssetImage(url),
                    )
                  : VideoViewPage(path: url);
            },
            options: CarouselOptions(
              height: IsmChatDimens.percentHeight(1),
              viewportFraction: 1,
              enlargeCenterPage: true,
              initialPage: widget.mediaIndex,
              enableInfiniteScroll: false,
              onPageChanged: (index, _) {
                final timeStamp = DateTime.fromMillisecondsSinceEpoch(
                    widget.messageData[index].sentAt);
                final time = DateFormat.jm().format(timeStamp);
                final monthDay = DateFormat.MMMd().format(timeStamp);
                setState(
                  () {
                    initiated = widget.messageData[index].sentByMe;
                    mediaTime = '$monthDay, $time';
                  },
                );
              },
            ),
            itemCount: widget.messageData.length,
          ),
        ),
      );
}

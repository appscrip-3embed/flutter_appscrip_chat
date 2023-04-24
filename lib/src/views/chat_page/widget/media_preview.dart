import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
          // leadi,
          leading: InkWell(
            child: Icon(
              Icons.adaptive.arrow_back,
              color: IsmChatColors.whiteColor,
            ),
            onTap: () {
              Get.back<void>();
            },
          ),
        ),
        body: SizedBox(
          height: IsmChatDimens.percentHeight(1),
          width: IsmChatDimens.percentWidth(1),
          child: CarouselSlider.builder(
            itemBuilder: (BuildContext context, int index, int realIndex) =>
                widget.messageData[index].customType ==
                        IsmChatCustomMessageType.image
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: InteractiveViewer(
                            child: IsmChatImage(
                          widget.messageData[index].attachments?.first
                                  .mediaUrl ??
                              '',
                          isNetworkImage: widget.messageData[index].attachments!
                              .first.mediaUrl!.isValidUrl,
                        )),
                      )
                    : VideoViewPage(
                        path: widget.messageData[index].attachments?.first
                                .mediaUrl ??
                            ''),
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

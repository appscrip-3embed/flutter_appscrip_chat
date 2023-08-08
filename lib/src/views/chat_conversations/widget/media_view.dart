import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// IsmMedia class is for showing the conversation media
class IsmMediaView extends StatefulWidget {
  const IsmMediaView({Key? key, required this.mediaList}) : super(key: key);

  final List<IsmChatMessageModel> mediaList;

  @override
  State<IsmMediaView> createState() => _IsmMediaViewState();
}

class _IsmMediaViewState extends State<IsmMediaView>
    with TickerProviderStateMixin {
  List<Map<String, List<IsmChatMessageModel>>> storeWidgetMediaList = [];

  final chatPageController = Get.find<IsmChatPageController>();

  @override
  void initState() {
    var storeSortLinks = chatPageController.sortMessages(widget.mediaList);
    storeWidgetMediaList =
        chatPageController.sortMediaList(storeSortLinks).reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmChatDimens.edgeInsets10,
        child: widget.mediaList.isEmpty
            ? Center(
                child: Text(
                  IsmChatStrings.noMedia,
                  style: IsmChatStyles.w600Black20,
                ),
              )
            : ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: storeWidgetMediaList.length,
                separatorBuilder: (_, index) => IsmChatDimens.boxHeight10,
                itemBuilder: (context, index) {
                  var media = storeWidgetMediaList[index];
                  var value = media.values.toList().first;
                  var key =
                      media.keys.toString().replaceAll(RegExp(r'\(|\)'), '');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: IsmChatStyles.w400Black14,
                      ),
                      IsmChatDimens.boxHeight10,
                      GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.length,
                        addAutomaticKeepAlives: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                        ),
                        itemBuilder: (context, valueIndex) {
                          var url = value[valueIndex].customType ==
                                  IsmChatCustomMessageType.image
                              ? value[valueIndex].attachments?.first.mediaUrl!
                              : value[valueIndex]
                                  .attachments!
                                  .first
                                  .thumbnailUrl!;
                          var iconData = value[valueIndex].customType ==
                                  IsmChatCustomMessageType.audio
                              ? Icons.audio_file_rounded
                              : Icons.description_rounded;
                          return GestureDetector(
                            onTap: () => Get.find<IsmChatPageController>()
                                .tapForMediaPreview(value[valueIndex]),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ConversationMediaWidget(
                                  media: value[valueIndex],
                                  iconData: iconData,
                                  url: url ?? '',
                                ),
                                if (value[valueIndex].customType ==
                                    IsmChatCustomMessageType.video)
                                  Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: IsmChatColors.whiteColor,
                                    size: IsmChatDimens.thirty,
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
      );
}

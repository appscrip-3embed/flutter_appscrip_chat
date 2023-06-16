import 'dart:developer';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// IsmMedia class is for showing the conversation media
class IsmMedia extends StatefulWidget {
  const IsmMedia({Key? key, required this.mediaList}) : super(key: key);

  final List<IsmChatMessageModel> mediaList;

  @override
  State<IsmMedia> createState() => _IsmMediaState();
}

class _IsmMediaState extends State<IsmMedia> {

  List<Map<String, List<IsmChatMessageModel>>> storeWidgetMediaList = [];

  @override
  void initState(){
    var x = sortMessages(widget.mediaList);
    storeWidgetMediaList =  sortMediaList(x);
    super.initState();
  }

  List<Map<String, List<IsmChatMessageModel>>> sortMediaList (List<IsmChatMessageModel> messages){
    var storeMediaImageList = <Map<String, List<IsmChatMessageModel>>>[];
    for (var x in messages) {
      if(x.customType == IsmChatCustomMessageType.date){
          storeMediaImageList.add({x.body : <IsmChatMessageModel>[]});
          continue;
      }
        var z =storeMediaImageList.last;
        z.forEach((key, value) {
            value.add(x);
        });
    }
    return storeMediaImageList;
  }

  List<IsmChatMessageModel> sortMessages(List<IsmChatMessageModel> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));

    return _parseMessagesWithDate(messages);
  }

  List<IsmChatMessageModel> _parseMessagesWithDate(
      List<IsmChatMessageModel> messages,
      ) {
    var result = <List<IsmChatMessageModel>>[];
    var list1 = <IsmChatMessageModel>[];
    var allMessages = <IsmChatMessageModel>[];
    for (var x = 0; x < messages.length; x++) {
      if (x == 0) {
        list1.add(messages[x]);
      } else if (DateTime.fromMillisecondsSinceEpoch(messages[x - 1].sentAt)
          .isSameDay(DateTime.fromMillisecondsSinceEpoch(messages[x].sentAt))) {
        list1.add(messages[x]);
      } else {
        result.add([...list1]);
        list1.clear();
        list1.add(messages[x]);
      }
      if (x == messages.length - 1 && list1.isNotEmpty) {
        result.add([...list1]);
      }
    }

    for (var messages in result) {
      allMessages.add(
        IsmChatMessageModel.fromMonth(
          messages.first.sentAt,
        ),
      );
      allMessages.addAll(messages);
    }
    return allMessages;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: IsmChatDimens.two,
          title:  Text(
            IsmChatStrings.media,
            style: IsmChatStyles.w600Black18,
          ),
          centerTitle: GetPlatform.isAndroid ? true : false,
        ),
        body: SafeArea(
          child: Padding(
            padding: IsmChatDimens.edgeInsets10,
            child: widget.mediaList.isEmpty
                ? Center(
                    child: Text(
                      IsmChatStrings.noMedia,
                      style: IsmChatStyles.w600Black20,
                    ),
                  )
                :
                ListView.separated(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: storeWidgetMediaList.length,
                    separatorBuilder:(_, index)=> IsmChatDimens.boxHeight10,
                    itemBuilder: (context, index) {
                       var media  = storeWidgetMediaList[index];
                       var value = media.values.toList().first;
                       var key = media.keys.toString().replaceAll(RegExp(r'\(|\)'), '');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                       Text(key, style: IsmChatStyles.w400Black14,),
                    IsmChatDimens.boxHeight10,
                    GridView.builder(
                      physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (context, valueIndex) {

                          // return Text('${value[valueIndex]}');
                          var url =
                          value[valueIndex].customType == IsmChatCustomMessageType.image
                              ? value[valueIndex].attachments!.first.mediaUrl!
                              : value[valueIndex].attachments!.first.thumbnailUrl!;
                          var iconData =
                          value[valueIndex].customType == IsmChatCustomMessageType.audio
                              ? Icons.audio_file_rounded
                              : Icons.description_rounded;
                          return GestureDetector(
                            onTap: () => Get.find<IsmChatPageController>()
                                .tapForMediaPreview(value[valueIndex]),
                            child: ConversationMediaWidget(
                              media: value[valueIndex],
                              iconData: iconData,
                              url: url,
                            ),
                          );
                        },
                      ),
                  ],
                );
                    },
                ),
          ),
        ),
      );
}

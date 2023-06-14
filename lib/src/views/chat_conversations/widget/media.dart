import 'dart:developer';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// IsmMedia class is for showing the conversation media
class IsmMedia extends StatefulWidget {
  IsmMedia({Key? key, required this.mediaList}) : super(key: key);

  List<IsmChatMessageModel> mediaList;

  @override
  State<IsmMedia> createState() => _IsmMediaState();
}

class _IsmMediaState extends State<IsmMedia> {

  List<IsmChatMessageModel> storeMedia = [];

  @override
  void initState(){
    var x = sortMessages(widget.mediaList);
    sortMediaList(x);
    super.initState();
  }

  List<Map<String, List<IsmChatMessageModel>>> sortMediaList (List<IsmChatMessageModel> messages){
    var storeMediaImageList = [];
    for (var x in messages) {
      if(x.customType == IsmChatCustomMessageType.date){
          storeMediaImageList.add({x.body : <IsmChatMessageModel>[]});
          continue;
      }
        var z =storeMediaImageList.last as Map<String,List<dynamic>>;
        z.forEach((key, value) {
            value.add(x);
        });
    }
    return [];
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
                : GridView.builder(
                    itemCount: widget.mediaList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      var media = widget.mediaList[index];
                      var url =
                          media.customType == IsmChatCustomMessageType.image
                              ? media.attachments!.first.mediaUrl!
                              : media.attachments!.first.thumbnailUrl!;
                      var iconData =
                          media.customType == IsmChatCustomMessageType.audio
                              ? Icons.audio_file_rounded
                              : Icons.description_rounded;
                      return GestureDetector(
                        onTap: () => Get.find<IsmChatPageController>()
                            .tapForMediaPreview(media),
                        child: ConversationMediaWidget(
                          media: media,
                          iconData: iconData,
                          url: url,
                        ),
                      );
                    },
                  ),
          ),
        ),
      );
}

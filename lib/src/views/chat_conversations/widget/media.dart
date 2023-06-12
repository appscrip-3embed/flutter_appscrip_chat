import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// IsmMedia class is for showing the conversation media
class IsmMedia extends StatelessWidget {
  IsmMedia({Key? key, required this.mediaList}) : super(key: key);

  List<IsmChatMessageModel> mediaList;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: IsmChatDimens.two,
          title: Text(
            IsmChatStrings.media,
            style: IsmChatStyles.w600Black18,
          ),
          centerTitle: GetPlatform.isAndroid ? true : false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: mediaList.isEmpty
                ? Center(
                    child: Text(
                      IsmChatStrings.noMedia,
                      style: IsmChatStyles.w600Black20,
                    ),
                  )
                : GridView.builder(
                    itemCount: mediaList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      var media = mediaList[index];
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
                            media: media, iconData: iconData, url: url),
                      );
                    },
                  ),
          ),
        ),
      );
}

import 'package:appscrip_chat_component/src/controllers/controllers.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:appscrip_chat_component/src/views/chat_page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmMedia extends StatelessWidget {
  const IsmMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<IsmChatPageController>(
        builder: (controller) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: GridView.builder(
                itemCount: controller.mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  var media = controller.mediaList[index];
                  var url = media.customType == IsmChatCustomMessageType.image
                      ? media.attachments!.first.mediaUrl!
                      : media.attachments!.first.thumbnailUrl!;
                  var iconData =
                      media.customType == IsmChatCustomMessageType.audio
                          ? Icons.audio_file_rounded
                          : Icons.description_rounded;
                  return GestureDetector(
                    onTap: () => controller.tapForMediaPreview(media),
                    child: ConversationMediaWidget(
                        media: media, iconData: iconData, url: url),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

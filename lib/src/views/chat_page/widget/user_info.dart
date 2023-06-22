import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatUserInfo extends StatefulWidget {
  const IsmChatUserInfo({super.key, required this.dbConversationModel});

  final DBConversationModel dbConversationModel;

  @override
  State<IsmChatUserInfo> createState() => _IsmChatUserInfoState();
}

class _IsmChatUserInfoState extends State<IsmChatUserInfo> {
  List<IsmChatMessageModel> mediaMessage = [];

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  void getMessages() async {
    var messages = await IsmChatConfig.objectBox
        .getMessages(widget.dbConversationModel.conversationId);
    IsmChatLog.error(messages);
    if (messages?.isNotEmpty == true) {
      mediaMessage = messages!
          .where((e) => [
                IsmChatCustomMessageType.video,
                IsmChatCustomMessageType.image
              ].contains(e.customType))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.whiteColor,
        appBar: IsmChatAppBar(
          title: Text(
            widget.dbConversationModel.opponentDetails.target?.userName ?? '',
            style: IsmChatStyles.w600White18,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                IsmChatDimens.boxHeight16,
                IsmChatImage.profile(
                  widget.dbConversationModel.opponentDetails.target
                          ?.profileUrl ??
                      '',
                  dimensions: IsmChatDimens.hundred,
                ),
                IsmChatDimens.boxHeight10,
                Text(
                  widget.dbConversationModel.opponentDetails.target?.userName ??
                      '',
                  style: IsmChatStyles.w600Grey16,
                ),
                Text(
                  widget.dbConversationModel.opponentDetails.target
                          ?.userIdentifier ??
                      '',
                  style: IsmChatStyles.w600Grey16,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IsmChatDimens.boxWidth14,
                        Text(
                          IsmChatStrings.media,
                          style: IsmChatStyles.w400Black16,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            // IsmChatUtility.openFullScreenBottomSheet(IsmMedia(
                            //   mediaList: mediaMessage,
                            // ));
                          },
                          icon: const Icon(Icons.arrow_forward_rounded),
                        ),
                      ],
                    ),
                    _UserMediaList(mediaMessage),
                  ],
                ),
                IsmChatDimens.boxHeight10,
                TextButton.icon(
                  onPressed: () {
                    // Get.find<IsmChatPageController>()
                    //   .handleBlockUnblock(true);
                  },
                  icon: Icon(
                    Icons.no_accounts_rounded,
                    color: IsmChatConfig.chatTheme.primaryColor,
                  ),
                  label: Text(
                    IsmChatStrings.block,
                    style: IsmChatStyles.w500Black16,
                  ),
                ),
                IsmChatDimens.boxHeight10,
              ],
            ),
          ),
        ),
      );
}

class _UserMediaList extends StatelessWidget {
  _UserMediaList(this.mediaList);
  List<IsmChatMessageModel> mediaList;

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty == true) {
      return const Align(
        alignment: Alignment.center,
        child: Text(IsmChatStrings.noMedia),
      );
    } else {
      return SizedBox(
        height: IsmChatDimens.hundred,
        child: ListView.separated(
          padding: IsmChatDimens.edgeInsets10_0,
          scrollDirection: Axis.horizontal,
          itemCount: mediaList.take(10).length,
          separatorBuilder: (_, index) => IsmChatDimens.boxWidth8,
          itemBuilder: (_, index) {
            var media = mediaList[index];
            var url = media.customType == IsmChatCustomMessageType.image
                ? media.attachments?.first.mediaUrl ?? ''
                : media.attachments?.first.thumbnailUrl ?? '';
            var iconData = media.customType == IsmChatCustomMessageType.audio
                ? Icons.audio_file_rounded
                : Icons.description_rounded;
            return GestureDetector(
              onTap: () =>
                  Get.find<IsmChatPageController>().tapForMediaPreview(media),
              child: ConversationMediaWidget(
                  media: media, iconData: iconData, url: url),
            );
          },
        ),
      );
    }
  }
}

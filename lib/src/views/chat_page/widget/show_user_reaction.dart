import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImsChatShowUserReaction extends StatefulWidget {
  ImsChatShowUserReaction(
      {super.key, required this.reactionType, required this.message})
      : _controller = Get.find<IsmChatPageController>();

  final IsmChatMessageModel message;
  final String reactionType;
  final IsmChatPageController _controller;

  @override
  State<ImsChatShowUserReaction> createState() =>
      _ImsChatShowUserReactionState();
}

class _ImsChatShowUserReactionState extends State<ImsChatShowUserReaction>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late IsmChatEmoji ismChatEmoji;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: widget.message.reactions?.length ?? 0, vsync: this);
    _tabController.animateTo(0);
    ismChatEmoji = getIsmChatEmoji(message: widget.message, index: 0);
  }

  IsmChatEmoji getIsmChatEmoji(
      {required IsmChatMessageModel message, required int index}) {
    var reactionName = widget.message.reactions?[index].emojiKey;
    var reactionValue =
        IsmChatEmoji.values.firstWhere((e) => e.value == reactionName);

    return reactionValue;
  }

  @override
  Widget build(BuildContext context) {
    var reactionLength = widget.message.reactions?.length ?? 0;
    return Container(
      color: IsmChatColors.whiteColor,
      height: IsmChatDimens.percentHeight(.45),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            height: IsmChatDimens.fifty,
            child: TabBar(
              controller: _tabController,
              isScrollable: reactionLength > 6 ? true : false,
              tabs: List.generate(reactionLength, (index) {
                var reactionValue =
                    getIsmChatEmoji(message: widget.message, index: index);
                var reaction = widget._controller.reactions
                    .firstWhere((e) => e.name == reactionValue.emojiKeyword);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EmojiCell.fromConfig(
                      emoji: reaction,
                      emojiSize: IsmChatDimens.twentyEight,
                      onEmojiSelected: (_, emoji) {
                        _tabController.animateTo(index);
                        ismChatEmoji = getIsmChatEmoji(
                            message: widget.message, index: index);
                      },
                      config: Config(
                        emojiSizeMax: IsmChatDimens.twentyFour,
                        bgColor: IsmChatConfig.chatTheme.backgroundColor!,
                        indicatorColor: IsmChatConfig.chatTheme.primaryColor!,
                      ),
                    ),
                    IsmChatDimens.boxWidth8,
                    Text(
                      '${widget.message.reactions?[index].userIds.length}',
                      style: IsmChatStyles.w400Black16,
                    )
                  ],
                );
              }),
            ),
          ),
          SizedBox(
            height: IsmChatDimens.percentHeight(.3),
            child: TabBarView(
                controller: _tabController,
                children: List.generate(
                    reactionLength,
                    (index) => ListView(
                          children: List.generate(
                            widget.message.reactions?[index].userIds.length ??
                                0,
                            (indexUserId) {
                              var userId = widget.message.reactions?[index]
                                  .userIds[indexUserId];

                              var showOwnUser = false;
                              if (userId ==
                                  IsmChatConfig
                                      .communicationConfig.userConfig.userId) {
                                showOwnUser = true;
                              }
                              return IsmChatTapHandler(
                                onTap: () async {
                                  Get.back();
                                  if (showOwnUser) {
                                    await widget._controller.deleteReacton(
                                        reaction: Reaction(
                                            reactionType: ismChatEmoji,
                                            messageId:
                                                widget.message.messageId ?? '',
                                            conversationId:
                                                widget.message.conversationId ??
                                                    ''));
                                  }
                                },
                                child: ListTile(
                                  title: Text(showOwnUser
                                      ? IsmChatConfig.communicationConfig
                                              .userConfig.userName.isNotEmpty
                                          ? IsmChatConfig.communicationConfig
                                              .userConfig.userName
                                          : Get.find<IsmChatConversationsController>()
                                                  .userDetails
                                                  ?.userName ??
                                              ''
                                      : widget._controller.conversation
                                              ?.chatName ??
                                          ''),
                                  subtitle: showOwnUser
                                      ? const Text(
                                          IsmChatStrings.removeReaction)
                                      : Text(widget
                                              ._controller
                                              .conversation
                                              ?.opponentDetails
                                              ?.userIdentifier ??
                                          ''),
                                  leading: IsmChatImage.profile(showOwnUser
                                      ? Get.find<IsmChatConversationsController>()
                                              .userDetails
                                              ?.userProfileImageUrl ??
                                          ''
                                      : widget._controller.conversation
                                              ?.profileUrl ??
                                          ''),
                                ),
                              );
                            },
                          ),
                        ))),
          ),
          // SizedBox(
          //   width: IsmChatDimens.percentWidth(.5),
          //   child: Divider(
          //       color:
          //           IsmChatConfig.chatTheme.primaryColor!.withOpacity(0.5)),
          // ),
          // SizedBox(
          //     height: IsmChatDimens.percentHeight(.3), child: const Text('')
          //     //  _controller.userReactionList.isEmpty
          //     //     ? IsmChatConfig.loadingDialog ??
          //     //         const IsmChatLoadingDialog()
          //     //     : ListView.separated(
          //     //         scrollDirection: Axis.vertical,
          //     //         shrinkWrap: true,
          //     //         separatorBuilder: (_, index) =>
          //     //             IsmChatDimens.boxHeight2,
          //     //         itemCount: controller.userReactionList.length,
          //     //         itemBuilder: (_, index) {
          //     //           var user = controller.userReactionList[index];
          //     //           var userId = IsmChatConfig
          //     //               .communicationConfig.userConfig.userId;
          //     //           return IsmChatTapHandler(
          //     //             onTap: () async {
          //     //               Get.back();

          //     //               if (user.userId == userId) {
          //     //                 await controller.deleteReacton(
          //     //                     reaction: Reaction(
          //     //                         reactionType: emoji,
          //     //                         messageId: message.messageId ?? '',
          //     //                         conversationId:
          //     //                             message.conversationId ?? ''));
          //     //               }
          //     //             },
          //     //             child: ListTile(
          //     //               title: Text(user.userName),
          //     //               subtitle: user.userId == userId
          //     //                   ? const Text(IsmChatStrings.removeReaction)
          //     //                   : Text(user.userIdentifier),
          //     //               leading: IsmChatImage.profile(user.profileUrl),
          //     //             ),
          //     //           );
          //     //         },
          //     //       ),
          //     ),
        ],
      ),
    );
  }
}

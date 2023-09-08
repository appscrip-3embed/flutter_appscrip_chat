import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatContactView extends StatelessWidget {
  const IsmChatContactView({super.key});

  static const String route = IsmPageRoutes.contact;

  Widget _buildSusWidget(String susTag) => Container(
        padding: IsmChatDimens.edgeInsets10_0,
        height: IsmChatDimens.forty,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              susTag,
              textScaleFactor: 1.5,
              style: IsmChatStyles.w600Black14,
            ),
            SizedBox(
                width: IsmChatDimens.percentWidth(
                  .8,
                ),
                child: Divider(
                  height: .0,
                  indent: IsmChatDimens.ten,
                ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          appBar: IsmChatAppBar(
            title: controller.isSearchSelect
                ? IsmChatInputField(
                    fillColor: IsmChatConfig.chatTheme.primaryColor,
                    controller: controller.textEditingController,
                    style: IsmChatStyles.w400White16,
                    hint: 'Search user...',
                    hintStyle: IsmChatStyles.w400White16,
                    onChanged: (value) {
                      controller.onContactSearch(value);
                    },
                  )
                : Text(
                    'Contacts to send ...  ${controller.contactList.selectedContact.isEmpty ? '' : controller.contactList.selectedContact.length}',
                    style: IsmChatStyles.w600White18,
                  ),
            action: [
              IconButton(
                onPressed: () {
                  controller.isSearchSelect = !controller.isSearchSelect;
                  controller.textEditingController.clear();
                },
                icon: Icon(
                  controller.isSearchSelect
                      ? Icons.clear_rounded
                      : Icons.search_rounded,
                  color: IsmChatColors.whiteColor,
                ),
              )
            ],
          ),
          body: controller.contactList.isEmpty
              ? controller.isLoadingContact
                  ? Center(
                      child: Text(
                        'No contact found',
                        style: IsmChatStyles.w600Black16,
                      ),
                    )
                  : const IsmChatLoadingDialog()
              : Column(
                  children: [
                    Expanded(
                      child: AzListView(
                        data: controller.contactList,
                        itemCount: controller.contactList.length,
                        indexHintBuilder: (context, hint) => Container(
                          alignment: Alignment.center,
                          width: IsmChatDimens.eighty,
                          height: IsmChatDimens.eighty,
                          decoration: BoxDecoration(
                            color: IsmChatConfig.chatTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            hint,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: IsmChatDimens.thirty),
                          ),
                        ),
                        indexBarMargin: IsmChatDimens.edgeInsets10,
                        indexBarData: SuspensionUtil.getTagIndexList(
                            controller.contactList),
                        // [
                        //     'A',
                        //     'B',
                        //     'C',
                        //     'D',
                        //     'E',
                        //     'F',
                        //     'G',
                        //     'H',
                        //     'I',
                        //     'J',
                        //     'K',
                        //     'L',
                        //     'M',
                        //     'N',
                        //     'O',
                        //     'P',
                        //     'Q',
                        //     'R',
                        //     'S',
                        //     'T',
                        //     'U',
                        //     'V',
                        //     'W',
                        //     'X',
                        //     'Y',
                        //     'Z'
                        //   ],

                        indexBarHeight: IsmChatDimens.percentHeight(5),
                        indexBarWidth: IsmChatDimens.forty,
                        indexBarItemHeight: IsmChatDimens.twenty,
                        indexBarOptions: IndexBarOptions(
                          indexHintDecoration: const BoxDecoration(
                              color: IsmChatColors.whiteColor),
                          indexHintChildAlignment: Alignment.center,
                          selectTextStyle: IsmChatStyles.w400White12,
                          selectItemDecoration: BoxDecoration(
                            color: IsmChatConfig.chatTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          needRebuild: true,
                          indexHintHeight: IsmChatDimens.percentHeight(.2),
                        ),
                        itemBuilder: (_, int index) {
                          var searchText =
                              controller.textEditingController.text;
                          var user = controller.contactList[index];
                          var subTitle = user.contact.phones.first.number;
                          var susTag = user.getSuspensionTag();
                          if (!user.contact.displayName.didMatch(searchText)) {
                            return const SizedBox.shrink();
                          }

                          var before = user.contact.displayName.substring(
                            0,
                            user.contact.displayName.toLowerCase().indexOf(
                                  searchText.toLowerCase(),
                                ),
                          );
                          var match = user.contact.displayName.substring(
                              before.length,
                              (before.length) + searchText.length);
                          var after = user.contact.displayName
                              .substring((before.length) + (match.length));
                          // String? subBefore;
                          // String? subMatch;
                          // String? subAfter;
                          // if (searchText.isAlphabet) {
                          //   subBefore = subTitle?.substring(
                          //     0,
                          //     subTitle.toLowerCase().indexOf(
                          //           searchText.toLowerCase(),
                          //         ),
                          //   );
                          //   subMatch = subTitle?.substring(
                          //       subBefore?.length ?? 0,
                          //       (subBefore?.length ?? 0) + searchText.length);
                          //   subAfter = subTitle?.substring(
                          //     (subBefore?.length ?? 0) +
                          //         (subMatch?.length ?? 0),
                          //   );
                          // }

                          return Column(
                            children: [
                              Offstage(
                                offstage: user.isShowSuspension != true,
                                child: _buildSusWidget(susTag),
                              ),
                              ListTile(
                                  selected: user.isConotactSelected,
                                  selectedTileColor: IsmChatConfig
                                      .chatTheme.primaryColor!
                                      .withOpacity(0.2),
                                  onTap: () {
                                    controller.onSelectedContactTap(index);
                                  },
                                  dense: true,
                                  leading: IsmChatImage.profile(
                                    user.contact.photo != null
                                        ? user.contact.photo!.toString()
                                        : '',
                                    name: user.contact.displayName,
                                    isNetworkImage: false,
                                    isBytes: true,
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      text: before,
                                      style: IsmChatStyles.w600Black14,
                                      children: [
                                        TextSpan(
                                          text: match,
                                          style: TextStyle(
                                              color: IsmChatConfig
                                                  .chatTheme.primaryColor),
                                        ),
                                        TextSpan(
                                          text: after,
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    subTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: IsmChatStyles.w400Black12,
                                  )
                                  // :
                                  //  RichText(
                                  //     text: TextSpan(
                                  //       text: subBefore,
                                  //       style: IsmChatStyles.w400Black12,
                                  //       children: [
                                  //         TextSpan(
                                  //           text: subMatch,
                                  //           style: TextStyle(
                                  //             color: IsmChatConfig
                                  //                 .chatTheme.primaryColor,
                                  //             fontWeight: FontWeight.w600,
                                  //           ),
                                  //         ),
                                  //         TextSpan(
                                  //           text: subAfter,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     maxLines: 1,
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  )
                            ],
                          );
                        },
                      ),
                    ),
                    if (controller.contactList.selectedContact.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                        height: IsmChatDimens.eighty,
                        margin: IsmChatDimens.edgeInsets10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller
                                    .contactList.selectedContact.length,
                                separatorBuilder: (_, __) =>
                                    IsmChatDimens.boxWidth8,
                                itemBuilder: (context, index) {
                                  var user = controller
                                      .contactList.selectedContact[index];
                                  return InkWell(
                                    onTap: () {
                                      controller.onSelectedContactTap(
                                        controller.contactList.indexOf(
                                          controller.contactList
                                              .selectedContact[index],
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: IsmChatDimens.fifty,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              SizedBox(
                                                width: IsmChatDimens.forty,
                                                height: IsmChatDimens.forty,
                                                child: IsmChatImage.profile(
                                                  user.contact.photo != null
                                                      ? user.contact.photo!
                                                          .toString()
                                                      : '',
                                                  name:
                                                      user.contact.displayName,
                                                  isNetworkImage: false,
                                                  isBytes: true,
                                                ),
                                              ),
                                              Positioned(
                                                top: IsmChatDimens.twentySeven,
                                                left: IsmChatDimens.twentySeven,
                                                child: CircleAvatar(
                                                  backgroundColor: IsmChatConfig
                                                      .chatTheme
                                                      .backgroundColor,
                                                  radius: IsmChatDimens.eight,
                                                  child: Icon(
                                                    Icons.close_rounded,
                                                    color: IsmChatConfig
                                                        .chatTheme.primaryColor,
                                                    size: IsmChatDimens.twelve,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: IsmChatDimens.twentyEight,
                                            child: Text(
                                              user.contact.displayName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: IsmChatStyles.w600Black10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            IsmChatDimens.boxWidth8,
                            FloatingActionButton(
                              onPressed: () async {
                                Get.back();
                                controller.sendContact(
                                  conversationId:
                                      controller.conversation?.conversationId ??
                                          '',
                                  userId: controller.conversation
                                          ?.opponentDetails?.userId ??
                                      '',
                                  contacts: controller
                                      .contactList.selectedContact
                                      .map((e) => e.contact)
                                      .toList(),
                                );
                              },
                              elevation: 0,
                              shape: const CircleBorder(),
                              backgroundColor:
                                  IsmChatConfig.chatTheme.primaryColor,
                              child: const Icon(
                                Icons.send_rounded,
                                color: IsmChatColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      );
}

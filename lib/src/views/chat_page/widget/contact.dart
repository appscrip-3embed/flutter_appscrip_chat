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
            title:
                // controller.showSearchField
                //     ? IsmChatInputField(
                //         fillColor: IsmChatConfig.chatTheme.primaryColor,
                //         controller: controller.textEditingController,
                //         style: IsmChatStyles.w400White16,
                //         hint: 'Search user...',
                //         hintStyle: IsmChatStyles.w400White16,
                //         onChanged: (value) {},
                //       )
                //     :
                Text(
              'Contacts to send ...  ${controller.contactList.selectedContact.isEmpty ? '' : controller.contactList.selectedContact.length}',
              style: IsmChatStyles.w600White18,
            ),
            // action: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: Icon(
            //       controller.showSearchField
            //           ? Icons.clear_rounded
            //           : Icons.search_rounded,
            //       color: IsmChatColors.whiteColor,
            //     ),
            //   )
            // ],
          ),
          body: controller.contactList.isEmpty
              ?
              //  controller.isLoadingUsers
              //     ? Center(
              //         child: Text(
              //           'No user found',
              //           style: IsmChatStyles.w600Black16,
              //         ),
              //       )
              //     :
              const IsmChatLoadingDialog()
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
                          var user = controller.contactList[index];
                          var susTag = user.getSuspensionTag();
                          return Column(
                            children: [
                              Offstage(
                                offstage: user.isShowSuspension != true,
                                child: _buildSusWidget(susTag),
                              ),
                              ListTile(
                                onTap: () {},
                                dense: true,
                                mouseCursor: SystemMouseCursors.click,
                                leading: IsmChatImage.profile(
                                  user.contact.androidAccountName ?? '',
                                  name: user.contact.displayName ?? '',
                                ),
                                title: Text(
                                  user.contact.displayName ?? '',
                                  style: IsmChatStyles.w600Black14,
                                ),
                                subtitle: Text(
                                  user.contact.givenName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: IsmChatStyles.w400Black12,
                                ),
                              ),
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
                        height: IsmChatDimens.sixty,
                        padding: IsmChatDimens.edgeInsets0_10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: IsmChatDimens.edgeInsets10,
                                child: Text(
                                  '',
                                  // controller.selectedUserList
                                  //     .map((e) => e.userName)
                                  //     .join(', '),
                                  maxLines: 1,
                                  style: IsmChatStyles.w600Black12,
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: () async {},
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

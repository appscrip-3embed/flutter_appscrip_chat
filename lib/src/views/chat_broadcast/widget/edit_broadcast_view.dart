import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class IsmChatEditBroadcastView extends StatelessWidget {
  IsmChatEditBroadcastView({super.key});

  static const String route = IsmPageRoutes.editBroadcastView;

  final broadcast = Get.arguments as BroadcastModel;

  @override
  Widget build(BuildContext context) => GetX<IsmChatBroadcastController>(
        initState: (state) {
          IsmChatUtility.doLater(() async {
            await Get.find<IsmChatBroadcastController>().getBroadcastMembers(
              groupcastId: broadcast.groupcastId ?? '',
            );
          });
        },
        builder: (controller) => Scaffold(
          appBar: IsmChatAppBar(
            title: Text(
              IsmChatStrings.broadcastinfo,
              style: IsmChatConfig.chatTheme.chatPageHeaderTheme?.titleStyle ??
                  IsmChatStyles.w600White18,
            ),
            action: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    IsmChatStrings.save,
                    style: IsmChatStyles.w400White16,
                  ))
            ],
          ),
          body: controller.isApiCall
              ? const IsmChatLoadingDialog()
              : Padding(
                  padding: IsmChatDimens.edgeInsets10_20_10_0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IsmChatInputField(
                        autofocus: false,
                        fillColor: IsmChatConfig.chatTheme.backgroundColor,
                        controller: controller.broadcastName,
                        padding: IsmChatDimens.edgeInsets0,
                        style: IsmChatStyles.w600Black16,
                        maxLines: 1,
                        hint: broadcast.groupcastTitle ??
                            'Add broadcast name here...',
                        hintStyle: IsmChatStyles.w600Black16,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {},
                        cursorColor: Colors.transparent,
                      ),
                      IsmChatDimens.boxHeight20,
                      Text(
                        'LIST RECIPIENT : ${controller.broadcastMembers?.membersCount ?? ''}',
                        style: IsmChatStyles.w600Black12,
                      ),
                      IsmChatDimens.boxHeight20,
                      Expanded(
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                            itemCount:
                                controller.broadcastMembers?.members.length ??
                                    0,
                            itemBuilder: (_, index) {
                              final data =
                                  controller.broadcastMembers?.members[index];
                              return Slidable(
                                  direction: Axis.horizontal,
                                  closeOnScroll: true,
                                  enabled: true,
                                  endActionPane: ActionPane(
                                    extentRatio: 0.3,
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) async {
                                          await controller
                                              .deleteBroadcastMember(
                                                  isloading: true,
                                                  groupcastId:
                                                      broadcast.groupcastId ??
                                                          '',
                                                  members: [
                                                data?.memberId ?? ''
                                              ]);
                                        },
                                        flex: 1,
                                        backgroundColor: IsmChatColors.redColor,
                                        foregroundColor:
                                            IsmChatColors.whiteColor,
                                        icon: Icons.delete_rounded,
                                        label: IsmChatStrings.delete,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    dense: true,
                                    leading: IsmChatImage.profile(
                                        data?.memberInfo?.profileUrl ?? ''),
                                    title: Text(
                                      data?.memberInfo?.userName ?? '',
                                      style: IsmChatStyles.w600Black16,
                                    ),
                                    subtitle: Text(
                                      data?.memberInfo?.userIdentifier ?? '',
                                    ),
                                  ));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      );
}

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class IsmChatContactsInfoView extends StatelessWidget {
  IsmChatContactsInfoView({super.key, List<Contact>? contacts})
      : _contacts = contacts ??
            (Get.arguments as Map<String, dynamic>?)?['contacts'] ??
            [];

  final List<Contact>? _contacts;

  static const String route = IsmPageRoutes.contactInfoView;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: IsmChatColors.whiteColor,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: IsmChatColors.whiteColor,
            ),
          ),
          backgroundColor: IsmChatConfig.chatTheme.primaryColor,
          titleSpacing: 1,
          title: Text(IsmChatStrings.contactInfo,
              style: IsmChatStyles.w600White18),
          centerTitle: true,
        ),
        body: SizedBox(
          height: Get.height,
          child: ListView.separated(
            padding: IsmChatDimens.edgeInsets10,
            itemBuilder: (_, index) {
              var contact = _contacts?[index];
              return Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: IsmChatImage.profile(
                        contact?.photo != null ? contact!.photo.toString() : '',
                        name: contact?.displayName,
                        isNetworkImage: false,
                        isBytes: true,
                      ),
                      title: Text(
                        contact?.displayName ?? '',
                        style: IsmChatStyles.w600Black14,
                      ),
                      subtitle: Text(
                        contact?.phones.first.number ?? '',
                        style: IsmChatStyles.w600Black12,
                      ),
                      trailing: IsmChatTapHandler(
                        onTap: () async {
                          await FlutterContacts.openExternalInsert(contact);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: IsmChatDimens.seventy,
                          height: IsmChatDimens.forty,
                          decoration: BoxDecoration(
                            color: IsmChatConfig.chatTheme.primaryColor,
                            borderRadius:
                                BorderRadius.circular(IsmChatDimens.twenty),
                          ),
                          child: Text(
                            'Add',
                            style: IsmChatStyles.w600White14,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () async {
                              IsmChatUtility.toSMS(
                                  contact?.phones.first.number ?? '');
                            },
                            icon: Icon(
                              Icons.message_rounded,
                              color: IsmChatConfig.chatTheme.primaryColor,
                              size: IsmChatDimens.twentyFive,
                            ),
                            label: const Text('SMS'),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () async {
                              IsmChatUtility.dialNumber(
                                  contact?.phones.first.number ?? '');
                            },
                            icon: Icon(
                              Icons.call_outlined,
                              color: IsmChatConfig.chatTheme.primaryColor,
                              size: IsmChatDimens.twentyFive,
                            ),
                            label: const Text('Call'),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (_, index) => IsmChatDimens.boxHeight10,
            itemCount: _contacts?.length ?? 0,
          ),
        ),
      );
}

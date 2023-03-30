import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatAttachmentCard extends StatelessWidget {
  const IsmChatAttachmentCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: IsmChatColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(IsmChatDimens.ten),
                topRight: Radius.circular(IsmChatDimens.ten))),
        padding: IsmChatDimens.egdeInsets20,
        height: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Get.back<void>();
                  // Get.to<void>(const IsmCameraScreenView());
                },
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(IsmChatDimens.fifty)),
                        color: Colors.blueAccent),
                    width: IsmChatDimens.forty,
                    height: IsmChatDimens.forty,
                    child: const Icon(
                      Icons.camera_alt,
                      color: IsmChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Camera',
                    style: IsmChatStyles.w600Black18,
                  ),
                )),
            InkWell(
                onTap: () {
                  Get.back<void>();
                  // _chatUserController.ismHandleMediaSelection();
                },
                child: ListTile(
                  leading: Container(
                    // padding: IsmDimens.edgeInsets8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(IsmChatDimens.fifty)),
                        color: Colors.purpleAccent),
                    width: IsmChatDimens.forty,
                    height: IsmChatDimens.forty,
                    child: const Icon(
                      Icons.photo,
                      color: IsmChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Photo Video Library',
                    style: IsmChatStyles.w600Black18,
                  ),
                )),
            InkWell(
                onTap: () {
                  Get.back<void>();
                  // _chatUserController.ismHandleFileSelection();
                },
                child: ListTile(
                  leading: Container(
                    // padding: IsmDimens.edgeInsets8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(IsmChatDimens.fifty)),
                        color: Colors.pinkAccent),
                    width: IsmChatDimens.forty,
                    height: IsmChatDimens.forty,
                    child: const Icon(
                      Icons.file_copy,
                      color: IsmChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Document',
                    style: IsmChatStyles.w600Black18,
                  ),
                )),
            InkWell(
                onTap: () async {
                  Get.back<void>();
                  await Get.to<void>(const IsmChatLocationWidget());
                },
                child: ListTile(
                  leading: Container(
                    // padding: IsmDimens.edgeInsets8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(IsmChatDimens.fifty)),
                        color: Colors.greenAccent),
                    width: IsmChatDimens.forty,
                    height: IsmChatDimens.forty,
                    child: const Icon(
                      Icons.location_on,
                      color: IsmChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Location',
                    style: IsmChatStyles.w600Black18,
                  ),
                )),
          ],
        ),
      );
}

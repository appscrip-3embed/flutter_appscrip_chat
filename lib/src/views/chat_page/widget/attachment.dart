import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: ChatColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ChatDimens.ten),
                topRight: Radius.circular(ChatDimens.ten))),
        padding: ChatDimens.egdeInsets20,
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
                    // padding: IsmDimens.edgeInsets8,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(ChatDimens.fifty)),
                        color: Colors.blueAccent),
                    width: ChatDimens.fifty,
                    height: ChatDimens.fifty,
                    child: const Icon(
                      Icons.camera_alt,
                      color: ChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Camera',
                    style: ChatStyles.w600Black18,
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(ChatDimens.fifty)),
                        color: Colors.purpleAccent),
                    width: ChatDimens.fifty,
                    height: ChatDimens.fifty,
                    child: const Icon(
                      Icons.photo,
                      color: ChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Photo Video Library',
                    style: ChatStyles.w600Black18,
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
                        borderRadius:
                            BorderRadius.all(Radius.circular(ChatDimens.fifty)),
                        color: Colors.pinkAccent),
                    width: ChatDimens.fifty,
                    height: ChatDimens.fifty,
                    child: const Icon(
                      Icons.file_copy,
                      color: ChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Document',
                    style: ChatStyles.w600Black18,
                  ),
                )),
            InkWell(
                onTap: () async {
                  Get.back<void>();
                  await Get.to<void>(const IsmLocationWidget());
                },
                child: ListTile(
                  leading: Container(
                    // padding: IsmDimens.edgeInsets8,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(ChatDimens.fifty)),
                        color: Colors.greenAccent),
                    width: ChatDimens.fifty,
                    height: ChatDimens.fifty,
                    child: const Icon(
                      Icons.location_on,
                      color: ChatColors.whiteColor,
                      size: 25,
                    ),
                  ),
                  title: Text(
                    'Location',
                    style: ChatStyles.w600Black18,
                  ),
                )),
          ],
        ),
      );
}

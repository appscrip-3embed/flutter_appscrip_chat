import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImsChatShowWallpaper extends StatefulWidget {
  const ImsChatShowWallpaper({
    super.key,
  });

  @override
  State<ImsChatShowWallpaper> createState() => _ImsChatShowWallpaperState();
}

class _ImsChatShowWallpaperState extends State<ImsChatShowWallpaper>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ImsChatShowWallpaper> {
  late TabController _tabController;

  final conversationController = Get.find<IsmChatConversationsController>();
  final chatPageController = Get.find<IsmChatPageController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: IsmChatColors.whiteColor,
      height: IsmChatDimens.percentHeight(.6),
      child: Column(
        children: [
          Padding(
            padding: IsmChatDimens.edgeInsets10_0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (chatPageController.backgroundColor.isNotEmpty ||
                    chatPageController.backgroundImage.isNotEmpty) ...[
                  IsmChatTapHandler(
                    onTap: () async {
                      IsmChatUtility.showLoader();

                      var assetList = conversationController
                              .userDetails?.metaData?.assetList ??
                          [];
                      var assetIndex = assetList.indexWhere((e) => e.keys
                          .contains(
                              chatPageController.conversation?.conversationId));
                      assetList.removeAt(assetIndex);
                      await conversationController.updateUserData(
                        {'assetList': assetList},
                      );
                      IsmChatUtility.closeLoader();
                      await conversationController.getUserData(isLoading: true);
                      chatPageController.backgroundColor = '';
                      chatPageController.backgroundImage = '';
                      Get.back();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_rounded,
                          color: IsmChatColors.redColor,
                        ),
                        Text(
                          'Remove custom wallpaper',
                          style: IsmChatStyles.w600red16,
                        )
                      ],
                    ),
                  ),
                ] else ...[
                  const Spacer()
                ],
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.clear_rounded),
                )
              ],
            ),
          ),
          const Divider(),
          Container(
            alignment: Alignment.topCenter,
            height: IsmChatDimens.forty,
            child: TabBar(
                dividerColor: IsmChatColors.whiteColor,
                controller: _tabController,
                tabs: [
                  Text(
                    'Photos',
                    style: IsmChatStyles.w600Black16,
                  ),
                  Text(
                    'Colors',
                    style: IsmChatStyles.w600Black16,
                  ),
                ]),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                conversationController.backgroundImage.isEmpty
                    ? const IsmChatLoadingDialog()
                    : GridView.builder(
                        padding: IsmChatDimens.edgeInsets10_0,
                        itemCount:
                            conversationController.backgroundImage.length + 1,
                        addAutomaticKeepAlives: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return IsmChatTapHandler(
                              onTap: () async {
                                var file = await IsmChatUtility.pickImage(
                                    ImageSource.gallery);

                                if (file != null) {
                                  await Get.to(
                                    IsmChatWallpaperPreview(
                                      imagePath: file.path,
                                      assetSrNo: 100,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height: IsmChatDimens.hundred,
                                width: IsmChatDimens.hundred,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: IsmChatConfig
                                            .chatTheme.primaryColor!)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_library_outlined,
                                      size: IsmChatDimens.thirty,
                                    ),
                                    Text(
                                      'My Photos',
                                      style: IsmChatStyles.w400Black14,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          var image =
                              conversationController.backgroundImage[index - 1];
                          return IsmChatTapHandler(
                            onTap: () async {
                              await Get.to(IsmChatWallpaperPreview(
                                imagePath:
                                    '${IsmChatAssets.backgroundImages}/${image.path!}',
                                assetSrNo: image.srNo,
                              ));
                            },
                            child: SizedBox(
                              key: Key('$index'),
                              height: IsmChatDimens.hundred,
                              width: IsmChatDimens.hundred,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.ten),
                                child: Image.asset(
                                  '${IsmChatAssets.backgroundImages}/${image.path!}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                conversationController.backgroundColor.isEmpty
                    ? const IsmChatLoadingDialog()
                    : GridView.builder(
                        padding: IsmChatDimens.edgeInsets10_0,
                        itemCount:
                            conversationController.backgroundColor.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          var color =
                              conversationController.backgroundColor[index];
                          return IsmChatTapHandler(
                              onTap: () async {
                                await Get.to(IsmChatWallpaperPreview(
                                  backgroundColor: color.color,
                                  assetSrNo: color.srNo,
                                ));
                              },
                              child: SizedBox(
                                  height: IsmChatDimens.hundred,
                                  width: IsmChatDimens.hundred,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ColoredBox(
                                          color: color.color!.toColor))));
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

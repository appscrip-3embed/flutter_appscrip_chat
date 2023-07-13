import 'dart:math' as math;
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImsChatShowWallpaper extends StatefulWidget {
  ImsChatShowWallpaper({
    super.key,
  }) : _controller = Get.find<IsmChatPageController>();

  final IsmChatPageController _controller;

  @override
  State<ImsChatShowWallpaper> createState() => _ImsChatShowWallpaperState();
}

class _ImsChatShowWallpaperState extends State<ImsChatShowWallpaper>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final rnd = math.Random();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Container(
        color: IsmChatColors.whiteColor,
        height: IsmChatDimens.percentHeight(.38),
        child: Column(
          children: [
            Container(
              padding: IsmChatDimens.edgeInsets10_0,
              alignment: Alignment.topLeft,
              height: IsmChatDimens.fifty,
              child: TabBar(
                  padding: IsmChatDimens.edgeInsets10,
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
            SizedBox(
              height: IsmChatDimens.percentHeight(.3),
              child: TabBarView(
                controller: _tabController,
                children: [
                  Text(
                    'Photos',
                    style: IsmChatStyles.w400Black16,
                  ),
                  GridView.builder(
                    padding: IsmChatDimens.edgeInsets10_0,
                    itemCount: 10,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      Color getRandomColor() => Color(rnd.nextInt(0xffffffff));
                      return IsmChatTapHandler(
                          onTap: () async {
                            IsmChatLog.error(getRandomColor());
                            await Get.to(const IsmChatWallpaperPreview());
                          },
                          child: SizedBox(
                              height: IsmChatDimens.hundred,
                              width: IsmChatDimens.hundred,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ColoredBox(color: getRandomColor()))));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

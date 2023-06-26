import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/widget/docs_view.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/widget/links_view.dart';
import 'package:appscrip_chat_component/src/views/chat_conversations/widget/media_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// IsmMedia class is for showing the conversation media
class IsmMedia extends StatefulWidget {
  const IsmMedia(
      {Key? key,
      required this.mediaList,
      required this.mediaListLinks,
      required this.mediaListDocs})
      : super(key: key);

  final List<IsmChatMessageModel> mediaList;
  final List<IsmChatMessageModel> mediaListLinks;
  final List<IsmChatMessageModel> mediaListDocs;

  @override
  State<IsmMedia> createState() => _IsmMediaState();
}

class _IsmMediaState extends State<IsmMedia> with TickerProviderStateMixin {
  List<Map<String, List<IsmChatMessageModel>>> storeWidgetMediaList = [];

  final chatPageController = Get.find<IsmChatPageController>();

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController?.addListener(_handleTabSelection);
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget getTabBar() => TabBar(
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.focused)
                    ? null
                    : Colors.transparent),
        dividerColor: Colors.transparent,
        controller: _tabController,
        labelColor: IsmChatColors.blackColor,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: IsmChatDimens.edgeInsets0,
        indicatorWeight: double.minPositive,
        labelPadding: IsmChatDimens.edgeInsets2_0,
        labelStyle: IsmChatStyles.w600Black16,
        splashBorderRadius: BorderRadius.zero,
        isScrollable: true,
        tabs: [
          Row(
            children: [
              Container(
                  margin: IsmChatDimens.edgeInsets4,
                  height: IsmChatDimens.twentySeven,
                  width: IsmChatDimens.seventyEight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(IsmChatDimens.six),
                    color: _tabController?.index == 0
                        ? IsmChatColors.whiteColor
                        : IsmChatColors.darkBlueGreyColor,
                  ),
                  child: const Tab(
                    text: IsmChatStrings.media,
                  )),
              if (_tabController?.index == 2)
                Container(
                  height: IsmChatDimens.twenty,
                  width: IsmChatDimens.two,
                  color: IsmChatColors.greyColor.withOpacity(.1),
                )
            ],
          ),
          Container(
              margin: IsmChatDimens.edgeInsets4,
              height: IsmChatDimens.twentySeven,
              width: IsmChatDimens.seventyEight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(IsmChatDimens.six),
                color: _tabController?.index == 1
                    ? IsmChatColors.whiteColor
                    : IsmChatColors.darkBlueGreyColor,
              ),
              child: const Tab(text: IsmChatStrings.links)),
          Row(
            children: [
              if (_tabController?.index == 0)
                Container(
                  height: IsmChatDimens.twenty,
                  width: IsmChatDimens.two,
                  color: IsmChatColors.greyColor.withOpacity(.1),
                ),
              Container(
                  margin: IsmChatDimens.edgeInsets4,
                  height: IsmChatDimens.twentySeven,
                  width: IsmChatDimens.seventyEight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(IsmChatDimens.six),
                    color: _tabController?.index == 2
                        ? IsmChatColors.whiteColor
                        : IsmChatColors.darkBlueGreyColor,
                  ),
                  child: const Tab(text: IsmChatStrings.docs)),
            ],
          ),
        ],
      );

  Widget getTabBarView() => TabBarView(
        controller: _tabController,
        children: [
          IsmMediaView(mediaList: widget.mediaList),
          IsmLinksView(mediaListLinks: widget.mediaListLinks),
          IsmDocsView(mediaListDocs: widget.mediaListDocs),
        ],
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: IsmChatColors.whiteColor,
            elevation: IsmChatDimens.three,
            shadowColor: Colors.grey,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(IsmChatDimens.eight),
                color: IsmChatColors.darkBlueGreyColor,
              ),
              child: getTabBar(),
            ),
            centerTitle: GetPlatform.isAndroid ? true : false,
            leading: IconButton(
              onPressed: Get.back,
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
            ),
          ),
          body: SafeArea(
            child: getTabBarView(),
          ),
        ),
      );
}

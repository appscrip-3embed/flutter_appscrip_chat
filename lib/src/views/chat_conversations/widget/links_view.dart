import 'dart:developer';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:url_launcher/url_launcher.dart';

/// IsmMedia class is for showing the conversation links that is send and receive from both sides
class IsmLinksView extends StatefulWidget {
  const IsmLinksView({Key? key, required this.mediaListLinks}) : super(key: key);

  final List<IsmChatMessageModel> mediaListLinks;

  @override
  State<IsmLinksView> createState() => _IsmLinksViewState();
}

class _IsmLinksViewState extends State<IsmLinksView> with TickerProviderStateMixin {

  List<Map<String, List<IsmChatMessageModel>>> storeWidgetLinksList = [];

  final chatPageController = Get.find<IsmChatPageController>();

  @override
  void initState(){
    var storeSortLinks = chatPageController.sortMessages(widget.mediaListLinks);
    storeWidgetLinksList =  chatPageController.sortMediaList(storeSortLinks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: IsmChatDimens.edgeInsets10,
    child: widget.mediaListLinks.isEmpty
        ? Center(
      child: Text(
        IsmChatStrings.noLinks,
        style: IsmChatStyles.w600Black20,
      ),
    )
        :
    ListView.separated(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: storeWidgetLinksList.length,
      separatorBuilder:(_, index)=> IsmChatDimens.boxHeight10,
      itemBuilder: (context, index) {
        var media  = storeWidgetLinksList[index];
        var value = media.values.toList().first;
        var key = media.keys.toString().replaceAll(RegExp(r'\(|\)'), '');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(key, style: IsmChatStyles.w400Black14,),
            IsmChatDimens.boxHeight10,
            ListView.separated(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.length,
              itemBuilder: (context, valueIndex) => Card(
                margin: const EdgeInsets.all(10),
                // color: IsmChatColors.blueGreyColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                  child: GestureDetector(
                    onTap: () => Get.find<IsmChatPageController>()
                        .tapForMediaPreview(value[valueIndex]),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: context.width * 0.8,
                        maxHeight: context.height * 0.22,
                      ),
                      child: _LinkPreview(
                        link: value[valueIndex].body,
                        child: LinkPreviewGenerator(
                          bodyMaxLines: 3,
                          link: value[valueIndex].body.convertToValidUrl,
                          linkPreviewStyle: LinkPreviewStyle.small,
                          showGraphic: true,
                          backgroundColor: Colors.transparent,
                          titleStyle: IsmChatStyles.w500Black16,
                          removeElevation: true,
                          bodyTextOverflow: TextOverflow.ellipsis,
                          cacheDuration: const Duration(minutes: 5),
                          errorWidget: Text(
                            IsmChatStrings.errorLoadingPreview,
                            style: IsmChatStyles.w400White12
                          ),
                          placeholderWidget: Text(
                            'Loading preview...',
                            style:IsmChatStyles.w400White12
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              separatorBuilder:(_, index)=> IsmChatDimens.boxHeight10,
            ),
          ],
        );
      },
    ),
  );
}

class _LinkPreview extends StatelessWidget {
  const _LinkPreview({
    required this.child,
    required this.link,
  });

  final Widget child;
  final String link;

  @override
  Widget build(BuildContext context) => IsmChatTapHandler(
    onTap: () => launchUrl(Uri.parse(link.convertToValidUrl)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: IsmChatDimens.edgeInsets8_10,
          child: child,
        ),
        IsmChatDimens.boxHeight4,
        Padding(
          padding: IsmChatDimens.edgeInsets4_0,
          child: Text(
            link,
            style: IsmChatStyles.w500GreyLight12,
            softWrap: true,
            maxLines: null,
          ),
        ),
      ],
    ),
  );
}

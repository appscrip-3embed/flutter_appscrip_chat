import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// IsmMedia class is for showing the conversation media
class IsmDocsView extends StatefulWidget {
  const IsmDocsView({Key? key, required this.mediaListDocs}) : super(key: key);

  final List<IsmChatMessageModel> mediaListDocs;

  @override
  State<IsmDocsView> createState() => _IsmDocsViewState();
}

class _IsmDocsViewState extends State<IsmDocsView>
    with TickerProviderStateMixin {
  List<Map<String, List<IsmChatMessageModel>>> storeWidgetDocsList = [];

  final chatPageController = Get.find<IsmChatPageController>();

  @override
  void initState() {
    var storeSortDocs = chatPageController.sortMessages(widget.mediaListDocs);
    storeWidgetDocsList =
        chatPageController.sortMediaList(storeSortDocs).reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: IsmChatDimens.edgeInsets10,
        child: widget.mediaListDocs.isEmpty
            ? Center(
                child: Text(
                  IsmChatStrings.noDocs,
                  style: IsmChatStyles.w600Black20,
                ),
              )
            : ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: storeWidgetDocsList.length,
                separatorBuilder: (_, index) => IsmChatDimens.boxHeight10,
                itemBuilder: (context, index) {
                  var media = storeWidgetDocsList[index];
                  var value = media.values.toList().first;
                  var key =
                      media.keys.toString().replaceAll(RegExp(r'\(|\)'), '');
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: IsmChatStyles.w400Black14,
                      ),
                      IsmChatDimens.boxHeight10,
                      ListView.separated(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.length,
                        itemBuilder: (context, valueIndex) => GestureDetector(
                          onTap: () => Get.find<IsmChatPageController>()
                              .tapForMediaPreview(value[valueIndex]),
                          child: SizedBox(
                            height: context.width * 0.15,
                            width: double.maxFinite,
                            child: Container(
                              decoration: BoxDecoration(
                                color: IsmChatColors.blueGreyColor,
                                borderRadius:
                                    BorderRadius.circular(IsmChatDimens.twelve),
                              ),
                              padding: IsmChatDimens.edgeInsets4,
                              child: IsmChatFileMessage(value[valueIndex]),
                            ),
                          ),
                        ),
                        separatorBuilder: (_, index) =>
                            IsmChatDimens.boxHeight10,
                      ),
                    ],
                  );
                },
              ),
      );
}

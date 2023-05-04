import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatSearchDelegate extends SearchDelegate<void> {
  final _controller = Get.find<IsmChatConversationsController>();

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () {
              query = '';
            },
          ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          close(context, null);
        },
      );

  @override
  Widget buildResults(BuildContext context) => Obx(
        () => _controller.suggestions.isEmpty
            ? Center(
                child: Text(
                  IsmChatStrings.noMatch,
                  style: IsmChatStyles.w600Black20,
                ),
              )
            : ListView.builder(
                itemCount: _controller.suggestions.length,
                itemBuilder: (_, index) =>
                    IsmChatConversationCard(_controller.suggestions[index]),
              ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    _controller.onSearch(query);
    return Obx(
      () => _controller.suggestions.isEmpty
          ? Center(
              child: Text(
                IsmChatStrings.noMatch,
                style: IsmChatStyles.w600Black20,
              ),
            )
          : ListView.builder(
              itemCount: _controller.suggestions.length,
              itemBuilder: (_, index) => IsmChatConversationCard(
                _controller.suggestions[index],
                nameBuilder: (_, name) {
                  if (!name.didMatch(query)) {
                    return null;
                  }
                  var before = name.substring(
                      0, name.toLowerCase().indexOf(query.toLowerCase()));
                  var match = name.substring(
                      before.length, before.length + query.length);
                  var after = name.substring(before.length + match.length);
                  return RichText(
                    text: TextSpan(
                      text: before,
                      style: IsmChatStyles.w600Black14,
                      children: [
                        TextSpan(
                          text: match,
                          style: TextStyle(
                              color: IsmChatConfig.chatTheme.primaryColor),
                        ),
                        TextSpan(
                          text: after,
                        ),
                      ],
                    ),
                  );
                },
                subtitleBuilder: (_, msg) {
                  if (!msg.didMatch(query)) {
                    return null;
                  }
                  var before = msg.substring(
                      0, msg.toLowerCase().indexOf(query.toLowerCase()));
                  var match = msg.substring(
                      before.length, before.length + query.length);
                  var after = msg.substring(before.length + match.length);
                  return RichText(
                    text: TextSpan(
                      text: before,
                      style: IsmChatStyles.w400Black12,
                      children: [
                        TextSpan(
                          text: match,
                          style: TextStyle(
                            color: IsmChatConfig.chatTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: after,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
    );
  }
}

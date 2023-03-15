import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSearchDelegate extends SearchDelegate<void> {
  final _controller = Get.find<ChatConversationsController>();

  @override
  List<Widget> buildActions(BuildContext context) => [
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
            ? const Text(ChatStrings.noMatch)
            : ListView.builder(
                itemCount: _controller.suggestions.length,
                itemBuilder: (_, index) =>
                    ChatConversationCard(_controller.suggestions[index]),
              ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    _controller.onSearch(query);
    return Obx(
      () => _controller.suggestions.isEmpty
          ? const Text(ChatStrings.noMatch)
          : ListView.builder(
              itemCount: _controller.suggestions.length,
              itemBuilder: (_, index) =>
                  ChatConversationCard(_controller.suggestions[index]),
            ),
    );
  }
}

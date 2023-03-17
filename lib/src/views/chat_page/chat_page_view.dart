import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPageView extends StatefulWidget {
  const ChatPageView({super.key});

  @override
  State<ChatPageView> createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  @override
  void initState() {
    super.initState();
    ChatPageBinding().dependencies();
  }

  @override
  Widget build(BuildContext context) => GetX<ChatPageController>(
        builder: (controller) => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: const ChatPageHeader(),
          body: Column(
            children: [
              Expanded(
                child: TapHandler(
                  onTap: controller.focusNode.unfocus,
                  child: Center(
                    child: Text(
                      controller.messages.isEmpty
                          ? ChatStrings.noConversation
                          : controller.messages.length.toString(),
                      style: ChatStyles.w600Black20.copyWith(
                        color: ChatTheme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const ChatInputField(),
            ],
          ),
          // bottomNavigationBar: const ChatInputField(),
        ),
      );
}

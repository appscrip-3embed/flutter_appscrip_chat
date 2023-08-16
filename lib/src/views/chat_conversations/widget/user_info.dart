import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatUserView extends StatelessWidget {
  const IsmChatUserView({
    super.key,
  });

  static const String route = IsmPageRoutes.userView;

  @override
  Widget build(BuildContext context) => GetX<IsmChatConversationsController>(
      builder: (controller) => Scaffold(
            backgroundColor: IsmChatColors.whiteColor,
            appBar: IsmChatAppBar(
              onBack: Get.back,
              title: Text(
                IsmChatStrings.contactInfo,
                style: IsmChatStyles.w600White18,
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IsmChatDimens.boxHeight16,
                    Stack(
                      children: [
                        IsmChatImage.profile(
                          controller.userDetails?.profileUrl ?? '',
                          dimensions: IsmChatDimens.oneHundredFifty,
                        ),
                        Positioned(
                          bottom: IsmChatDimens.ten,
                          right: IsmChatDimens.ten,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.grey)),
                            width: IsmChatDimens.thirty,
                            height: IsmChatDimens.thirty,
                            child: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: IsmChatDimens.fifteen,
                            ),
                          ),
                        )
                      ],
                    ),
                    IsmChatDimens.boxHeight16,
                    Container(
                      decoration: BoxDecoration(
                        color: IsmChatConfig.chatTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(
                          IsmChatDimens.ten,
                        ),
                      ),
                      padding: IsmChatDimens.edgeInsets16,
                      margin: IsmChatDimens.edgeInsets20_0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: IsmChatStyles.w400White16.copyWith(
                              color: IsmChatConfig.chatTheme.primaryColor,
                            ),
                          ),
                          IsmChatDimens.boxHeight10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.userDetails?.userName ?? '',
                                style: IsmChatStyles.w600Black16,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: IsmChatDimens.twenty,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.userDetails?.userIdentifier ?? '',
                                style: IsmChatStyles.w600Black16,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: IsmChatDimens.twenty,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
}

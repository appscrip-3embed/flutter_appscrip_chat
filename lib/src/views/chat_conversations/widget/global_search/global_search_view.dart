import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatGlobalSearchView extends StatefulWidget {
  const IsmChatGlobalSearchView({super.key});

  static const String route = IsmPageRoutes.globalSearch;

  @override
  State<IsmChatGlobalSearchView> createState() =>
      _IsmChatGlobalSearchViewState();
}

class _IsmChatGlobalSearchViewState extends State<IsmChatGlobalSearchView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: IsmChatAppBar(
          title: Text(
            IsmChatStrings.search,
            style: IsmChatStyles.w600White18,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: IsmChatDimens.fifty,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Text('Converstion'),
                  Text('Message'),
                  Text('User')
                ],
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: const [
                IsmChatConversationSearchView(),
                IsmChatMessageSearchView(),
                IsmChatUserSearchView()
              ]),
            )
          ],
        ),
      );
}

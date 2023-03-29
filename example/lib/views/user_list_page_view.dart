import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:flutter/material.dart';

class UserListPageView extends StatelessWidget {
  const UserListPageView({super.key});

  static const String route = AppRoutes.userListPage;

  @override
  Widget build(BuildContext context) {
    return const IsmUserPageView();
  }
}

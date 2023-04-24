// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatMediaiAssetsPage extends StatefulWidget {
  const IsmChatMediaiAssetsPage({super.key});

  @override
  State<IsmChatMediaiAssetsPage> createState() => _MultiAssetsPageState();
}

class _MultiAssetsPageState extends State<IsmChatMediaiAssetsPage>
    with AutomaticKeepAliveClientMixin, GalleryPageMixin {
  @override
  int get maxAssetsCount => 5;

  @override
  IsmChatPickMethod get pickMethods => IsmChatPickMethod.common(maxAssetsCount);

  @override
  bool get wantKeepAlive => true;
}

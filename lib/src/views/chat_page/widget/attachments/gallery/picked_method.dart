// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// Define a regular pick method.
class IsmChatPickMethod {
  const IsmChatPickMethod({
    required this.method,
  });

  factory IsmChatPickMethod.common(int maxAssetsCount) => IsmChatPickMethod(
        method: (BuildContext context, List<AssetEntity> assets) =>
            AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
          ),
        ),
      );

  /// The core function that defines how to use the picker.
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;
}

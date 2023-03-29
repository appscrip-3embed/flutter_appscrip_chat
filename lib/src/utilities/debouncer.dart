import 'dart:async';
import 'package:flutter/material.dart';

class IsmChatDebounce {
  VoidCallback? action;
  Timer? _timer;

  void run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 750), action);
  }
}
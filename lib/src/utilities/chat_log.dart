import 'dart:developer';

import 'package:appscrip_chat_component/src/res/strings.dart';

class ChatLog {
  ///This Constructor of `ChatLog` take 2 parameters
  ///```dart
  ///final dynamic message //This will be displayed in console
  ///final StackTrace? stackTrace //Optional
  ///```
  ///will be used to log the `message` with `yellow` color.
  ///
  ///It can be used for error logs
  ///
  ///You can use other constructors for different type of logs
  ///eg.
  ///- `ChatLog()` - for basic log
  ///- `ChatLog.info()` - for info log
  ///- `ChatLog.success()` - for success log
  ChatLog.error(this.message, [this.stackTrace]) {
    log(
      '\x1B[31m[${ChatStrings.name}] - $message\x1B[0m',
      stackTrace: stackTrace,
      name: 'Error',
      level: 1200,
    );
  }

  ///This Constructor of `ChatLog` take 2 parameters
  ///```dart
  ///final dynamic message //This will be displayed in console
  ///final StackTrace? stackTrace //Optional
  ///```
  ///will be used to log the `message` with `yellow` color.
  ///
  ///It can be used for success logs
  ///
  ///You can use other constructors for different type of logs
  ///eg.
  ///- `ChatLog()` - for basic log
  ///- `ChatLog.info()` - for info log
  ///- `ChatLog.error()` - for error log
  ChatLog.success(this.message, [this.stackTrace]) {
    log(
      '\x1B[32m[${ChatStrings.name}] - $message\x1B[0m',
      stackTrace: stackTrace,
      name: 'Success',
      level: 800,
    );
  }

  ///This Constructor of `ChatLog` take 2 parameters
  ///```dart
  ///final dynamic message //This will be displayed in console
  ///final StackTrace? stackTrace //Optional
  ///```
  ///will be used to log the `message` with `yellow` color.
  ///
  ///It can be used for information logs
  ///
  ///You can use other constructors for different type of logs
  ///eg.
  ///- `ChatLog()` - for basic log
  ///- `ChatLog.success()` - for success log
  ///- `ChatLog.error()` - for error log
  ChatLog.info(this.message, [this.stackTrace]) {
    log(
      '\x1B[33m[${ChatStrings.name}] - $message\x1B[0m',
      stackTrace: stackTrace,
      name: 'Info',
      level: 900,
    );
  }

  ///This Constructor of `ChatLog` take 2 parameters
  ///```dart
  ///final dynamic message //This will be displayed in console
  ///final StackTrace? stackTrace //Optional
  ///```
  ///will be used to log the `message` with `yellow` color.
  ///
  ///It can be used for basic logs
  ///
  ///You can use other constructors for different type of logs
  ///eg.
  ///- `ChatLog.info()` - for information log
  ///- `ChatLog.success()` - for success log
  ///- `ChatLog.error()` - for error log
  ChatLog(this.message, [this.stackTrace]) {
    log(
      '\x1B[37m[${ChatStrings.name}] - $message\x1B[0m',
      // '[${ChatStrings.name}] - $message',
      stackTrace: stackTrace,
      level: 700,
    );
  }
  final dynamic message;
  final StackTrace? stackTrace;
}

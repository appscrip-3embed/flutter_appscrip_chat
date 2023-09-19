import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatPageProperties {
  IsmChatPageProperties({
    this.header,
    this.placeholder,
    this.messageBuilder,
    this.attachments = IsmChatAttachmentType.values,
    this.features = IsmChatFeature.values,
    this.attachmentConfig,
    this.messageAllowedConfig,
    this.onForwardTap,
    this.emojiIcon,
  });

  final Widget? placeholder;

  /// Provide this widget show emoji icon in message type input filed
  final Widget? emojiIcon;

  final MessageWidgetBuilder? messageBuilder;

  /// It is an optional parameter which take List of `IsmChatAttachmentType` which is an enum.
  /// Pass in the types of attachments that you want to allow.
  ///
  /// Defaults to all
  final List<IsmChatAttachmentType> attachments;

  /// It is an optional parameter which take List of `IsmChatFeature` which is an enum.
  /// Pass in the types of features that you want to allow.
  ///
  /// Defaults to all
  final List<IsmChatFeature> features;

  final IsmChatPageHeaderProperties? header;

  /// It is an optional parameter you can you for meessage send allow or not
  final MessageAllowedConfig? messageAllowedConfig;

  final AttachmentConfig? attachmentConfig;

  /// Required parameter
  ///
  /// Primarily designed for nagivating to Message screen
  ///
  /// ```dart
  /// void Function(BuildContext, IsmChatConversationModel) onForwardTap;
  /// ```
  ///
  /// `IsmChatConversationModel` gives data of current chat, it could be used for local storage or state variables
  final ConversationVoidCallback? onForwardTap;
}

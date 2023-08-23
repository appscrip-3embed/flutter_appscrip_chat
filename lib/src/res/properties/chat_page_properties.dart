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
  });

  final Widget? placeholder;
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
}

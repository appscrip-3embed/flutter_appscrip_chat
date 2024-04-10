import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatPageMessageAcknowldgeProperties {
  IsmChatPageMessageAcknowldgeProperties({
    this.profileImageBuilder,
    this.profileImageUrl,
    this.titleBuilder,
    this.title,
    this.trailingBuilder,
    this.trailing,
  });

  final UserDetailsWidgetCallback? profileImageBuilder;
  final UserDetailsStringCallback? profileImageUrl;
  final UserDetailsWidgetCallback? titleBuilder;
  final UserDetailsStringCallback? title;
   final UserDetailsWidgetCallback? trailingBuilder;
  final UserDetailsStringCallback? trailing;

}

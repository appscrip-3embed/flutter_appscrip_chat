import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_component/src/res/res.dart';
import 'package:chat_component/src/utilities/utilities.dart';
import 'package:flutter/material.dart';

class ChatImage extends StatelessWidget {
  const ChatImage(
    this.imageUrl, {
    this.name = 'U',
    super.key,
  });

  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: 48,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          height: 48,
          cacheKey: imageUrl,
          placeholder: (context, url) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ChatTheme.of(context).primaryColor!.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              name[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: ChatTheme.of(context).primaryColor,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            ChatLog.error('ImageError');
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ChatTheme.of(context).primaryColor!.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                name[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: ChatTheme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      );
}

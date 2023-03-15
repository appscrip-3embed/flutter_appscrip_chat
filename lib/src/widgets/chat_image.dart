import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatImage extends StatelessWidget {
  const ChatImage(
    this.imageUrl, {
    this.name,
    this.dimensions = 48,
    super.key,
  }) : _name = 'U';

  final String imageUrl;
  final String? name;
  final double dimensions;

  final String _name;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: dimensions,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(dimensions / 2),
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
                _name[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: ChatTheme.of(context).primaryColor,
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              ChatLog.error('ImageError - $url\n$error');
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ChatTheme.of(context).primaryColor!.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: ChatTheme.of(context).primaryColor,
                  ),
                ),
              );
            },
          ),
        ),
      );
}

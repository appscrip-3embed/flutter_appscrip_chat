import 'dart:io';

import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatImage extends StatelessWidget {
  const IsmChatImage(
    this.imageUrl, {
    this.name,
    this.dimensions,
    this.isNetworkImage = true,
    super.key,
  })  : _name = name ?? 'U',
        _isProfileImage = false;

  const IsmChatImage.profile(
    this.imageUrl, {
    this.name,
    this.dimensions = 48,
    this.isNetworkImage = true,
    super.key,
  })  : _name = name ?? 'U',
        _isProfileImage = true,
        assert(dimensions != null, 'Dimensions cannot be null');

  final String imageUrl;
  final String? name;
  final double? dimensions;
  final bool isNetworkImage;

  final String _name;
  final bool _isProfileImage;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: _isProfileImage ? dimensions : context.width * 0.6,
        child: ClipRRect(
          borderRadius: _isProfileImage
              ? BorderRadius.circular(dimensions! / 2)
              : BorderRadius.circular(IsmChatDimens.eight),
          child: isNetworkImage
              ? _NetworkImage(
                  imageUrl: imageUrl,
                  isProfileImage: _isProfileImage,
                  name: _name)
              : _AssetImage(imageUrl: imageUrl),
        ),
      );
}

class _AssetImage extends StatelessWidget {
  const _AssetImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) => Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
      );
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({
    required this.imageUrl,
    required bool isProfileImage,
    required String name,
  })  : _isProfileImage = isProfileImage,
        _name = name;

  final String imageUrl;
  final bool _isProfileImage;
  final String _name;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        cacheKey: imageUrl,
        imageBuilder: (_, image) => Container(
          decoration: BoxDecoration(
            shape: _isProfileImage ? BoxShape.circle : BoxShape.rectangle,
            color: IsmChatConfig.chatTheme.backgroundColor!,
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: IsmChatTheme.of(context).primaryColor!.withOpacity(0.2),
            shape: _isProfileImage ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: _isProfileImage
              ? Text(
                  _name[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: IsmChatTheme.of(context).primaryColor,
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
        ),
        errorWidget: (context, url, error) {
          IsmChatLog.error('ImageError - $url\n$error');
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: IsmChatTheme.of(context).primaryColor!.withOpacity(0.2),
              shape: _isProfileImage ? BoxShape.circle : BoxShape.rectangle,
            ),
            child: _isProfileImage
                ? Text(
                    _name[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: IsmChatTheme.of(context).primaryColor,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: IsmChatColors.greyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(IsmChatDimens.eight),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      IsmChatStrings.errorLoadingImage,
                    ),
                  ),
          );
        },
      );
}

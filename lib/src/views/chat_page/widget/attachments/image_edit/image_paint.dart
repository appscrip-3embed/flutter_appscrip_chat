import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class IsmChatImagePainterWidget extends StatefulWidget {
  const IsmChatImagePainterWidget({super.key, required this.file});

  final File file;

  @override
  State<IsmChatImagePainterWidget> createState() => _ImagePainterWidgetState();
}

class _ImagePainterWidgetState extends State<IsmChatImagePainterWidget> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => Scaffold(
        key: _key,
        appBar: AppBar(
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back,
              color: IsmChatColors.whiteColor,
            ),
            onTap: () {
              Get.back<File>(result: widget.file);
            },
          ),
          backgroundColor: IsmChatConfig.chatTheme.primaryColor,
          actions: [
            TextButton(
              onPressed: () async {
                IsmChatUtility.showLoader();
                final image = await _imageKey.currentState?.exportImage();

                final pathSplite = widget.file.path.split('/').last;
                final extensionSplite = pathSplite.split('.');

                final extension = extensionSplite.last;

                final directory =
                    (await getApplicationDocumentsDirectory()).path;
                await Directory('$directory/sample').create(recursive: true);
                final fullPath =
                    '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.$extension';

                final imgFile = File(fullPath);
                imgFile.writeAsBytesSync(image!);
                IsmChatUtility.closeLoader();
                Get.back<File>(result: imgFile);
                IsmChatLog.success('Image edit file $imgFile');
              },
              style: ButtonStyle(
                  side: const MaterialStatePropertyAll(
                    BorderSide(
                      color: IsmChatColors.whiteColor,
                    ),
                  ),
                  padding: MaterialStatePropertyAll(IsmChatDimens.edgeInsets10),
                  textStyle:
                      MaterialStateProperty.all(IsmChatStyles.w400White16)),
              child: Text(
                'Done',
                style: IsmChatStyles.w600White16,
              ),
            ),
            IsmChatDimens.boxWidth20,
          ],
        ),
        backgroundColor: IsmChatColors.blackColor,
        body: ImagePainter.file(
          File(widget.file.path),
          key: _imageKey,
          scalable: true,
          initialStrokeWidth: 2,
          // textDelegate: DutchTextDelegate(),
          initialColor: Colors.red,
          initialPaintMode: PaintMode.line,
          controlsAtTop: false,

          // clearAllIcon: ,
        ),
      );
}

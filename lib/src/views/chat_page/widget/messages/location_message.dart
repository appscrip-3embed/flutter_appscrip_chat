import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class IsmChatLocationMessage extends StatefulWidget {
  const IsmChatLocationMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  State<IsmChatLocationMessage> createState() => _IsmChatLocationMessageState();
}

class _IsmChatLocationMessageState extends State<IsmChatLocationMessage> {
  late LatLng position;
  late Set<Marker> markers;

  @override
  void initState() {
    super.initState();
    position = widget.message.body.position;
    markers = <Marker>{
      Marker(
        markerId: const MarkerId('2'),
        position: position,
        infoWindow: const InfoWindow(title: 'Shared Location'),
      ),
    };
  }

  @override
  Widget build(BuildContext context) => IsmChatTapHandler(
        onTap: () async {
          await launchUrl(
            Uri.parse(widget.message.body),
            mode: LaunchMode.externalApplication,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: IsmChatDimens.oneHundredFifty,
                  width: context.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(IsmChatDimens.ten),
                    child: IgnorePointer(
                      child: GetBuilder<IsmChatPageController>(
                        builder: (controller) => GoogleMap(
                          onMapCreated: (mapController) =>
                              controller.googleMapCompleter.complete,
                          initialCameraPosition:
                              CameraPosition(target: position, zoom: 16),
                          markers: markers,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          buildingsEnabled: true,
                          mapToolbarEnabled: false,
                          tiltGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          trafficEnabled: false,
                        ),
                      ),
                    ),
                  ),
                ),
                IsmChatDimens.boxHeight4,
                Padding(
                  padding: IsmChatDimens.edgeInsets4_0,
                  child: Text(
                    widget.message.metaData?.locationAddress ?? '',
                    style: widget.message.style,
                  ),
                ),
                Padding(
                  padding: IsmChatDimens.edgeInsets4_0,
                  child: Text(
                    widget.message.metaData?.locationSubAddress ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: (widget.message.sentByMe
                            ? IsmChatStyles.w400White12
                            : IsmChatStyles.w400Black12)
                        .copyWith(
                      color: widget.message.style.color,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.message.isUploading == true)
              IsmChatUtility.circularProgressBar(IsmChatColors.blackColor,
                  IsmChatConfig.chatTheme.primaryColor),
          ],
        ),
      );
}

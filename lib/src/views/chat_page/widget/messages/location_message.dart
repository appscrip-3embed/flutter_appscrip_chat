import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      // liteModeEnabled: true,
                      mapToolbarEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: false,
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
                style: widget.message.sentByMe
                    ? IsmChatStyles.w600White16
                    : IsmChatStyles.w600Black16,
              ),
            ),
            FutureBuilder<List<Placemark>>(
              future: GeocodingPlatform.instance.placemarkFromCoordinates(
                position.latitude,
                position.longitude,
              ),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Text(
                    'Error fetching address',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(color: Colors.blueGrey),
                  );
                }
                var addressDetails = snapshot.data!.first;
                return Padding(
                  padding: IsmChatDimens.edgeInsets4_0,
                  child: Text(
                    addressDetails.toAddress(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: widget.message.sentByMe
                        ? IsmChatStyles.w400White12
                        : IsmChatStyles.w400Black12,
                  ),
                );
              },
            ),
            IsmChatDimens.boxHeight4,
          ],
        ),
      );
}

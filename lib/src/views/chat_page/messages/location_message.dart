import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class IsmChatLocationMessage extends StatelessWidget {
  const IsmChatLocationMessage(this.message, {super.key});

  final IsmChatChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    var position = message.body.position;
    var markers = <Marker>{
      Marker(
        markerId: const MarkerId('2'),
        position: position,
        infoWindow: const InfoWindow(title: 'Shared Location'),
      ),
    };
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () async {
        await launchUrl(
          Uri.parse(message.body),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Column(
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
                    liteModeEnabled: true,
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
                padding: IsmChatDimens.egdeInsets4_0,
                child: Text(
                  addressDetails.toAddress(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: message.sentByMe
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
}

import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

/// show the Forward Message View
class IsmChatLocationWidget extends StatefulWidget {
  const IsmChatLocationWidget({Key? key}) : super(key: key);

  @override
  State<IsmChatLocationWidget> createState() => _IsmLocationWidgetViewState();
}

class _IsmLocationWidgetViewState extends State<IsmChatLocationWidget> {
  final Completer<GoogleMapController> mapController = Completer();
  final ismChatPageController = Get.find<IsmChatPageController>();
  var uuid = const Uuid();

  final String sessionToken = '122334';

  GeoCode geoCode = GeoCode();

  final ismChatDebounce = IsmChatDebounce();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.7046, 76.7179),
    zoom: 14,
  );

  LatLng? latLng;

  final List<Marker> _markers = <Marker>[];

  Future<void> loadData() async => getUserCurrentLocation().then((value) async {
        _markers.add(
          Marker(
              markerId: const MarkerId('2'),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: const InfoWindow(title: 'Current Location')),
        );

        var cameraPosition = CameraPosition(
            zoom: 14, target: LatLng(value.latitude, value.longitude));

        final controller = await mapController.future;
        await controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        await ismChatPageController.getLocation(
            latitude: value.latitude.toString(),
            longitude: value.longitude.toString());
        setState(() {});
      });

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GetX<IsmChatPageController>(
        builder: (controller) => Scaffold(
          backgroundColor: IsmChatColors.whiteColor,
          appBar: AppBar(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            titleSpacing: 0,
            actions: <Widget>[
              IconButton(
                icon: controller.isSearchSelect
                    ? const Icon(
                        Icons.close,
                        color: IsmChatColors.whiteColor,
                      )
                    : const Icon(
                        Icons.search,
                        color: IsmChatColors.whiteColor,
                      ),
                onPressed: () async {
                  controller.isSearchSelect = !controller.isSearchSelect;
                  controller.textEditingController.clear();

                  if (!controller.isSearchSelect) {
                    await ismChatPageController.getLocation(
                        latitude: latLng!.latitude.toString(),
                        longitude: latLng!.longitude.toString());
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: IsmChatColors.whiteColor,
                ),
                onPressed: () async {
                  if (controller.textEditingController.text.isNotEmpty) {
                    controller.isSearchSelect = !controller.isSearchSelect;
                    controller.textEditingController.clear();
                  }

                  await ismChatPageController.getLocation(
                      latitude: latLng!.latitude.toString(),
                      longitude: latLng!.longitude.toString());
                },
              ),
            ],
            centerTitle: false,
            title: Row(
              children: [
                IsmChatDimens.boxWidth16,
                controller.isSearchSelect
                    ? Flexible(
                        child: IsmChatInputField(
                        fillColor: IsmChatConfig.chatTheme.primaryColor,
                        onFieldSubmitted: (input) async {
                          await ismChatPageController.getLocation(
                              searchKeyword: input,
                              latitude: latLng!.latitude.toString(),
                              longitude: latLng!.longitude.toString());
                        },
                        onChanged: (value) {
                          ismChatDebounce.run(
                            () async {
                              await ismChatPageController.getLocation(
                                  searchKeyword: value.isNotEmpty ? value : '',
                                  latitude: latLng!.latitude.toString(),
                                  longitude: latLng!.longitude.toString());
                            },
                          );
                        },
                        controller: controller.textEditingController,
                        textInputAction: TextInputAction.search,
                        autofocus: true,
                        cursorColor: IsmChatColors.whiteColor,
                        style: IsmChatStyles.w500White16,
                        hint: 'Search',
                        hintStyle: IsmChatStyles.w600White16,
                      ))
                    : Text(
                        'Send location',
                        style: controller.isSearchSelect
                            ? IsmChatStyles.w600Black16
                            : IsmChatStyles.w600White16,
                      ),
              ],
            ),
            leading: IconButton(
              onPressed: () {
                controller.isSearchSelect
                    ? controller.isSearchSelect = false
                    : Get.back<void>();
              },
              icon: Icon(
                Icons.adaptive.arrow_back,
                color: IsmChatColors.whiteColor,
              ),
            ),
            automaticallyImplyLeading: false,
            elevation: 1,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                SizedBox(
                    height: 285,
                    width: Get.width,
                    child: GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: mapController.complete,
                      myLocationButtonEnabled: false,
                      onCameraMove: (position) {
                        ismChatDebounce.run(() async {
                          latLng = LatLng(position.target.latitude,
                              position.target.longitude);
                          setState(() {});
                        });
                      },
                    )),
                Positioned(
                  right: 20,
                  top: 20,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () async {
                          await loadData();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.8),
                          ),
                          height: 35,
                          width: 35,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      )),
                ),
              ]),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IsmChatDimens.boxHeight16,
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Nearby Places',
                          style: IsmChatStyles.w400Grey10,
                        ),
                      ),
                      IsmChatDimens.boxHeight16,
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.my_location,
                              color: Colors.teal,
                            ),
                            IsmChatDimens.boxWidth8,
                            InkWell(
                              onTap: () async {
                                IsmChatUtility.showLoader();
                                var position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);
                                controller.sendLocation(
                                    conversationId: controller
                                            .conversation?.conversationId ??
                                        '',
                                    userId: controller.conversation
                                            ?.opponentDetails?.userId ??
                                        '',
                                    latitude: position.latitude,
                                    longitude: position.longitude,
                                    placeId: controller
                                            .predictionList.first.placeId ??
                                        '',
                                    locationName:
                                        controller.predictionList.first.name ??
                                            '');
                                Get.back<void>();
                                IsmChatUtility.closeLoader();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Send your current location',
                                  ),
                                  Text(
                                    'Accurate to 12 meters',
                                    style: IsmChatStyles.w400Grey10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (controller.predictionList.isEmpty) ...[
                        const SizedBox(
                          height: 100,
                        ),
                        if (controller.isLocaionSearch || _markers.isEmpty) ...[
                          const IsmChatLoadingDialog(),
                        ] else ...[
                          const Center(
                            child: Text('No data found'),
                          )
                        ]
                      ] else ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          addAutomaticKeepAlives: true,
                          itemCount: controller.predictionList.length,
                          itemBuilder: (context, index) {
                            var prediction = controller.predictionList[index];
                            return InkWell(
                              onTap: () async {
                                IsmChatUtility.showLoader();
                                var locations = await locationFromAddress(
                                    ismChatPageController
                                        .predictionList[index].vicinity
                                        .toString());
                                controller.sendLocation(
                                    conversationId: controller
                                            .conversation?.conversationId ??
                                        '',
                                    userId: controller.conversation
                                            ?.opponentDetails?.userId ??
                                        '',
                                    latitude: locations.first.latitude,
                                    longitude: locations.first.longitude,
                                    placeId: controller
                                            .predictionList[index].placeId ??
                                        '',
                                    locationName:
                                        controller.predictionList[index].name ??
                                            '');

                                Get.back<void>();
                                IsmChatUtility.closeLoader();
                              },
                              child: ListTile(
                                minLeadingWidth: 0,
                                leading: const Icon(
                                  Icons.house_siding,
                                ),
                                title: SizedBox(
                                  width: Get.width - 100,
                                  child: Text(
                                    prediction.name ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                subtitle: Text(
                                  prediction.vicinity ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).withUnfocusGestureDetctor(context),
      );
}

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class IsmChatDeviceConfig {
  void init() async {
    _info = DeviceInfoPlugin();

    if (GetPlatform.isAndroid) {
      _androidDeviceInfo = await _info.androidInfo;
    } else {
      _iosDeviceInfo = await _info.iosInfo;
    }
  }

  DeviceInfoPlugin _info = DeviceInfoPlugin();

  /// To get android device info
  AndroidDeviceInfo? _androidDeviceInfo;

  /// To get iOS device info
  IosDeviceInfo? _iosDeviceInfo;

  /// Device id
  String? get deviceId => GetPlatform.isAndroid
      ? _androidDeviceInfo?.id
      : _iosDeviceInfo?.identifierForVendor;

  /// Device make brand
  String? get deviceMake =>
      GetPlatform.isAndroid ? _androidDeviceInfo?.brand : 'Apple';

  /// Device Model
  String? get deviceModel => GetPlatform.isAndroid
      ? _androidDeviceInfo?.model
      : _iosDeviceInfo?.utsname.machine;

  /// Device is a type of 1 for Android and 2 for iOS
  String get deviceTypeCode => GetPlatform.isAndroid ? '1' : '2';

  /// Device OS
  String get deviceOs => GetPlatform.isAndroid
      ? '${_androidDeviceInfo?.version.codename}'
      : '${_iosDeviceInfo?.systemVersion}';
}

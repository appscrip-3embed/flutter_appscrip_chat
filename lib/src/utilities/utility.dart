import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';

class IsmChatUtility {
  const IsmChatUtility._();

  // static bool isLoaderOpen = Get.isDialogOpen ?? false;

  /// Show loader
  static void showLoader() async {
    var isLoaderOpen = Get.isDialogOpen;
    if (isLoaderOpen != null) {
      await Get.dialog<void>(
        (IsmChatConfig.loadingDialog) ?? const IsmChatLoadingDialog(),
        barrierDismissible: false,
      );
    }
  }

  static void closeLoader() {
    var isLoaderOpen = Get.isDialogOpen;
    if (isLoaderOpen != null) {
      Get.back(closeOverlays: false, canPop: true);
    }
  }

  /// common header for All api
  static Map<String, String> commonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': IsmChatConfig.communicationConfig.projectConfig.licenseKey,
      'appSecret': IsmChatConfig.communicationConfig.projectConfig.appSecret,
      'userSecret': IsmChatConfig.communicationConfig.projectConfig.userSecret,
    };
    return header;
  }

  /// Token common Header for All api
  static Map<String, String> tokenCommonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': IsmChatConfig.communicationConfig.projectConfig.licenseKey,
      'appSecret': IsmChatConfig.communicationConfig.projectConfig.appSecret,
      'userToken': IsmChatConfig.communicationConfig.userConfig.userToken,
    };
    return header;
  }

  /// this is for change encoded string to decode string
  static String decodePayload(String value) {
    try {
      return utf8.fuse(base64).decode(value);
    } catch (e) {
      IsmChatLog.error('Decode Error - $value');
      return value;
    }
  }

  /// this is for change decode string to encode string
  static String encodePayload(String value) => utf8.fuse(base64).encode(value);

  /// Method For Convert Duration To String
  static String durationToString({required Duration duration}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    var hour = num.parse(twoDigits(duration.inHours));
    if (hour > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  /// Video Type List For Every Platform
  static List<String> videoTypeList = [
    '.mp4',
    '.MP4',
    'webm',
    'mkv',
    'flv',
    'vob',
    'ogv',
    'ogg',
    'rrc',
    'gifv',
    'mng',
    'mov',
    'avi',
    'qt',
    'wmv',
    'yuv',
    'rm',
    'asf',
    'amv',
    'mp4',
    'MP4',
    'm4p',
    'm4v',
    'mpg',
    'mp2',
    'mpeg',
    'mpe',
    'mpv',
    'm4v',
    'svi',
    '3gp',
    '3g2',
    'mxf',
    'roq',
    'nsv',
    'flv',
    'f4v',
    'f4p',
    'f4a',
    'f4b',
    'mod',
  ];

  /// Image Type List For Every Platform
  static List<String> imageTypeList = [
    'ase',
    'art',
    'bmp',
    'blp',
    'cd5',
    'cit',
    'cpt',
    'cr2',
    'cut',
    'dds',
    'dib',
    'djvu',
    'egt',
    'exif',
    'gif',
    'gpl',
    'grf',
    'icns',
    'ico',
    'iff',
    'jng',
    'jpeg',
    'jpg',
    'jfif',
    'jp2',
    'jps',
    'lbm',
    'max',
    'miff',
    'mng',
    'msp',
    'nitf',
    'ota',
    'pbm',
    'pc1',
    'pc2',
    'pc3',
    'pcf',
    'pcx',
    'pdn',
    'pgm',
    'PI1',
    'PI2',
    'PI3',
    'pict',
    'pct',
    'pnm',
    'pns',
    'ppm',
    'psb',
    'psd',
    'pdd',
    'psp',
    'px',
    'pxm',
    'pxr',
    'qfx',
    'raw',
    'rle',
    'sct',
    'sgi',
    'rgb',
    'int',
    'bw',
    'tga',
    'tiff',
    'tif',
    'vtf',
    'xbm',
    'xcf',
    'xpm',
    '3dv',
    'amf',
    'ai',
    'awg',
    'cgm',
    'cdr',
    'cmx',
    'dxf',
    'e2d',
    'egt',
    'eps',
    'fs',
    'gbr',
    'odg',
    'svg',
    'stl',
    'vrml',
    'x3d',
    'sxd',
    'v2d',
    'vnd',
    'wmf',
    'emf',
    'art',
    'xar',
    'png',
    'webp',
    'jxr',
    'hdp',
    'wdp',
    'cur',
    'ecw',
    'iff',
    'lbm',
    'liff',
    'nrrd',
    'pam',
    'pcx',
    'pgf',
    'sgi',
    'rgb',
    'rgba',
    'bw',
    'int',
    'inta',
    'sid',
    'ras',
    'sun',
    'tga'
  ];
}

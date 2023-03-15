import 'package:chat_component_example/res/res.dart';

class Utility {
  const Utility._();

  /// common header for All api
  static Map<String, String> commonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': Constants.licenseKey,
      'appSecret': Constants.appSecret,
      'userSecret': Constants.userSecret,
    };
    return header;
  }

  /// Token common Header for All api
  static Map<String, String> tokenCommonHeader(String token) {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': Constants.licenseKey,
      'appSecret': Constants.appSecret,
      'userToken': token,
    };
    return header;
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiWrapper {
  const ApiWrapper._();

  static Future<ResponseModel> get(
    String api, {
    bool showLoader = false,
    required Map<String, String> headers,
  }) async {
    if (kDebugMode) {
      ChatLog('GET $api');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      Utility.showLoader();
    }
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
        Utility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        Utility.closeLoader();
      }
      return const ResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  static Future<ResponseModel> post(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      ChatLog('POST $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      Utility.showLoader();
    }
    try {
      final response = await http
          .post(
            uri,
            body: jsonEncode(payload),
            headers: headers,
          )
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
        Utility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        Utility.closeLoader();
      }
      return const ResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  static Future<ResponseModel> put(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      ChatLog('PUT $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      Utility.showLoader();
    }
    try {
      final response = await http
          .put(
            uri,
            body: jsonEncode(payload),
            headers: headers,
          )
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
        Utility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        Utility.closeLoader();
      }
      return const ResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  static Future<ResponseModel> patch(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      ChatLog('PATCH $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      Utility.showLoader();
    }
    try {
      final response = await http
          .patch(
            uri,
            body: jsonEncode(payload),
            headers: headers,
          )
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
        Utility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        Utility.closeLoader();
      }
      return const ResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  static Future<ResponseModel> delete(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      ChatLog('DELETE $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      Utility.showLoader();
    }
    try {
      final response = await http
          .delete(
            uri,
            body: jsonEncode(payload),
            headers: headers,
          )
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
        Utility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        Utility.closeLoader();
      }
      return const ResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  static ResponseModel _processResponse(http.Response response) {
    if (kDebugMode) {
      ChatLog(
          '${response.request?.method} ${response.statusCode} ${response.request?.url}\n${response.body}');
    }
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 208:
        return ResponseModel(
          data: response.body,
          hasError: false,
          errorCode: response.statusCode,
        );
      case 400:
      case 401:
      case 404:
      case 409:
      case 422:
      case 500:
      case 503:
      case 522:

      default:
        return ResponseModel(
          data: response.body,
          hasError: true,
          errorCode: response.statusCode,
        );
    }
  }
}

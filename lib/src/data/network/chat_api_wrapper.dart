import 'dart:async';
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class IsmChatApiWrapper {
  Future<IsmChatResponseModel> get(
    String api, {
    bool showLoader = false,
    required Map<String, String> headers,
  }) async {
    if (kDebugMode) {
      IsmChatLog('Request - GET $api');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      IsmChatUtility.showLoader();
    }
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
         IsmChatLog.error('fdsdfsfdfd $showLoader');
        IsmChatUtility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        IsmChatUtility.closeLoader();
      }
      return const IsmChatResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  Future<IsmChatResponseModel> post(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      IsmChatLog('Request - POST $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      IsmChatUtility.showLoader();
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
        IsmChatUtility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        IsmChatUtility.closeLoader();
      }
      return const IsmChatResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  Future<IsmChatResponseModel> put(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
    bool forAwsUpload = false,
  }) async {
    if (kDebugMode) {
      IsmChatLog('Request - PUT $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      IsmChatUtility.showLoader();
    }
    try {
      final response = await http
          .put(
            uri,
            body: forAwsUpload ? payload : jsonEncode(payload),
            headers: headers,
          )
          .timeout(const Duration(seconds: 60));

      if (showLoader) {
        IsmChatUtility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        IsmChatUtility.closeLoader();
      }
      return const IsmChatResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  Future<IsmChatResponseModel> patch(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      IsmChatLog('Request - PATCH $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      IsmChatUtility.showLoader();
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
        IsmChatUtility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        IsmChatUtility.closeLoader();
      }
      return const IsmChatResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  Future<IsmChatResponseModel> delete(
    String api, {
    required dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
  }) async {
    if (kDebugMode) {
      IsmChatLog('Request - DELETE $api $payload');
    }
    var uri = Uri.parse(api);
    if (showLoader) {
      IsmChatUtility.showLoader();
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
        IsmChatUtility.closeLoader();
      }

      return _processResponse(response);
    } on TimeoutException catch (_) {
      if (showLoader) {
        IsmChatUtility.closeLoader();
      }
      return const IsmChatResponseModel(
        data: '{"message":"Request timed out"}',
        hasError: true,
        errorCode: 1000,
      );
    }
  }

  IsmChatResponseModel _processResponse(http.Response response) {
    if (kDebugMode) {
      IsmChatLog(
          'Response - ${response.request?.method} ${response.statusCode} ${response.request?.url}\n${response.body}');
    }
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 208:
        return IsmChatResponseModel(
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
        return IsmChatResponseModel(
          data: response.body,
          hasError: true,
          errorCode: response.statusCode,
        );
    }
  }
}

import 'dart:convert';

class ResponseModel {
  factory ResponseModel.fromJson(String source) =>
      ResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ResponseModel.fromMap(Map<String, dynamic> map) => ResponseModel(
        data: map['data'] as String,
        hasError: map['hasError'] as bool,
        errorCode: map['errorCode'] as int,
      );

  const ResponseModel({
    required this.data,
    required this.hasError,
    required this.errorCode,
  });

  final String data;
  final bool hasError;
  final int errorCode;

  ResponseModel copyWith({
    String? data,
    bool? hasError,
    int? errorCode,
  }) =>
      ResponseModel(
        data: data ?? this.data,
        hasError: hasError ?? this.hasError,
        errorCode: errorCode ?? this.errorCode,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'data': data,
        'hasError': hasError,
        'errorCode': errorCode,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ResponseModel(data: $data, hasError: $hasError, errorCode: $errorCode)';

  @override
  bool operator ==(covariant ResponseModel other) {
    if (identical(this, other)) return true;

    return other.data == data &&
        other.hasError == hasError &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode => data.hashCode ^ hasError.hashCode ^ errorCode.hashCode;
}

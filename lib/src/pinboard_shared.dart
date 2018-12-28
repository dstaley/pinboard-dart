import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import './pinboard_client.dart';

/// Convert a boolean to Pinboard's `yes/no` type.
String boolToYesNo({
  @required bool value,
}) {
  return value ? 'yes' : 'no';
}

/// Convert Pinboard's `yes/no` type to a boolean.
bool yesNoToBool({
  @required String value,
}) {
  return value == 'yes';
}

/// Base class from which all other resources extend.
class PinboardResource {
  /// The path of the resource.
  String path;
  PinboardClient _pb;

  /// Pinboard's API endpoint.
  static const endpoint = 'https://api.pinboard.in/v1';

  /// Create an instance of a PinboardResource.
  PinboardResource(
    this._pb, {
    @required this.path,
  });

  /// Make a request to the Pinboard API.
  Future<T> request<T>({
    @required String method,
    Map<String, String> options,
  }) async {
    var optionsWithAuthToken = Map<String, Object>.from(options ?? {})
      ..addAll({
        'auth_token': '${_pb.username}:${_pb.token}',
        'format': 'json',
      });

    final uri = Uri(
      scheme: 'https',
      host: 'api.pinboard.in',
      path: 'v1/$path/$method',
      queryParameters: optionsWithAuthToken,
    );
    final response = await _pb.client.get(uri);
    return json.decode(response.body) as T;
  }
}

/// Represents the response to cetain Pinboard API calls that return a map with
/// a `result` key.
class PinboardResult {
  /// The result of the API call.
  String result;

  /// Create an instance of a PinboardResult.
  PinboardResult({
    this.result,
  });

  /// Create an instance of a PinboardResult from JSON.
  factory PinboardResult.fromJson(Map<String, Object> json) {
    return PinboardResult(
      result: json['result'],
    );
  }

  String toString() {
    var properties = {
      'result': result,
    };
    return 'PinboardResult$properties';
  }
}

/// Represents an API response containing a map with a `result_code` key.
class PinboardResultCode {
  /// The result code.
  // ignore: non_constant_identifier_names
  String result_code;

  /// Create an instance of PinboardResultCode.
  PinboardResultCode({
    // ignore: non_constant_identifier_names
    this.result_code,
  });

  /// Create an instance of PinboardResultCode from JSON.
  factory PinboardResultCode.fromJson(Map<String, Object> json) {
    return PinboardResultCode(
      result_code: json['result_code'],
    );
  }

  String toString() {
    var properties = {
      'result_code': result_code,
    };
    return 'PinboardResultCode$properties';
  }
}

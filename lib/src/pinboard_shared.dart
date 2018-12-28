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

/// Base Exception class
class PinboardError implements Exception {
  /// The error message
  final String message;

  /// Create an instance of PinboardError
  PinboardError(this.message);

  @override
  String toString() => 'Pinboard Error: $message';
}

/// Thrown when the Pinboard API returns a 401 (or when a token isn't set).
class UnauthorizedError extends PinboardError {
  /// Create an instance of UnauthorizedError
  UnauthorizedError(String message) : super(message);
}

/// Thrown when the Pinboard API returns a 403.
class ForbiddenError extends PinboardError {
  /// Create an instance of ForbiddenError
  ForbiddenError(String message) : super(message);
}

/// Thrown when the Pinboard API returns a 404.
class NotFoundError extends PinboardError {
  /// Create an instance of NotFoundError
  NotFoundError(String message) : super(message);
}

/// Thrown when the Pinboard API returns a 429.
class TooManyRequestsError extends PinboardError {
  /// Create an instance of TooManyRequestsError
  TooManyRequestsError(String message) : super(message);
}

/// Thrown when the Pinboard API returns a 500.
class InternalServerError extends PinboardError {
  /// Create an instance of InternalServerError
  InternalServerError(String message) : super(message);
}

/// Thrown when the Pinboard API returns a 503.
class ServiceUnavailableError extends PinboardError {
  /// Create an instance of ServiceUnavailableError
  ServiceUnavailableError(String message) : super(message);
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
    if (_pb.username == null || _pb.token == null) {
      throw UnauthorizedError('username and token must not be null');
    }
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
    switch (response.statusCode) {
      case 401:
        throw UnauthorizedError(response.body);
        break;
      case 403:
        throw ForbiddenError('Forbidden');
        break;
      case 404:
        throw NotFoundError('Item not found.');
        break;
      case 429:
        throw TooManyRequestsError('Too many requests.');
        break;
      case 500:
        throw InternalServerError('Internal Server Error');
        break;
      case 503:
        throw ServiceUnavailableError('Service Unavailable');
        break;
      default:
        break;
    }
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

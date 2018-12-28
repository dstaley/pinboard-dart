import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

/// The underlying client that manages requests to the Pinboard API. You
/// should never need to manually create this.
class PinboardClient {
  /// Pinboard username
  String username;

  /// Pinboard API token
  String token;

  /// The [http.Client] to use for all requests.
  final http.Client client;

  /// The API endpoint for Pinboard.
  static const endpoint = 'https://api.pinboard.in/v1';

  /// Create an instance of a PinboardClient.
  PinboardClient({
    @required this.username,
    this.token,
    http.Client client,
  }) : this.client = client == null ? http.Client() : client;

  /// Login to Pinboard with a password. Stores the token for future use.
  Future<void> loginWithPassword({
    @required String password,
  }) async {
    final response = await client.get(
      '$endpoint/user/api_token?format=json',
      headers: {
        HttpHeaders.authorizationHeader:
            "Basic ${base64.encode(utf8.encode("$username:$password"))}",
      },
    );

    final data = json.decode(response.body) as Map<String, Object>;
    this.token = data['result'] as String;
  }

  String toString() {
    var properties = {
      'username': username,
      'token': token,
    };
    return 'Pinboard$properties';
  }
}

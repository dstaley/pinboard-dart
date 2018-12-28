import './pinboard_client.dart';
import './pinboard_shared.dart';

/// Class containing the methods for the `user` resource of the Pinboard API.
class UserResource extends PinboardResource {
  /// Create an instance of UserResource.
  UserResource(PinboardClient _pb) : super(_pb, path: 'user');

  /// Returns the user's secret RSS key (for viewing private feeds)
  Future<PinboardResult> secret() async {
    var response = await this.request<Map>(
      method: 'secret',
    );
    return PinboardResult.fromJson(response);
  }

  /// Returns the user's API token (for making API calls without a password)
  // ignore: non_constant_identifier_names
  Future<PinboardResult> api_token() async {
    var response = await this.request<Map>(
      method: 'api_token',
    );
    return PinboardResult.fromJson(response);
  }
}

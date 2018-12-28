import 'package:meta/meta.dart';

import './pinboard_client.dart';
import './pinboard_shared.dart';

/// Class containing the methods for the `tags` resource of the Pinboard API.
class TagsResource extends PinboardResource {
  /// Create an instance of TagsResource.
  TagsResource(PinboardClient _pb) : super(_pb, path: 'tags');

  /// Returns a full list of the user's tags along with the number of times
  /// they were used.
  Future<Map<String, String>> get() async {
    var response = await this.request<Map>(
      method: 'get',
    );
    return response.cast<String, String>();
  }

  /// Delete an existing tag.
  Future<PinboardResult> delete({@required String tag}) async {
    var options = <String, String>{
      'tag': tag,
    };

    var response = await this.request<Map>(
      method: 'delete',
      options: options,
    );
    return PinboardResult.fromJson(response);
  }

  /// Rename an tag, or fold it in to an existing tag
  Future<PinboardResult> rename({
    @required String old,
    // ignore: non_constant_identifier_names
    @required String new_,
  }) async {
    var options = <String, String>{
      'old': old,
      'new': new_,
    };

    var response = await this.request<Map>(
      method: 'rename',
      options: options,
    );
    return PinboardResult.fromJson(response);
  }
}

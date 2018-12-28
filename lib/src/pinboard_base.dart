import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import './pinboard_client.dart';
import './pinboard_notes.dart';
import './pinboard_posts.dart';
import './pinboard_tags.dart';
import './pinboard_user.dart';

/// The main Pinboard API client. Provides access to all the API methods.
class Pinboard {
  /// Pinboard username
  String username;

  /// Pinboard API token
  String token;

  /// The [http.Client] to use for all requests.
  http.Client client;

  PinboardClient _client;
  PostsResource _posts;
  TagsResource _tags;
  UserResource _user;
  NotesResource _notes;

  /// Create an instance of a Pinboard client.
  Pinboard({
    @required this.username,
    this.token,
    http.Client client,
  }) {
    this._client =
        PinboardClient(username: username, token: token, client: client);
    this.client = _client.client;
  }

  /// Login to Pinboard with a password. Stores the token for future use.
  Future<void> loginWithPassword({
    @required String password,
  }) async {
    await this._client.loginWithPassword(password: password);
    this.token = this._client.token;
  }

  /// Access API methods relating to posts.
  PostsResource get posts {
    if (_posts == null) {
      _posts = PostsResource(this._client);
    }
    return _posts;
  }

  /// Access API methods relating to tags.
  TagsResource get tags {
    if (_tags == null) {
      _tags = TagsResource(this._client);
    }
    return _tags;
  }

  /// Access API methods relating to the user.
  UserResource get user {
    if (_user == null) {
      _user = UserResource(this._client);
    }
    return _user;
  }

  /// Access API methods relating to notes.
  NotesResource get notes {
    if (_notes == null) {
      _notes = NotesResource(this._client);
    }
    return _notes;
  }

  String toString() {
    var properties = {
      'username': username,
      'token': token,
    };
    return 'Pinboard$properties';
  }
}

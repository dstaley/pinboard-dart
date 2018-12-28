import 'package:meta/meta.dart';

import './pinboard_client.dart';
import './pinboard_shared.dart';

/// A representation of a Post on Pinbaord.
class Post {
  /// The URL to which the post points.
  String href;

  /// The title of the Post.
  String description;

  /// The extended description of the Post.
  String extended;

  /// Change detection signature
  String meta;

  /// MD5 hash of the href.
  String hash;

  /// Creation time of the Post.
  String time;

  /// Whether the Post is public.
  bool shared;

  /// Whether the Post is marked to read later.
  bool toread;

  /// The tags for the Post.
  List<String> tags;

  /// Create an instance of a Post.
  Post({
    this.href,
    this.description,
    this.extended,
    this.meta,
    this.hash,
    this.time,
    this.shared,
    this.toread,
    this.tags,
  });

  /// Create an instance of a Post from JSON>
  factory Post.fromJson(Map<String, Object> json) {
    return Post(
      href: json['href'],
      description: json['description'],
      extended: json['extended'],
      meta: json['meta'],
      hash: json['hash'],
      time: json['time'],
      shared: yesNoToBool(value: json['shared']),
      toread: yesNoToBool(value: json['toread']),
      tags: (json['tags'] as String).split(' '),
    );
  }

  String toString() {
    var properties = {
      'href': href,
      'description': description,
      'extended': extended,
      'meta': meta,
      'hash': hash,
      'time': time,
      'shared': shared,
      'toread': toread,
      'tags': tags,
    };
    return 'Post$properties';
  }
}

/// Represents the response to `/posts/dates`, which contains the number of
/// posts for a specific date.
class PinboardDates {
  /// The user for which this response is returning.
  String user;

  /// The `tag` for which this response is returning.
  String tag;

  /// The map of dates to string counts of posts.
  Map<String, String> dates;

  /// Create an instance of PinboardDates.
  PinboardDates({
    this.user,
    this.tag,
    this.dates,
  });

  /// Create a PinboardDates instance from JSON.
  factory PinboardDates.fromJson(Map<String, Object> json) {
    return PinboardDates(
      user: json['user'],
      tag: json['tag'],
      dates:
          json['dates'] is List ? {} : Map<String, String>.from(json['dates']),
    );
  }

  String toString() {
    var properties = {
      'user': user,
      'tag': tag,
      'dates': dates,
    };
    return 'PinboardDates$properties';
  }
}

/// Represents the response to `posts.get`.
class PinboardGetResponse {
  /// The DateTime that was requested.
  DateTime date;

  /// The user to which this response belongs.
  String user;

  /// The list of matching posts.
  List<Post> posts;

  /// Create an instance of a PinboardGetResponse.
  PinboardGetResponse({
    this.date,
    this.user,
    this.posts,
  });

  /// Create an instance of a PinboardGetResponse from JSON.
  factory PinboardGetResponse.fromJson(Map<String, Object> json) {
    return PinboardGetResponse(
      date: DateTime.parse(json['date']),
      user: json['user'],
      posts: List<Post>.from(
          (json['posts'] as List).map<Post>((Object p) => Post.fromJson(p))),
    );
  }

  String toString() {
    var properties = {
      'date': date,
      'user': user,
      'posts': posts,
    };
    return 'PinboardGetResponse$properties';
  }
}

/// Represents the response to `posts/update` containing the timestamp of the
/// last update to any post.
class PinboardUpdate {
  /// The last time any post was updated.
  // ignore: non_constant_identifier_names
  DateTime update_time;

  /// Create an instance of a PinboardUpdate.
  PinboardUpdate({
    // ignore: non_constant_identifier_names
    this.update_time,
  });

  /// Create an instance of a PinboardUpdate from JSON.reate an instance of a PinboardUpdate.
  factory PinboardUpdate.fromJson(Map<String, Object> json) {
    return PinboardUpdate(
      update_time: DateTime.parse(json['update_time']),
    );
  }

  String toString() {
    var properties = {
      'update_time': update_time,
    };
    return 'PinboardUpdate$properties';
  }
}

/// Class containing the methods for the `posts` resource of the Pinboard API.
class PostsResource extends PinboardResource {
  /// Create an instance of PostsResponse.
  PostsResource(PinboardClient _pb) : super(_pb, path: 'posts');

  /// Returns the most recent time a bookmark was added, updated or deleted.
  Future<PinboardUpdate> update() async {
    var response = await this.request<Map>(
      method: 'update',
    );
    return PinboardUpdate.fromJson(response);
  }

  /// Add a bookmark.
  Future<PinboardResultCode> add({
    @required String url,
    @required String description,
    String extended,
    String tag,
    DateTime dt,
    bool replace,
    bool shared,
    bool toread,
  }) async {
    var options = <String, String>{
      'url': url,
      'description': description,
    };
    if (extended != null) {
      options['extended'] = extended;
    }
    if (tag != null) {
      options['tag'] = tag;
    }
    if (dt != null) {
      options['dt'] = dt.toUtc().toIso8601String();
    }
    if (replace != null) {
      options['replace'] = boolToYesNo(value: replace);
    }
    if (shared != null) {
      options['shared'] = boolToYesNo(value: shared);
    }
    if (toread != null) {
      options['toread'] = boolToYesNo(value: toread);
    }

    var response = await this.request<Map>(
      method: 'add',
      options: options,
    );
    return PinboardResultCode.fromJson(response);
  }

  /// Delete a bookmark.
  Future<PinboardResultCode> delete({
    @required String url,
  }) async {
    var options = <String, String>{
      'url': url,
    };

    var response = await this.request<Map>(
      method: 'delete',
      options: options,
    );
    return PinboardResultCode.fromJson(response);
  }

  /// Returns one or more posts on a single day matching the arguments. If no
  /// date or url is given, date of most recent bookmark will be used.
  Future<PinboardGetResponse> get({
    String tag,
    DateTime dt,
    String url,
    bool meta,
  }) async {
    var options = <String, String>{};
    if (tag != null) {
      options['tag'] = tag;
    }
    if (dt != null) {
      options['dt'] = dt.toUtc().toIso8601String();
    }
    if (url != null) {
      options['url'] = url;
    }
    if (meta != null) {
      options['meta'] = boolToYesNo(value: meta);
    }

    var response = await this.request<Map>(
      method: 'get',
      options: options,
    );
    return PinboardGetResponse.fromJson(response);
  }

  /// Returns a list of the user's most recent posts, filtered by tag.
  Future<PinboardGetResponse> recent({
    String tag,
    int count,
  }) async {
    var options = <String, String>{};
    if (tag != null) {
      options['tag'] = tag;
    }
    if (count != null) {
      options['count'] = count.toString();
    }

    var response = await this.request<Map>(
      method: 'recent',
      options: options,
    );
    return PinboardGetResponse.fromJson(response);
  }

  /// Returns a list of dates with the number of posts at each date.
  Future<PinboardDates> dates({
    String tag,
  }) async {
    var options = <String, String>{};
    if (tag != null) {
      options['tag'] = tag;
    }

    var response = await this.request<Map>(
      method: 'dates',
      options: options,
    );
    return PinboardDates.fromJson(response);
  }

  /// Returns all bookmarks in the user's account.
  Future<List<Post>> all({
    String tag,
    int start,
    int results,
    DateTime fromdt,
    DateTime todt,
    int meta,
  }) async {
    var options = <String, String>{};
    if (tag != null) {
      options['tag'] = tag;
    }
    if (start != null) {
      options['start'] = start.toString();
    }
    if (results != null) {
      options['results'] = results.toString();
    }
    if (fromdt != null) {
      options['fromdt'] = fromdt.toUtc().toIso8601String();
    }
    if (todt != null) {
      options['todt'] = todt.toUtc().toIso8601String();
    }
    if (meta != null) {
      options['meta'] = meta.toString();
    }

    var response = await this.request<List>(
      method: 'all',
      options: options,
    );
    return response.map((Object p) => Post.fromJson(p)).toList();
  }

  /// Returns a list of popular tags and recommended tags for a given URL.
  /// Popular tags are tags used site-wide for the url; recommended tags are
  /// drawn from the user's own tags.
  Future<List<Map<String, List<String>>>> suggest({
    @required String url,
  }) async {
    var options = <String, String>{
      'url': url,
    };

    var response = await this.request<List>(
      method: 'suggest',
      options: options,
    );
    return response
        .map((i) => (i as Map).map((dynamic key, dynamic value) =>
            MapEntry<String, List<String>>(key, List<String>.from(value))))
        .toList();
  }
}

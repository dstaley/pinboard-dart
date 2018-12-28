import 'package:pinboard/pinboard.dart';

main() async {
  var client = Pinboard(username: 'test');
  await client.loginWithPassword(password: 'password123');

  // You can also create a client with a token if you happen to have one.
  // var client = Pinboard(username: 'dstaley', token: 'rubbadubdub');

  // Posts
  // Returns the most recent time a bookmark was added, updated or deleted.
  var lastUpdate = await client.posts.update();

  // Add a bookmark.
  var addPostResponse = await client.posts.add(
    url: 'https://getfirefox.com',
    description: 'Download Firefox — Free Web Browser — Mozilla',
    extended: 'The last remaining non-corporate web browser',
    tag: 'web-browser software open-source',
    dt: DateTime.parse('2018-12-25'),
    replace: false,
    shared: true,
    toread: false,
  );

  // Delete a bookmark.
  var deletePostResponse = await client.posts.delete(
    url: 'https://getfirefox.com',
  );

  // Returns one or more posts on a single day matching the arguments. If no
  // date or url is given, date of most recent bookmark will be used.
  var filteredPosts = await client.posts.get(
    tag: 'software',
    dt: DateTime.parse('2018-12-25'),
    url: 'https://getfirefox.com',
    meta: true,
  );

  // Returns a list of the user's most recent posts, filtered by tag.
  var recentPosts = await client.posts.recent(
    tag: 'software',
    count: 5,
  );

  // Returns a list of the user's most recent posts, filtered by tag.
  var dates = await client.posts.dates(
    tag: 'software',
  );

  // Returns all bookmarks in the user's account.
  var allPosts = await client.posts.all(
    tag: 'software',
    start: 10,
    results: 5,
    fromdt: DateTime.parse('2018-01-01'),
    todt: DateTime.parse('2018-12-31'),
    meta: 1,
  );

  // Returns a list of popular tags and recommended tags for a given URL.
  // Popular tags are tags used site-wide for the url; recommended tags are
  // drawn from the user's own tags.
  var suggestedTags = await client.posts.suggest(
    url: 'https://getfirefox.com',
  );

  // Tags
  // Returns a full list of the user's tags along with the number of times they
  // were used.
  var allTags = await client.tags.get();

  // Delete an existing tag.
  var deleteTagResponse = await client.tags.delete(
    tag: 'software',
  );

  // Rename an tag, or fold it in to an existing tag.
  var renameTagResponse = await client.tags.rename(
    old: 'open-source',
    new_: 'opensource',
  );

  // User
  // Returns the user's secret RSS key (for viewing private feeds).
  var secret = await client.user.secret();

  // Returns the user's API token (for making API calls without a password).
  var apiToken = await client.user.api_token();

  // Notes
  // Returns a list of the user's notes.
  var allNotes = await client.notes.list();

  // Returns an individual user note.
  var note = await client.notes.get(id: '14b66dd2cd8b7d70f1d1');
}

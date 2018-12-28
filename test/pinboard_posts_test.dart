import 'package:pinboard/pinboard.dart';
import 'package:pinboard/src/pinboard_posts.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Pinboard.posts', () {
    test('can get update', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(
            request.url.toString(),
            'https://api.pinboard.in/v1/posts/update?auth_token=test%3Athisisthetoken&format=json',
          );
          return Response(
            json.encode(
              {'update_time': '2018-12-23T07:05:49Z'},
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var lastUpdateTime = await client.posts.update();
      expect(
        lastUpdateTime.update_time,
        DateTime.parse('2018-12-23T07:05:49Z'),
      );
    });

    test('can add a post', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/add');
          expect(
            request.url.queryParameters,
            {
              'url': 'https://google.com',
              'description': 'text',
              'extended': 'extended description',
              'tag': 'wishlist new tag',
              'dt': '2018-12-26T08:00:00.000Z',
              'replace': 'no',
              'shared': 'no',
              'toread': 'yes',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {'result_code': 'result'},
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.add(
        url: 'https://google.com',
        description: 'text',
        extended: 'extended description',
        tag: 'wishlist new tag',
        dt: DateTime.parse('2018-12-26'),
        replace: false,
        shared: false,
        toread: true,
      );
      expect(
        response.result_code,
        'result',
      );
    });

    test('can delete a post', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/delete');
          expect(
            request.url.queryParameters,
            {
              'url': 'https://google.com',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {'result_code': 'done'},
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.delete(
        url: 'https://google.com',
      );
      expect(response.result_code, 'done');
    });

    test('can get posts', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/get');
          expect(
            request.url.queryParameters,
            {
              'tag': 'new',
              'dt': '2018-12-25T08:00:00.000Z',
              'url': 'https://google.com',
              'meta': 'yes',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {
                'date': '2018-07-16T05:24:18Z',
                'user': 'test',
                'posts': [
                  {
                    'href':
                        'https://novelkeys.xyz/products/25-slot-switch-tester',
                    'description': '',
                    'extended': '',
                    'meta': '508c6176f510c203098fb0c5e75fd53a',
                    'hash': '3e569b02bb9df0203afb604eea548ea0',
                    'time': '2018-12-23T07:05:49Z',
                    'shared': 'yes',
                    'toread': 'no',
                    'tags': 'wishlist new'
                  }
                ]
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.get(
        tag: 'new',
        dt: DateTime.parse('2018-12-25'),
        url: 'https://google.com',
        meta: true,
      );
      expect(response.date, isNotNull);
      expect(response.user, 'test');
      expect(response.posts.length, 1);
      expect(response.posts[0], TypeMatcher<Post>());
      expect(response.posts[0].shared, isTrue);
      expect(response.posts[0].toread, isFalse);
      expect(response.posts[0].tags, ['wishlist', 'new']);
    });

    test('can get recent posts', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/recent');
          expect(
            request.url.queryParameters,
            {
              'tag': 'new',
              'count': '1',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {
                'date': '2018-07-16T05:24:18Z',
                'user': 'test',
                'posts': [
                  {
                    'href':
                        'https://novelkeys.xyz/products/25-slot-switch-tester',
                    'description': '',
                    'extended': '',
                    'meta': '508c6176f510c203098fb0c5e75fd53a',
                    'hash': '3e569b02bb9df0203afb604eea548ea0',
                    'time': '2018-12-23T07:05:49Z',
                    'shared': 'yes',
                    'toread': 'no',
                    'tags': 'wishlist-new'
                  }
                ]
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.recent(
        tag: 'new',
        count: 1,
      );
      expect(response.date, isNotNull);
      expect(response.user, 'test');
      expect(response.posts.length, 1);
      expect(response.posts[0], TypeMatcher<Post>());
    });

    test('can get dates', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/dates');
          expect(
            request.url.queryParameters,
            {
              'tag': 'new',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {
                'user': 'test',
                'tag': 'new',
                'dates': {
                  '2018-12-23': '1',
                  '2018-12-21': '1',
                }
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.dates(
        tag: 'new',
      );
      expect(response.user, 'test');
      expect(response.tag, 'new');
      expect(response.dates, {
        '2018-12-23': '1',
        '2018-12-21': '1',
      });
    });

    test('can get dates when dates is an empty list', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/dates');
          expect(
            request.url.queryParameters,
            {
              'tag': 'new',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {
                'user': 'test',
                'tag': 'new',
                'dates': [],
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.dates(
        tag: 'new',
      );
      expect(response.user, 'test');
      expect(response.tag, 'new');
      expect(response.dates, {});
    });

    test('can get all posts', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/all');
          expect(
            request.url.queryParameters,
            {
              'tag': 'tag',
              'start': '10',
              'results': '10',
              'fromdt': '2018-12-25T08:00:00.000Z',
              'todt': '2018-12-26T08:00:00.000Z',
              'meta': '1',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
              json.encode([
                {
                  'href':
                      'https://novelkeys.xyz/products/25-slot-switch-tester',
                  'description': '',
                  'extended': '',
                  'meta': '508c6176f510c203098fb0c5e75fd53a',
                  'hash': '3e569b02bb9df0203afb604eea548ea0',
                  'time': '2018-12-23T07:05:49Z',
                  'shared': 'yes',
                  'toread': 'no',
                  'tags': 'wishlist-new'
                },
              ]),
              200,
              headers: {'Content-Type': 'application/json; charset=utf-8'});
        }),
      );
      var posts = await client.posts.all(
        tag: 'tag',
        start: 10,
        results: 10,
        fromdt: DateTime.parse('2018-12-25'),
        todt: DateTime.parse('2018-12-26'),
        meta: 1,
      );
      expect(posts.length, 1);
    });

    test('can get suggestions', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/posts/suggest');
          expect(
            request.url.queryParameters,
            {
              'url': 'https://google.com',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              [
                {'popular': []},
                {
                  'recommended': [
                    'privacy',
                  ]
                }
              ],
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.posts.suggest(
        url: 'https://google.com',
      );
      expect(response.length, 2);
    });

    test('Post.toString returns a String', () {
      var p = Post(href: 'https://google.com', description: 'Google');
      expect(p.toString(), TypeMatcher<String>());
    });

    test('PinboardDates.toString returns a String', () {
      var result = PinboardDates(
        user: 'test',
        tag: 'new',
        dates: {'2018-12-25': '0'},
      );
      expect(result.toString(), TypeMatcher<String>());
    });

    test('PinboardGetResponse.toString returns a String', () {
      var result = PinboardGetResponse(
        date: DateTime.parse('2018-12-25'),
        user: 'test',
        posts: [],
      );
      expect(result.toString(), TypeMatcher<String>());
    });

    test('PinboardUpdate.toString returns a String', () {
      var result = PinboardUpdate(update_time: DateTime.parse('2018-12-25'));
      expect(result.toString(), TypeMatcher<String>());
    });
  });
}

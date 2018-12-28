import 'package:pinboard/pinboard.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Pinboard.tags', () {
    test('can get tags', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/tags/get');
          expect(
            request.url.queryParameters,
            {
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {
                '3d-printing': '1',
                '3ds': '2',
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.tags.get();
      expect(response.length, 2);
      expect(response['3d-printing'], '1');
      expect(response['3ds'], '2');
    });

    test('can delete a tag', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/tags/delete');
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
                'result': 'done',
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.tags.delete(
        tag: 'new',
      );
      expect(response.result, 'done');
    });

    test('can rename a tag', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/tags/rename');
          expect(
            request.url.queryParameters,
            {
              'old': 'old',
              'new': 'new',
              'auth_token': 'test:thisisthetoken',
              'format': 'json',
            },
          );
          return Response(
            json.encode(
              {
                'result': 'done',
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.tags.rename(
        old: 'old',
        new_: 'new',
      );
      expect(response.result, 'done');
    });
  });
}

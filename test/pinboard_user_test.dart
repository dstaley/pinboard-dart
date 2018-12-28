import 'package:pinboard/pinboard.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Pinboard.user', () {
    test('can get user secret', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/user/secret');
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
                'result': 'secret',
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.user.secret();
      expect(response.result, 'secret');
    });

    test('can get user API token', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/user/api_token');
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
                'result': 'token',
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.user.api_token();
      expect(response.result, 'token');
    });
  });
}

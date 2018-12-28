import 'package:pinboard/pinboard.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Pinboard', () {
    test('can login with password', () async {
      var client = Pinboard(
        username: 'test',
        client: MockClient((request) async {
          expect(
            request.url.toString(),
            'https://api.pinboard.in/v1/user/api_token?format=json',
          );
          return Response(
            json.encode({'result': 'thisisthetoken'}),
            200,
          );
        }),
      );
      await client.loginWithPassword(password: '123');
      expect(client.username, 'test');
      expect(client.token, 'thisisthetoken');
    });

    test('will automatically create a http.Client', () {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
      );
      expect(client.client, TypeMatcher<Client>());
    });

    test('Pinboard.toString returns a String', () {
      var result = Pinboard(username: 'test');
      expect(result.toString(), TypeMatcher<String>());
    });
  });
}

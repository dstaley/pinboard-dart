import 'package:pinboard/src/pinboard_client.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('PinboardClient', () {
    test('can login with password', () async {
      var client = PinboardClient(
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

    test('toString returns a String', () {
      var client = PinboardClient(username: 'test', token: 'thisisthetoken');
      expect(client.toString(), TypeMatcher<String>());
    });
  });
}

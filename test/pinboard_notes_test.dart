import 'package:pinboard/pinboard.dart';
import 'package:pinboard/src/pinboard_notes.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Pinboard.notes', () {
    test('can list notes', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/notes/list');
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
                'count': 1,
                'notes': [
                  {
                    'id': '14b66dd2cd8b7d70f1d1',
                    'hash': '6e71b3cac15d32fe2d36',
                    'title': 'test note',
                    'length': '11',
                    'created_at': '2018-10-18 22:35:03',
                    'updated_at': '2018-10-18 22:35:03'
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
      var response = await client.notes.list();
      expect(response.count, 1);
      expect(response.notes.length, 1);
      expect(response.notes[0], TypeMatcher<Note>());
    });

    test('can get a note', () async {
      var client = Pinboard(
        username: 'test',
        token: 'thisisthetoken',
        client: MockClient((request) async {
          expect(request.url.host, 'api.pinboard.in');
          expect(request.url.path, '/v1/notes/14b66dd2cd8b7d70f1d1');
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
                'id': '14b66dd2cd8b7d70f1d1',
                'hash': '6e71b3cac15d32fe2d36',
                'title': 'test note',
                'length': 11,
                'created_at': '2018-10-18 22:35:03',
                'updated_at': '2018-10-18 22:35:03',
                'text': 'hello there',
              },
            ),
            200,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
            },
          );
        }),
      );
      var response = await client.notes.get(id: '14b66dd2cd8b7d70f1d1');
      expect(response.text, 'hello there');
      expect(response.length, '11');
    });

    test('Note.toString returns a String', () {
      var result = Note(
        id: '123',
        title: 'hello',
        text: 'world',
      );
      expect(result.toString(), TypeMatcher<String>());
    });

    test('NotesResponse.toString returns a String', () {
      var result = NotesResponse(count: 1, notes: []);
      expect(result.toString(), TypeMatcher<String>());
    });
  });
}

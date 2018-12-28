import 'package:pinboard/src/pinboard_shared.dart';
import 'package:pinboard/pinboard.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('PinboardResult.toString returns a String', () {
    var result = PinboardResult(result: 'done');
    expect(result.toString(), TypeMatcher<String>());
  });

  test('UnauthorizedError thrown when token is not set', () async {
    var client = Pinboard(username: 'test');
    expect(
      () async {
        var secret = await client.user.secret();
      },
      throwsA(TypeMatcher<UnauthorizedError>()),
    );
  });

  test('UnauthorizedError thrown when credentials are invalid', () async {
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
            'API requires authentication',
            401,
            headers: {
              'Content-Type': 'text/html; charset=utf-8',
            },
          );
        }));
    expect(
      () async {
        var secret = await client.user.secret();
      },
      throwsA(TypeMatcher<UnauthorizedError>()),
    );
  });

  test('ForbiddenError thrown when response code is 403', () async {
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
            'Forbidden',
            403,
            headers: {
              'Content-Type': 'text/html; charset=utf-8',
            },
          );
        }));
    expect(
      () async {
        var secret = await client.user.secret();
      },
      throwsA(TypeMatcher<ForbiddenError>()),
    );
  });

  test('TooManyRequestsError thrown when response code is 429', () async {
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
            'Too many requests',
            429,
            headers: {
              'Content-Type': 'text/html; charset=utf-8',
            },
          );
        }));
    expect(
      () async {
        var secret = await client.user.secret();
      },
      throwsA(TypeMatcher<TooManyRequestsError>()),
    );
  });

  test('InternalServerError thrown when response code is 500', () async {
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
            'Internal Server Error',
            500,
            headers: {
              'Content-Type': 'text/html; charset=utf-8',
            },
          );
        }));
    expect(
      () async {
        var secret = await client.user.secret();
      },
      throwsA(TypeMatcher<InternalServerError>()),
    );
  });

  test('ServiceUnavailable thrown when response code is 503', () async {
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
            'Service Unavailable',
            503,
            headers: {
              'Content-Type': 'text/html; charset=utf-8',
            },
          );
        }));
    expect(
      () async {
        var secret = await client.user.secret();
      },
      throwsA(TypeMatcher<ServiceUnavailableError>()),
    );
  });

  test('PinboardError.toString returns a String', () {
    var e = PinboardError('error');
    expect(e.toString(), TypeMatcher<String>());
  });
}

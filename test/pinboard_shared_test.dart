import 'package:pinboard/src/pinboard_shared.dart';
import 'package:test/test.dart';

void main() {
  test('PinboardResultCode.toString returns a String', () {
    var result = PinboardResultCode(result_code: 'done');
    expect(result.toString(), TypeMatcher<String>());
  });

  test('PinboardResult.toString returns a String', () {
    var result = PinboardResult(result: 'done');
    expect(result.toString(), TypeMatcher<String>());
  });
}

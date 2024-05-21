import 'package:flutter_test/flutter_test.dart';
import 'package:esof/sigarraApi/sigarraApi.dart';


void main() {
  group('getCookies', () {
    test('extracts cookies from headers', () {
      final headers = {
        'set-cookie': 'cookie1=value1, cookie2=value2, cookie3=value3'
      };

      final cookies = getCookies(headers);

      expect(cookies, 'cookie1=value1;cookie2=value2;cookie3=value3');
    });

    test('handles empty headers', () {
      final headers = Map<String, String>();

      final cookies = getCookies(headers);

      expect(cookies, '');
    });

    test('handles empty set-cookie header', () {
      final headers = {'set-cookie': ''};

      final cookies = getCookies(headers);

      expect(cookies, '');
    });
  });
}
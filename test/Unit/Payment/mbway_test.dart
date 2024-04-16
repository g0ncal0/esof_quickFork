import 'package:esof/backend/mbWay/mbway_payments.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_test/flutter_test.dart';
import 'dart:io';



Future<bool> checkIfWifiIsOn() async{
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

void main() {
  group('Mbway payment', ()
  {
    test('Payment went through.', () async {

      await dotenv.load(fileName: "assets/.env");

      if ( await checkIfWifiIsOn() ) {
        Map<bool, String> apiResult = await payWithMbway("351#919999999", "2.99");
        expect(apiResult.keys.first, true);
      } else {
        Map<bool, String> apiResult = await payWithMbway("351#911910507", "2.99");
        expect(apiResult.keys.first, false);
      }


    });
    test('Payment failed.', () async {
      await dotenv.load(fileName: "assets/.env");

      if ( await checkIfWifiIsOn() ) {
        Map<bool, String> apiResult = await payWithMbway("351#911910507", "2.99");
        expect(apiResult.keys.first, false);
      } else {
        Map<bool, String> apiResult = await payWithMbway("351#911910507", "2.99");
        expect(apiResult.keys.first, false);
      }
    });
  });

}
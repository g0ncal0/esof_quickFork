import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<bool, String>> payWithMbway(String phoneNumber, String paymentAmount) async {
  try {
    String transactionID = "gp9253eg4o";

    String var_base_url = "https://spg.qly.site1.sibs.pt";

    DateTime dateTimeNow = DateTime.now();
    String dateTimeNow_ISO = dateTimeNow.toIso8601String();

    DateTime dateTimeLater = dateTimeNow.add(Duration(days: 2));
    String dateTimeLater_ISO = dateTimeLater.toIso8601String();

    Map<String, String> headers = {
      'Authorization': dotenv.env['MBWAY_API_AUTH'] as String,
      'X-IBM-Client-Id': dotenv.env['CLIENT-ID'] as String,
      'Content-Type': 'application/json'
    };

    String firstPayload = '{"merchant": {"terminalId": 52221, "channel": "web", "merchantTransactionId": "Order Id: me6p6dvrxz"}, "transaction": {"transactionTimestamp": "$dateTimeNow_ISO", "description": "Transaction test by SIBS", "moto": false, "paymentType": "PURS", "amount": {"value": $paymentAmount, "currency": "EUR"}, "paymentMethod": ["CARD", "MBWAY", "REFERENCE"], "paymentReference": {"initialDatetime": "$dateTimeNow_ISO", "finalDatetime": "$dateTimeLater_ISO", "maxAmount": {"value": $paymentAmount, "currency": "EUR"}, "minAmount": {"value": $paymentAmount, "currency": "EUR"}, "entity": "24000"}}}';

    http.Response response = await http.post(
        Uri.parse('$var_base_url/api/v1/payments'), headers: headers,
        body: firstPayload);
    //print(response.body);

    Map<String, dynamic> responseData = json.decode(response.body);

    String transactionSignature_dict_response = responseData['transactionSignature'];
    Map<String, dynamic> returnStatus_dict_response = responseData['returnStatus'];
    String auth_header = 'Digest $transactionSignature_dict_response';

    // Send the Payment Request
    headers = {
      'Authorization': auth_header,
      'X-IBM-Client-Id': dotenv.env['CLIENT-ID'] as String,
      'Content-Type': 'application/json'
    };

    Map<String, String> body = {'customerPhone': phoneNumber};

    String paymentUrl = "${responseData['transactionID']}/mbway-id/purchase";

    response = await http.post(
        Uri.parse('$var_base_url/api/v1/payments/$paymentUrl'),
        headers: headers, body: json.encode(body));

    if (response.body.isEmpty){
      //print(response); // ToDo remove
      return {false : "MbWay is not responding at the moment, please try again later."};
    } else {
      //print(response.body);
      RegExp regExp = RegExp(r'success', caseSensitive: false);
      bool hasMatch = regExp.hasMatch(json.decode(response.body)['paymentStatus']);

      if (hasMatch){
        return {true : "Congrats on your purchase\n\n${response.body}"};
      } else {
        return {false : "Your payment was invalid, please try again later.\n"};
      }

    }

  } catch (e) {
    //print(e.toString()); // ToDo remove
    return {false : "An Unknown Error occurred."};
  }


}

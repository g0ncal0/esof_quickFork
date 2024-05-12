import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:esof/sigarraApi/session.dart';

Future<Session?> sigarraLogin(String username, String password) async {
  const url = 'https://sigarra.up.pt/feup/pt/mob_val_geral.autentica';
  final response = await http.post(Uri.parse(url), body: {'pv_login': username, 'pv_password': password}).timeout(const Duration(seconds: 30));

  if (response.statusCode != 200) {
    Logger().e('Error, statusCode: ${response.statusCode}');
    return null;
  }

  final session = sessionlogin(response);

  if (session == null) {
    Logger().e('Login failed.');
    return null;
  }
  Logger().i('Login successful.');

  return session;
}

String getCookies(Map<String, String> headers) {
  final cookieList = <String>[];
  final bigCookie = headers['set-cookie'];

  if (bigCookie != null && bigCookie != '') {
    final cookies = bigCookie.split(',');
    for (final cookie in cookies) {
      cookieList.add(Cookie.fromSetCookieValue(cookie).toString());
    }
  }
  String bakedCookie = "";
  cookieList.forEach((element) {
    bakedCookie += element.toString();
  });
  Logger().i('Cookie monster: $bakedCookie');

  return cookieList.join(';');
}

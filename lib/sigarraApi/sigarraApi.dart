import 'dart:async';
import 'dart:io';

import 'package:esof/sigarraApi/session.dart';
import 'package:http/http.dart' as http;

Future<Session?> sigarraLogin(String username, String password) async {
  const url = 'https://sigarra.up.pt/feup/pt/mob_val_geral.autentica';
  final response = await http.post(Uri.parse(url), body: {
    'pv_login': username,
    'pv_password': password
  }).timeout(const Duration(seconds: 30));

  if (response.statusCode != 200) {
    return null;
  }

  final session = sessionlogin(response);

  if (session == null) {
    return null;
  }

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
  return cookieList.join(';');
}

Future<http.Response> getImage(String cookie, String upNumber) async {
  final url =
      "https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=" +
          upNumber;
  http.Client? httpClient;

  final headers = <String, String>{};
  headers['cookie'] = cookie;

  final response = await (httpClient != null
          ? httpClient!
              .get(Uri.parse(url), headers: headers)
              .timeout(const Duration(seconds: 30))
          : http.get(Uri.parse(url), headers: headers))
      .timeout(const Duration(seconds: 30));

  if (response.statusCode == 200) {
    return response;
  }

  return Future.error('Re-login failed; user might have changed password');
}

Future<http.Response> getName(String cookie, String upNumber) async {
  final url = "https://sigarra.up.pt/feup/pt/mob_fest_geral.perfil?pv_codigo=" +
      upNumber;
  http.Client? httpClient;

  final headers = <String, String>{};
  headers['cookie'] = cookie;

  final response = await (httpClient != null
          ? httpClient!
              .get(Uri.parse(url), headers: headers)
              .timeout(const Duration(seconds: 30))
          : http.get(Uri.parse(url), headers: headers))
      .timeout(const Duration(seconds: 30));

  if (response.statusCode == 200) {
    return response;
  }

  return Future.error('Re-login failed; user might have changed password');
}

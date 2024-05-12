import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:esof/sigarraApi/sigarraApi.dart';

class Session {
  Session(this.username, this.cookies);
  String username;
  String cookies;
}

Session? sessionlogin(http.Response response) {
  final documentBody = json.decode(response.body) as Map<String, dynamic>;

  if (!(documentBody['authenticated'] as bool)) {
    return null;
  }

  return Session(documentBody['codigo'] as String, getCookies(response.headers));
}
import 'dart:convert';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = "http://10.0.2.2:3000/";
  static const String resource = "learnhttp/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  String getURL() {
    return "$url$resource";
  }

  void register(String content) {
    client.post(
      Uri.parse(getURL()),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"content": content}),
    );
  }

  void get() async {
    await client.get(Uri.parse(getURL()));
  }
}

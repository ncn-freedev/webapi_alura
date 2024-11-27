import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

class JournalService {
  static const String url = "http://10.0.2.2:3000/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  String getURL() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getURL()),
      headers: {"Content-Type": "application/json"},
      body: jsonJournal,
    );

    if (response.statusCode == 201) {
      return true;
    } 

    return false;
  }

  Future<bool> update(Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse("${getURL()}${journal.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonJournal,
    );

    if (response.statusCode == 200) {
      return true;
    } 

    return false;
  }

  Future<bool> delete(String id) async {
    http.Response response = await client.delete(Uri.parse("${getURL()}$id"));

    if (response.statusCode == 200) {
      return true;
    } 

    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getURL()));

    if(response.statusCode != 200){
      throw Exception();
    }

    List<Journal> list = [];

    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic){
      list.add(Journal.fromJson(jsonMap));
    }

    return list;
  }
}

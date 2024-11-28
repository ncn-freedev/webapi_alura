import 'dart:convert';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webClient.dart';
import 'package:http/http.dart' as http;

class JournalService {
  
  static const String resource = "journals/";
  http.Client client = Webclient().client;
  String url = Webclient.url; 

  String getURL() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getURL()),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonJournal,
    );

    if (response.statusCode != 201) {
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw Exception(response.body);
    } 

    return true;
  }

  Future<bool> update(Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.put(
      Uri.parse("${getURL()}${journal.id}"),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonJournal,
    );

    if (response.statusCode != 200) {
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw Exception(response.body);
    } 

    return true;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(Uri.parse("${getURL()}$id"),
    headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw Exception(response.body);
    } 

    return true;
  }

  Future<List<Journal>> getAll({required String id, required String token}) async {
    http.Response response = await client.get(Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );

    if(response.statusCode != 200){
      if(json.decode(response.body) == "jwt expired"){
        throw TokenNotValidException();
      }
      throw Exception(response.body);
    }

    List<Journal> list = [];

    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic){
      list.add(Journal.fromJson(jsonMap));
    }

    return list;
  }
}

class TokenNotValidException implements Exception {}

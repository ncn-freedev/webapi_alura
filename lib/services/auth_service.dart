import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/services/webClient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  http.Client client = Webclient().client;
  String url = Webclient.url;

  Future<bool> login({required email, required password}) async { 
    http.Response response = await client.post(
      Uri.parse('${url}login'),
      
      body: {"email": email, "password": password},
    );

    if (response.statusCode != 200) {
      String content = jsonDecode(response.body);
      switch(content){
        case "Cannot find user":
          throw UserNotFindException();
      }
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);
    return true;
  }

  Future <bool> register({required email, required password}) async {
    http.Response response = await client.post(
      Uri.parse('${url}register'),
      body: {"email": email, "password": password},
    );
    if(response.statusCode != 201){
      throw HttpException(response.body);
    }
    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(String body){
    Map<String, dynamic> userInfos = json.decode(body);
    String token = userInfos["accessToken"];
    String email = userInfos["user"]["email"];
    int id = userInfos["user"]["id"];

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("accessToken", token);
      prefs.setString("email", email);
      prefs.setInt("id", id);
      String? tokenSalvo = prefs.getString("accessToken");
      print(tokenSalvo);
    });

    

    
  }

}

class UserNotFindException implements Exception {}
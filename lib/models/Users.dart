import 'dart:convert';

import '../api/api_client.dart';
import "package:http/http.dart";

class User {
  String _uuid = '';
  String _first_name = '';
  String _last_name = '';
  String _email = '';
  String _username = '';
  String _last_login = '';
  
 String get uuid => this._uuid;

 set uuid(String value) => this._uuid = value;

  get first_name => this._first_name;

 set first_name( value) => this._first_name = value;

  get last_name => this._last_name;

 set last_name( value) => this._last_name = value;

  get email => this._email;

 set email( value) => this._email = value;

  get username => this._username;

 set username( value) => this._username = value;

  get last_login => this._last_login;

 set last_login( value) => this._last_login = value;

  final APIClient _client;

  User(this._client);

  Future<int> get_from_web() async{
    Response res = await _client.c_get(Uri.parse("http://atibin.info:8585/api/user/self/retrieve/"));
    if (res.statusCode == 200){
      var data = jsonDecode(utf8.decode(res.bodyBytes));
      _uuid = data["uuid"];
      _first_name = data["first_name"];
      _last_name = data["last_name"];
      _email = data["email"];
      _username = data["username"];
      _last_login = data["last_login"];
    }
    return res.statusCode;
  }

}
import "dart:convert";

import "package:http/http.dart";

class APIClient {
  String _refresh_token = "";
  String _access_token = "";
  Uri _get_access_token = Uri.http("atibin.info:8585", "/api/auth/token");
  Uri _get_validate_token = Uri.http("atibin.info:8585", "/api/auth/token/refresh");
  String _username = "";
  String _password = '';

  get username => this._username;

 set username( value) => this._username = value;

  String get refresh_token => _refresh_token;

  set refresh_token(String value) => this._refresh_token = value;

  get access_token => _access_token;

  set access_token(value) => _access_token = value;

  get get_access_token => _get_access_token;

  set get_access_token(value) => _get_access_token = value;

  get get_validate_token => _get_validate_token;

  set get_validate_token(value) => _get_validate_token = value;

  Future<int> login(String user, String password) async  {
    Map<String,String> headers = {'accept': 'application/json','Content-Type': 'application/json' ,'X-CSRFToken': '37HQReHSybXdbwpH9AVG84Co1np8ZtpPMscF0WLmNylBJ15zUbkx6vpj1jYDXWtr'};
    Response res =
      await post(
      _get_access_token,
      body: jsonEncode(
        <String, String>{
          "username": user.trim(),
          "password": password
        }
      ),
      headers: headers
    );
    if (res.statusCode==200){
      _access_token = await jsonDecode(utf8.decode(res.bodyBytes))["access"];
      _refresh_token = await jsonDecode(utf8.decode(res.bodyBytes))["refresh"];
      _username = user;
      _password = password;
    }
    return res.statusCode;
  }


  Future<int> refresh() async {

    Map<String , String > headers = {'accept': 'application/json'};
    Response res = await post(
      Uri.parse("http://atibin.info:8585/api/auth/token/refresh"),
      headers:headers,
      body: jsonEncode(<String, dynamic>{
        "refresh":_refresh_token
        })
      );
    if (res.statusCode == 200){
      _access_token = json.decode(utf8.decode(res.bodyBytes))['access'];
    }
    return res.statusCode;
  }

  Future<Response> c_get(Uri url) async{
    Map<String , String > headers = {"Authorization":"Token " + _access_token, 'accept': 'application/json'};
    Response res = await get(url, headers:headers);
    return res;
  }

  Future<Response> c_post(Uri url, Map<String, dynamic> data) async{
    Map<String,String> headers = {"Authorization":"Token " + _access_token, 'accept': 'application/json','Content-Type': 'application/json' ,'X-CSRFToken': '37HQReHSybXdbwpH9AVG84Co1np8ZtpPMscF0WLmNylBJ15zUbkx6vpj1jYDXWtr'};
    Response res = await post(url, headers: headers, body: jsonEncode(data));
    return res;
  }

  Future<Response> c_put(Uri url, Map<String, dynamic> data) async{
    Map<String,String> headers = {"Authorization":"Token " + _access_token, 'accept': 'application/json','Content-Type': 'application/json' ,'X-CSRFToken': '37HQReHSybXdbwpH9AVG84Co1np8ZtpPMscF0WLmNylBJ15zUbkx6vpj1jYDXWtr'};
    Response res = await put(url, headers: headers, body: jsonEncode(data));
    return res;
  }

  Future<Response> c_delete(Uri url) async{
    Map<String,String> headers = {"Authorization":"Token " + _access_token, 'accept': 'application/json','Content-Type': 'application/json' ,'X-CSRFToken': '37HQReHSybXdbwpH9AVG84Co1np8ZtpPMscF0WLmNylBJ15zUbkx6vpj1jYDXWtr'};
    Response res = await delete(url, headers: headers);
    return res;
  }

}

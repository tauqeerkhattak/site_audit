import 'package:http/http.dart' as http;
import 'dart:convert';

import 'constants.dart';

class Network {
  static var client = http.Client();

  static get({required String url, headers, Map<String, dynamic>? params}) async {
    try{
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if(headers !=null){
        apiHeaders.addAll(headers);
      }

      Uri uri = Uri.https(Constants.baseUrl, url, params);
      print("REQUESTED URL => $uri");
      var response = await client.get(uri, headers: apiHeaders);
      if(response.statusCode == 200) {
        return response.body;
        // return json.decode(response.body);
      }
      if(response.statusCode < 200 || response.statusCode > 400 || json == null) {
        return null;
      }
    } catch(e) {
      print("GET: $e");
      return throw Exception(e);
    }
  }

  static post({url,payload,headers, Map<String, dynamic>? params}) async {
    try{
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if(headers !=null){
        apiHeaders.addAll(headers);
      }
      var body = json.encode(payload);
      Uri uri = Uri.https(Constants.baseUrl, url, params);
      print(uri);
      var response = await client.post(uri, body: body,headers:apiHeaders );
      print(response.body);
      if(response.statusCode == 200) {
        return response.body;
      }
      if(response.statusCode < 200 || response.statusCode > 400 || json == null) {
        return null;
      }
    } catch(e){
      print("POST: $e");
      return throw Exception(e);
    }
  }

  static put({url,payload,headers, Map<String, dynamic>? params}) async {
    try{
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if(headers !=null){
        apiHeaders.addAll(headers);
      }
      var body = json.encode(payload);
      Uri uri = Uri.https(Constants.baseUrl, url, params);
      print(uri);
      var response = await client.put(uri, body: body,headers:apiHeaders );
      print(response.body);
      if(response.statusCode == 200) {
        return response.body;
      }
      if(response.statusCode < 200 || response.statusCode > 400 || json == null) {
        return null;
      }
    } catch(e){
      print("POST: $e");
      return throw Exception(e);
    }
  }
}
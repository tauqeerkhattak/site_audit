import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';

class Network {
  static var client = http.Client();
  static bool isAvailable = false;
  static bool sendDataToNetwork = false;

  static get(
      {required String url, headers, Map<String, dynamic>? params}) async {
    try {
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (headers != null) {
        apiHeaders.addAll(headers);
      }

      Uri uri = Uri.https(Constants.baseUrl, url, params);
      print("REQUESTED URL => $uri");
      var response = await client.get(uri, headers: apiHeaders);
      print("Error: " + response.body);
      if (response.statusCode == 200) {
        return response.body;
        // return json.decode(response.body);
      }
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        return null;
      }
    } catch (e) {
      print("GET: $e");
      return throw Exception(e);
    }
  }

  static multiPartRequest(
      {url, payload, headers, List<http.MultipartFile>? files}) async {
    try {
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (headers != null) {
        apiHeaders.addAll(headers);
      }
      Uri uri = Uri.https(
        Constants.baseUrl,
        url,
      );
      print(uri);
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.headers.addAll(apiHeaders);
      request.fields.addAll(payload);
      for (int i = 0; i < files!.length; i++) {
        request.files.add(files[i]);
      }
      http.StreamedResponse res = await request.send();
      String response = await res.stream.bytesToString();
      print("Error: " + response);
      if (res.statusCode == 200) {
        print(response);
        return response;
      } else {
        print('Hello');
      }
      if (res.statusCode < 200 || res.statusCode > 400 || json == null) {
        return null;
      }
      return null;
    } catch (e) {
      print("POST: $e");
      return throw Exception(e);
    }
  }

  static post({
    url,
    payload,
    headers,
    Map<String, dynamic>? params,
  }) async {
    try {
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (headers != null) {
        apiHeaders.addAll(headers);
      }
      var body = json.encode(payload);
      Uri uri = Uri.https(
          Constants.baseUrl,
          // Constants.baseUrl,
          url,
          params);
      print(uri);
      var response = await client.post(uri, body: body, headers: apiHeaders);
      print('Response: ' + response.body);
      if (response.statusCode == 200) {
        return response.body;
      }
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        return null;
      }
    } catch (e) {
      print("POST: $e");
      return throw Exception(e);
    }
  }

  static put({url, payload, headers, Map<String, dynamic>? params}) async {
    try {
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (headers != null) {
        apiHeaders.addAll(headers);
      }
      var body = json.encode(payload);
      Uri uri = Uri.https(Constants.baseUrl, url, params);
      print(uri);
      var response = await client.put(uri, body: body, headers: apiHeaders);
      print("Error: " + response.body);
      if (response.statusCode == 200) {
        return response.body;
      }
      if (response.statusCode < 200 ||
          response.statusCode > 400 ||
          json == null) {
        return null;
      }
    } catch (e) {
      print("POST: $e");
      return throw Exception(e);
    }
  }
}

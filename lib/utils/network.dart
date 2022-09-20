import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'constants.dart';

class Network {
  static var client = http.Client();
  static bool isNetworkAvailable = true;
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

      Uri uri = Uri.http(Constants.baseUrl, url, params);
      log('REQUESTED URL => $uri');
      var response = await client.get(uri, headers: apiHeaders);
      if (response.statusCode == 200) {
        return response.body;
      }
      if (response.statusCode < 200 || response.statusCode > 400) {
        log('ERROR: ${response.body}');
        return null;
      }
    } catch (e) {
      log("GET: $e");
      return throw Exception(e);
    }
  }

  static multiPartRequest(
      {url,
      required Map<String, String> payload,
      headers,
      List<http.MultipartFile>? files}) async {
    try {
      Map<String, String> apiHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
      };
      if (headers != null) {
        apiHeaders.addAll(headers);
      }
      Uri uri = Uri.http(
        Constants.baseUrl,
        url,
      );
      log(uri.toString());
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.headers.addAll(apiHeaders);
      request.fields.addAll(payload);
      for (int i = 0; i < files!.length; i++) {
        request.files.add(files[i]);
      }
      // log("FILES:::: ${request.fields.length}");
      // log("PAYLOAD::::: $payload}");
      var res = await request.send();
      log("ResponseCode: ${res.statusCode}");
      String response = await res.stream.bytesToString();
      log("Response: $response");
      if (res.statusCode == 200) {
        return response;
      } else {
        log('Data not sent!');
      }
      if (res.statusCode < 200 || res.statusCode > 400) {
        return null;
      }
      return null;
    } catch (e) {
      log("POST: $e");
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
      Uri uri = Uri.http(
          Constants.baseUrl,
          // Constants.baseUrl,
          url,
          params);
      log(uri.toString());
      var response = await client.post(uri, body: body, headers: apiHeaders);
      log('Response: ${response.body}');
      if (response.statusCode == 200) {
        return response.body;
      }
      if (response.statusCode < 200 || response.statusCode > 400) {
        return null;
      }
    } catch (e) {
      log("POST: $e");
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
      Uri uri = Uri.http(Constants.baseUrl, url, params);
      log(uri.toString());
      var response = await client.put(uri, body: body, headers: apiHeaders);
      log("Error: ${response.body}");
      if (response.statusCode == 200) {
        return response.body;
      }
      if (response.statusCode < 200 || response.statusCode > 400) {
        return null;
      }
    } catch (e) {
      log("POST: $e");
      return throw Exception(e);
    }
  }
}

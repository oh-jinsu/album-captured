import 'dart:convert';

import 'package:album/core/utilities/debug.dart';
import 'package:http/http.dart' as http;

abstract class Response {
  const Response();
}

class SuccessResponse extends Response {
  final dynamic body;

  const SuccessResponse({
    required this.body,
  });
}

class FailureResponse extends Response {
  final int code;
  final String message;

  const FailureResponse({
    required this.code,
    required this.message,
  });
}

typedef Fetcher = Future<http.Response> Function(Uri uri,
    {Map<String, String>? headers});

Future<Response> get(Uri uri, {Map<String, String>? headers}) async {
  Debug.log("GET $uri");

  return _fetch(uri, http.get, headers: headers);
}

Future<Response> post(Uri uri,
    {Map<String, String>? headers, Object? body}) async {
  Debug.log("POST $uri");

  return _fetch(
      uri,
      (Uri uri, {Map<String, String>? headers}) =>
          http.post(uri, headers: headers, body: body),
      headers: headers);
}

Future<Response> _fetch(
  Uri uri,
  Fetcher fetcher, {
  Map<String, String>? headers,
}) async {
  try {
    final response = await fetcher(uri, headers: headers);

    Debug.log(response.statusCode);

    final body = jsonDecode(response.body);

    Debug.log(body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SuccessResponse(body: body);
    }

    final code = body["code"];

    final message = body["message"];

    return FailureResponse(code: code, message: message);
  } catch (e) {
    Debug.log(e);

    await Future.delayed(const Duration(milliseconds: 1000));

    return _fetch(uri, fetcher, headers: headers);
  }
}

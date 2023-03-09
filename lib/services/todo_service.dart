import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

/// All todo api call will be here
class TodoService {
  static Future<bool> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    try {
      const url = "https://api.nstack.in/v1/todos?page=1&limit=10";
      final uri = Uri.parse(url);

      final response = await get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map;
        final result = json["items"] as List;
        return result;
      } else {
        return null;
      }
    } catch (exception) {
      debugPrint(exception.toString());
      return null;
    }
  }
}

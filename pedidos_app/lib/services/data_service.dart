import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  Future<List<T>> loadData<T>(String path, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((data) => fromJson(data)).toList();
  }
}

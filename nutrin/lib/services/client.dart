import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' show load, clean, isEveryDefined, env;
import 'package:http/http.dart' as http;
import 'package:mobileapp/model/tracked_food.dart';

class FoodClient {
  final url =
      "https://api.nal.usda.gov/fdc/v1/foods/list?api_key=OwOopadFaacSp65Vps9UTkNTWlVUXOFFMOy6jgsf";
  var apiKey;

  init() {
    load();
    apiKey = env.containsKey('APIKEY') ? env['APIKEY'] : Error();
  }

  Future<List<int>> foodQueryForId(String food) async {
    List<dynamic> listOfFdcids;
    var body = jsonEncode({
      "query": "cake",
      "dataType": ["Foundation", "SR Legacy"],
      "pageSize": 10,
      "pageNumber": 0,
      "sortBy": "dataType.keyword",
      "sortOrder": "asc"
    });
    var header = {'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: header);
    if (response.statusCode == 200) {
      listOfFdcids =
          json.decode(response.body).map((val) => extractFdcids(val)).toList();
    } else {
      throw Exception("Please try again");
    }
    var bodyForSearch = jsonEncode({
      "fdcIds": listOfFdcids,
      "format": "abridged",
      // "nutrients": [203, 204, 205]
    });
    var headerForSearch = {'Content-Type': 'application/json'};
    final finalResponse =
        await http.post(url, body: bodyForSearch, headers: headerForSearch);
    if (finalResponse.statusCode == 200) {
      print(finalResponse.body);
      // return TrackedFood.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to retrieve foods");
    }
  }

  // Future<List<int>> foodQueryWithId(String food) async {
  //   Future<List<int>> fdcids = foodQueryForId("cake");
  //   print(fdcids);
  //   var body = jsonEncode({
  //     "fdcIds": fdcids,
  //     "format": "abridged",
  //     // "nutrients": [203, 204, 205]
  //   });
  //   var header = {'Content-Type': 'application/json'};
  //   final response = await http.post(url, body: body, headers: header);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     // return TrackedFood.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception("Failed to retrieve foods");
  //   }
  // }

  int extractFdcids(Map<String, dynamic> rawJson) {
    return rawJson.containsKey('fdcId') ? rawJson['fdcId'] : '000';
  }
}
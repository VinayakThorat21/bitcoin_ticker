import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/utilities/constants.dart';

class CoinData {
  Future getJsonResponse({required crypto, required currency}) async {
    var url = Uri.https(coinApi, '$resultPath/$crypto/$currency', {
      'apikey': apiKey,
    });

    var response = await http.get(url);

    // Anyhow, you need to decode the response to json format
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      if (kDebugMode) {
        print('Request Failed with status code: ${response.statusCode}');
      }
    }

    return null;
  }
}

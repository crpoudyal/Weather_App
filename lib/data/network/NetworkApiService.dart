import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather_app/data/app_exception.dart';
import 'package:weather_app/data/network/BaseApiService.dart';
import 'package:weather_app/res/app_url.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getGetApiResponse(
      String baseUrl, String endPoint, String place) async {
    dynamic responseJson;
    try {
      final queryParameter = {
        'key': AppUrl.apiKey,
        'q': place,
      };

      final uri = Uri.http(baseUrl, endPoint, queryParameter);
      final response = await http.get(uri);

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw BadRequestException("No matching location found");
      case 401:
        throw UnauthorizedException(response.body.toString());

      default:
        throw FetchDataException(
            "Error occurred while communication with server ${response.statusCode.toString()}");
    }
  }
}

import 'package:weather_app/data/network/BaseApiService.dart';
import 'package:weather_app/data/network/NetworkApiService.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/res/app_url.dart';

class HomeRepo {
  final BaseApiService _apiService = NetworkApiService();

  Future<WeatherModel> fetchWeather(String location) async {
    try {
      dynamic response = await _apiService.getGetApiResponse(
          AppUrl.baseUrl, AppUrl.endPoint, location);
      return response = WeatherModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

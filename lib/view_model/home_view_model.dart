import 'package:flutter/cupertino.dart';
import 'package:weather_app/data/response/api_response.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/repo/home_repo.dart';

class HomeViewModel with ChangeNotifier {
  final _myRepo = HomeRepo();

  ApiResponse<WeatherModel> weather = ApiResponse.loading();

  setWeather(ApiResponse<WeatherModel> response) {
    weather = response;
    notifyListeners();
  }

  Future<void> fetchWeatherApi(String location) async {
    setWeather(ApiResponse.loading());
    _myRepo.fetchWeather(location).then((value) {
      setWeather(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setWeather(ApiResponse.error(error.toString()));
    });
  }
}

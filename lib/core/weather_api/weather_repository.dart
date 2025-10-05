import '../models/weather_models.dart';
import 'weather_api_client.dart';

class WeatherRepository {
  WeatherRepository(this._client);

  final WeatherApiClient _client;

  Future<WeatherBundle> fetchForLocation(LocationPoint location) {
    return _client.fetchWeather(location);
  }
}

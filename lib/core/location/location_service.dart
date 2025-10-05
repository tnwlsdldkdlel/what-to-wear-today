import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_models.dart';

class LocationService {
  const LocationService({LocationPoint? fallback}) : _fallback = fallback;

  final LocationPoint? _fallback;

  Future<LocationPoint> resolveCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _fallback ?? _defaultFallback();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _fallback ?? _defaultFallback();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _fallback ?? _defaultFallback();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final placemark = await _placemarkFor(position);

      return LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        locality: placemark.locality,
        city: placemark.city,
        district: placemark.district,
      );
    } on Exception {
      return _fallback ?? _defaultFallback();
    }
  }

  LocationPoint _defaultFallback() => const LocationPoint(
        latitude: 37.5665,
        longitude: 126.9780,
        locality: '서울 중구',
        city: '서울특별시',
        district: '중구',
      );

  Future<_ResolvedPlacemark> _placemarkFor(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ko_KR',
      );
      if (placemarks.isNotEmpty) {
        final mark = placemarks.first;
        final city = _clean(mark.administrativeArea) ??
            _clean(mark.locality) ??
            '';
        final district = _clean(mark.subLocality) ??
            _clean(mark.subAdministrativeArea) ??
            '';
        final locality = [city, district]
            .where((element) => element.isNotEmpty)
            .join(' ');
        return _ResolvedPlacemark(
          locality: locality.isNotEmpty ? locality : city,
          city: city,
          district: district,
        );
      }
    } on Exception {
      // ignore and use fallback values below
    }

    final fallback = _fallback ?? _defaultFallback();
    return _ResolvedPlacemark(
      locality: fallback.locality,
      city: fallback.city,
      district: fallback.district,
    );
  }

  String? _clean(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

class _ResolvedPlacemark {
  const _ResolvedPlacemark({
    required this.locality,
    required this.city,
    required this.district,
  });

  final String locality;
  final String city;
  final String district;
}

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw StateError('위치 권한이 거부되었습니다.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw StateError('설정에서 위치 권한을 허용해주세요.');
    }

    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> resolvePlacemark(Position position) async {
    final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isEmpty) {
      return '현재 위치';
    }
    final placemark = placemarks.first;
    final locality = placemark.locality ?? '';
    final subLocality = placemark.subLocality ?? '';
    if (locality.isEmpty && subLocality.isEmpty) {
      return '현재 위치';
    }
    return [locality, subLocality].where((value) => value.isNotEmpty).join(' ');
  }
}

class OutfitSubmission {
  const OutfitSubmission({
    required this.deviceId,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.top,
    required this.bottom,
    this.outerwear,
    required this.shoes,
    this.accessories,
    required this.reportedAt,
  });

  final String deviceId;
  final String cityName;
  final double latitude;
  final double longitude;
  final String top;
  final String bottom;
  final String? outerwear;
  final String shoes;
  final List<String>? accessories;
  final DateTime reportedAt;

  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'city_name': cityName,
        'latitude': latitude,
        'longitude': longitude,
        'top': top,
        'bottom': bottom,
        'outerwear': outerwear,
        'shoes': shoes,
        'accessories': accessories,
        'reported_at': reportedAt.toIso8601String(),
      };
}

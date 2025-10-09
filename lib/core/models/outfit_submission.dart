class OutfitSubmission {
  const OutfitSubmission({
    required this.latitude,
    required this.longitude,
    required this.top,
    required this.bottom,
    this.outerwear,
    required this.shoes,
    this.accessories,
    required this.comfort,
    required this.reportedAt,
    this.userId,
  });

  final double latitude;
  final double longitude;
  final String top;
  final String bottom;
  final String? outerwear;
  final String shoes;
  final List<String>? accessories;
  final ComfortLevel comfort;
  final DateTime reportedAt;
  final String? userId;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'top': top,
        'bottom': bottom,
        'outerwear': outerwear,
        'shoes': shoes,
        'accessories': accessories,
        'comfort': comfort.name,
        'reported_at': reportedAt.toIso8601String(),
        'is_just_right': comfort == ComfortLevel.justRight,
        if (userId != null) 'user_id': userId,
      };
}

enum ComfortLevel { hot, justRight, cold }

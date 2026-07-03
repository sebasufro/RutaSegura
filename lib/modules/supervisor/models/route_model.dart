class RouteModel {
  final String id;
  final String routeName;
  final String? sector;
  final String? schedule;
  final String? description;
  final DateTime? startingDatetime;
  final DateTime? endingDatetime;
  final int? minVolunteers;
  final int? maxCapacity;
  final double? startingLatitude;
  final double? startingLongitude;
  final double? endingLatitude;
  final double? endingLongitude;
  final String? transportType;
  final double? distanceMeters;
  final List<dynamic>? basePoints;
  final List<dynamic>? streetGeometry;
  final String? status;

  RouteModel({
    required this.id,
    required this.routeName,
    this.sector,
    this.schedule,
    this.description,
    this.startingDatetime,
    this.endingDatetime,
    this.minVolunteers,
    this.maxCapacity,
    this.startingLatitude,
    this.startingLongitude,
    this.endingLatitude,
    this.endingLongitude,
    this.transportType,
    this.distanceMeters,
    this.basePoints,
    this.streetGeometry,
    this.status,
  });

  String get title => routeName;

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String && value.isNotEmpty) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String && value.isNotEmpty) return int.tryParse(value);
    return null;
  }

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id_route'] as String,
      routeName: json['route_name'] as String,
      sector: json['sector'] as String?,
      schedule: json['schedule'] as String?,
      description: json['description'] as String?,
      startingDatetime: json['starting_datetime'] != null
          ? DateTime.parse(json['starting_datetime'] as String)
          : null,
      endingDatetime: json['ending_datetime'] != null
          ? DateTime.parse(json['ending_datetime'] as String)
          : null,
      minVolunteers: _parseInt(json['min_volunteers']),
      maxCapacity: _parseInt(json['max_capacity']),
      startingLatitude: _parseDouble(json['starting_latitude']),
      startingLongitude: _parseDouble(json['starting_longitude']),
      endingLatitude: _parseDouble(json['ending_latitude']),
      endingLongitude: _parseDouble(json['ending_longitude']),
      transportType: json['transport_type'] as String?,
      distanceMeters: _parseDouble(json['distance_meters']),
      basePoints: json['base_points'] as List<dynamic>?,
      streetGeometry: json['street_geometry'] as List<dynamic>?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_route': id,
      'route_name': routeName,
      if (sector != null) 'sector': sector,
      if (schedule != null) 'schedule': schedule,
      if (description != null) 'description': description,
      if (startingDatetime != null) 'starting_datetime': startingDatetime!.toIso8601String(),
      if (endingDatetime != null) 'ending_datetime': endingDatetime!.toIso8601String(),
      if (minVolunteers != null) 'min_volunteers': minVolunteers,
      if (maxCapacity != null) 'max_capacity': maxCapacity,
      if (startingLatitude != null) 'starting_latitude': startingLatitude,
      if (startingLongitude != null) 'starting_longitude': startingLongitude,
      if (endingLatitude != null) 'ending_latitude': endingLatitude,
      if (endingLongitude != null) 'ending_longitude': endingLongitude,
      if (transportType != null) 'transport_type': transportType,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (basePoints != null) 'base_points': basePoints,
      if (streetGeometry != null) 'street_geometry': streetGeometry,
      if (status != null) 'status': status,
    };
  }
}

class RouteModel {
  final int id;
  final String title;
  final String sector;
  final String schedule;
  final int activeVolunteers;
  final List<String> volunteerEmojis;

  RouteModel({
    required this.id,
    required this.title,
    required this.sector,
    required this.schedule,
    required this.activeVolunteers,
    required this.volunteerEmojis,
  });
}

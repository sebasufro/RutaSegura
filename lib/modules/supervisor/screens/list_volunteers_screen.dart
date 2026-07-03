import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/volunteers_list_header.dart';
import '/modules/supervisor/widgets/volunteer_card.dart';
import '/modules/supervisor/services/enrolled_volunteers_service.dart';

class ListVolunteersScreen extends StatefulWidget {
  final String routeId;
  final String routeTitle;

  const ListVolunteersScreen({
    super.key,
    required this.routeId,
    required this.routeTitle,
  });

  @override
  State<ListVolunteersScreen> createState() => _ListVolunteersScreenState();
}

class _ListVolunteersScreenState extends State<ListVolunteersScreen> {
  List<Map<String, dynamic>> _volunteers = [];
  bool _loading = true;
  String? _error;

  static const List<Color> _avatarColors = [
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _fetchVolunteers();
  }

  Future<void> _fetchVolunteers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await EnrolledVolunteersService.findAll(widget.routeId);
      if (mounted) {
        setState(() {
          _volunteers = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  Color _getColor(int index) {
    return _avatarColors[index % _avatarColors.length];
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) {
        return 'hace ${diff.inMinutes} min';
      } else if (diff.inHours < 24) {
        return 'hace ${diff.inHours} h';
      } else {
        return 'hace ${diff.inDays} d';
      }
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _showVolunteerDetail(Map<String, dynamic> enrollment) async {
    final volunteerId = enrollment['id_volunteer'] as String;
    try {
      final detail =
          await EnrolledVolunteersService.findOne(widget.routeId, volunteerId);
      if (mounted) {
        _showDetailDialog(detail);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar detalles: $e')),
        );
      }
    }
  }

  void _showDetailDialog(Map<String, dynamic> detail) {
    final users = detail['users'] as Map<String, dynamic>? ?? {};
    final fullName = users['full_name'] as String? ?? 'Sin nombre';
    final rut = users['rut'] as String?;
    final phone = users['phone_number'] as String?;
    final email = users['email'] as String?;
    final emergencyContacts =
        users['emergency_contacts'] as List<dynamic>? ?? [];
    final addresses = users['user_addresses'] as List<dynamic>? ?? [];
    final enrollmentDate = detail['enrollment_date'] as String?;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 306,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              Row(
                spacing: 12,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColor(fullName.hashCode),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(fullName),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF002045),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                spacing: 12,
                children: [
                  if (rut != null)
                    _InfoRow(icon: Icons.badge, label: 'RUT', value: rut),
                  if (phone != null)
                    _InfoRow(icon: Icons.phone, label: 'Teléfono', value: phone),
                  if (email != null)
                    _InfoRow(icon: Icons.email, label: 'Email', value: email),
                  if (enrollmentDate != null)
                    _InfoRow(
                      icon: Icons.schedule,
                      label: 'Inscrito',
                      value: _formatDate(enrollmentDate),
                    ),
                  if (emergencyContacts.isNotEmpty)
                    _InfoRow(
                      icon: Icons.emergency,
                      label: 'Contacto emergencia',
                      value:
                          '${emergencyContacts.first['contact_name']} - ${emergencyContacts.first['contact_number']}',
                    ),
                  if (addresses.isNotEmpty)
                    _InfoRow(
                      icon: Icons.location_on,
                      label: 'Dirección',
                      value:
                          '${addresses.first['alias'] ?? ''}: ${addresses.first['full_address'] ?? ''}',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFF5F7FA),
          child: Column(
            children: [
              VolunteersListHeader(
                onBackPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                color: Colors.white,
                child: Text(
                  '${widget.routeTitle}\nVoluntarios',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 12,
                              children: [
                                Text(
                                  'Error al cargar voluntarios',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                TextButton(
                                  onPressed: _fetchVolunteers,
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          )
                        : _volunteers.isEmpty
                            ? Center(
                                child: Text(
                                  'No hay voluntarios inscritos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    spacing: 16,
                                    children: List.generate(
                                      _volunteers.length,
                                      (index) {
                                        final enrollment = _volunteers[index];
                                        final users = enrollment['users']
                                                as Map<String, dynamic>? ??
                                            {};
                                        final fullName = users['full_name']
                                                as String? ??
                                            'Desconocido';
                                        final enrollmentDate =
                                            enrollment['enrollment_date']
                                                as String?;

                                        return VolunteerCard(
                                          initials:
                                              _getInitials(fullName),
                                          avatarColor: _getColor(index),
                                          name: fullName,
                                          description: 'Voluntario inscrito',
                                          lastUpdate:
                                              _formatDate(enrollmentDate),
                                          batteryStatus: '-',
                                          onTap: () =>
                                              _showVolunteerDetail(enrollment),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE7ECFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(icon, color: const Color(0xFF002045), size: 20),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF002045),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

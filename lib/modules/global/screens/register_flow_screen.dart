import 'package:flutter/material.dart';
import '/modules/global/widgets/auth_header.dart';
import '/modules/global/widgets/register_step_account.dart';
import '/modules/global/widgets/register_step_role.dart';
import '/modules/global/widgets/register_step_org.dart';
import '/modules/global/widgets/register_step_person.dart';
import '/modules/global/widgets/register_step_emergency.dart';
import '/modules/global/services/auth_service.dart';
import '/modules/supervisor/widgets/supervisor_bottom_nav.dart';
import '/modules/volunteer/widgets/vol_navbar.dart';

/// Flujo completo de registro multi-paso que reúne los datos del usuario y envía el formulario final.
class RegisterFlowScreen extends StatefulWidget {
  const RegisterFlowScreen({super.key});

  @override
  State<RegisterFlowScreen> createState() => _RegisterFlowScreenState();
}

class _RegisterFlowScreenState extends State<RegisterFlowScreen> {
  int _currentPage = 0;
  bool _isSaving = false;

  final Map<String, dynamic> _formData = {
    'email': '',
    'password': '',
    'role': '', // 'SUPERVISOR' o 'VOLUNTEER'
    'full_name': '',
    'rut': '',
    'phone_number': '',
    'address': '',
    'organization': '',
    'id_legal_person': '',
    'certificate_name': '',
    'certificate_content': '', // base64
    'emergency_contact_name': '',
    'emergency_contact_number': '',
  };

  late PageController _pageController;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() => _currentPage = page);
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Después de elegir el rol: Supervisor -> página 2 (Org), Voluntario -> página 3 (Persona)
  void _handleRoleSelected(String backendRole) {
    if (backendRole == 'SUPERVISOR') {
      _goToPage(2);
    } else {
      _goToPage(3);
    }
  }

  Future<void> _handleFinish(Map<String, dynamic> payload) async {
    setState(() => _isSaving = true);

    final result = await _authService.signIn(payload);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result['success'] == true) {
      Widget landingPage = _formData['role'] == 'SUPERVISOR'
          ? const SupNavbar()
          : const VolNavbar();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => landingPage),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'No se pudo completar el registro',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AuthHeader(
                  onBack: () {
                    if (_currentPage > 0) {
                      _goToPage(_currentPage - 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    children: [
                      // 0: Cuenta
                      RegisterStepAccount(
                        formData: _formData,
                        onNext: () => _goToPage(1),
                      ),
                      // 1: Rol
                      RegisterStepRole(
                        formData: _formData,
                        onNext: _handleRoleSelected,
                      ),
                      // 2: Organización (solo Supervisor)
                      RegisterStepOrg(
                        formData: _formData,
                        onNext: () => _goToPage(3),
                      ),
                      // 3: Datos Personales
                      RegisterStepPerson(
                        formData: _formData,
                        onNext: () => _goToPage(4),
                      ),
                      // 4: Emergencia + envío final
                      RegisterStepEmergency(
                        formData: _formData,
                        onFinish: _handleFinish,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isSaving)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

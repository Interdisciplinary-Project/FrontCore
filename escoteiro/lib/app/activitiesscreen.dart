import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:escoteiro/app/galleryscreen.dart';
import 'package:escoteiro/app/HomeScreen.dart';
import 'package:escoteiro/app/perfilscreen.dart';
import 'package:escoteiro/models/activity_model.dart';
import 'package:escoteiro/services/activity_service.dart';
import 'package:escoteiro/services/auth_service.dart';
import 'package:escoteiro/app/manage_activities_screen.dart';
import 'package:escoteiro/utils/page_transitions.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final ActivityService _activityService = ActivityService();
  final AuthService _authService = AuthService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final isAdmin = await _authService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  Future<void> _participateInActivity(BuildContext context, ActivityModel activity) async {
    try {
      await _activityService.collectActivity(activity.id, activity.pontos, activity.title);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Parabéns! Você ganhou ${activity.pontos} pontos!'),
            backgroundColor: const Color(0xFF059A00),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().contains('já coletada') 
                ? 'Você já coletou esta atividade!' 
                : 'Erro ao coletar atividade. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: SvgPicture.asset(
              'assets/images/logos/logo-dark.svg',
              fit: BoxFit.contain,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Grupo Escoteiro Terra na Saudade - GETS',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF000000),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Próximas Atividades',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            if (_isAdmin)
              IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF059A00)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageActivitiesScreen(),
                    ),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<List<ActivityModel>>(
          stream: _activityService.getAvailableActivities(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF059A00),
                ),
              );
            }

            final activities = snapshot.data!;

            if (activities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma atividade disponível no momento',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: activities.map((activity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildActivityCard(
                    context: context,
                    activity: activity,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required BuildContext context,
    required ActivityModel activity,
  }) {
    final color = Color(
      int.parse(activity.colorHex.replaceFirst('#', '0xFF')),
    );
    final icon = _getIconData(activity.iconName);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF000000),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: Color(0xFFAFAFAF)),
                        const SizedBox(width: 4),
                        Text(
                          activity.date,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFAFAFAF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _participateInActivity(context, activity),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Participar (+${activity.pontos} pontos)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'terrain':
        return Icons.terrain;
      case 'medical_services':
        return Icons.medical_services_outlined;
      case 'local_florist':
        return Icons.local_florist_outlined;
      case 'people':
        return Icons.people_outline;
      case 'sports':
        return Icons.sports;
      case 'school':
        return Icons.school;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      default:
        return Icons.event;
    }
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFAFAFA),
        selectedItemColor: const Color(0xFF059A00),
        unselectedItemColor: const Color(0xFFAFAFAF),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.push(
              context,
              PageTransitions.fadeSlideTransition(page: const HomeScreen()),
            );
          } else if (i == 1) {
            Navigator.push(
              context,
              PageTransitions.fadeSlideTransition(page: const GalleryScreen()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              PageTransitions.fadeSlideTransition(page: const PerfilScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galeria'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Atividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F0E1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildActivitiesSection(context),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }
}
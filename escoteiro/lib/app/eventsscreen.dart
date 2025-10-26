import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoteiro/models/event_model.dart';
import 'package:escoteiro/services/auth_service.dart';
import 'package:escoteiro/app/add_event_screen.dart';
import 'package:escoteiro/app/event_detail_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: const Color(0xFFE2F0E1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2F0E1),
        foregroundColor: Colors.white,
        title: const Text(''),
        elevation: 0,
        leading: IconButton(
          color: const Color(0xFF000000),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildHeader(),
                const SizedBox(height: 16),
                _buildEventsSection(context, authService),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildEventsSection(BuildContext context, AuthService authService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(
            'Eventos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .orderBy('date', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Erro ao carregar eventos',
                style: TextStyle(color: Color(0xFFAFAFAF)),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF059A00)),
              );
            }

            final events = snapshot.data!.docs;

            if (events.isEmpty) {
              return const Text(
                'Nenhum evento cadastrado',
                style: TextStyle(color: Color(0xFFAFAFAF)),
              );
            }

            return Column(
              children: [
                ...events.map((doc) {
                  final event = EventModel.fromFirestore(doc);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildEventCard(
                      context,
                      event,
                    ),
                  );
                }),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        FutureBuilder<bool>(
          future: authService.isAdmin(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEventScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Criar Novo Evento'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF059A00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    IconData icon = Icons.event;
    Color color = const Color(0xFF059A00);

    if (event.title.toLowerCase().contains('workshop') || 
        event.title.toLowerCase().contains('técnica')) {
      icon = Icons.school;
      color = const Color(0xFF059A00);
    } else if (event.title.toLowerCase().contains('reunião')) {
      icon = Icons.people;
      color = const Color(0xFF00897B);
    } else if (event.title.toLowerCase().contains('acampamento') || 
               event.title.toLowerCase().contains('camping')) {
      icon = Icons.nature_people;
      color = const Color(0xFF4CAF50);
    } else if (event.title.toLowerCase().contains('atividade') || 
               event.title.toLowerCase().contains('ar livre')) {
      icon = Icons.hiking;
      color = const Color(0xFF8BC34A);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Color(0xFFAFAFAF)),
                      const SizedBox(width: 4),
                      Text(
                        event.getFormattedDate(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFAFAFAF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Color(0xFFAFAFAF)),
                      const SizedBox(width: 4),
                      Text(
                        '${event.startTime} - ${event.endTime}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFAFAFAF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFAFAFAF)),
          ],
        ),
      ),
    );
  }
}
import 'package:escoteiro/app/activitiesscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:escoteiro/app/communityscreen.dart';
import 'package:escoteiro/app/galleryscreen.dart';
import 'package:escoteiro/app/eventsscreen.dart';
import 'package:escoteiro/app/perfilscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoteiro/models/notice_model.dart';
import 'package:escoteiro/services/auth_service.dart';
import 'package:escoteiro/app/add_notice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                      _buildHistorySection(),
                      const SizedBox(height: 16),
                      _buildCommunityEventsCards(context),
                      const SizedBox(height: 16),
                      _buildRecentNotices(context),
                      const SizedBox(height: 16),
                      _buildContactButton(),
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

  Widget _buildHistorySection() {
    const historiaTexto =
        'No Movimento Escoteiro, cada atividade é uma oportunidade de aprendizado e crescimento. '
        'Desde aventuras ao ar livre até projetos que estimulam a criatividade, os jovens desenvolvem '
        'habilidades importantes enquanto fortalecem valores como trabalho em equipe, respeito e liderança. '
        'Participar desse movimento significa não apenas explorar novos horizontes, mas também construir memórias '
        'inesquecíveis que durarão para sempre, criando laços que atravessam gerações e mantendo o espírito do escotismo.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Text(
            'Nossa história',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/images/imagem-44.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          historiaTexto,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF000000),
            height: 1.6,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildCommunityEventsCards(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _AnimatedInfoCard(
              icon: Icons.groups,
              title: 'Comunidade',
              subtitle: 'Conhecer',
              onSubtitleTap: () => _showCommunityModal(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _AnimatedInfoCard(
              icon: Icons.calendar_today,
              title: 'Eventos',
              subtitle: 'Participe',
              onSubtitleTap: () => _showEventsModal(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalBar() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFCCCCCC),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  void _showCommunityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModalBar(),
                  const Text(
                    'Comunidade',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Conheça a nossa comunidade: encontros, grupos e formas de participar.',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Fechar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CommunityScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059A00),
                            foregroundColor: const Color(0xFFFFFFFF),
                          ),
                          child: const Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEventsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Wrap(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModalBar(),
                  const Text(
                    'Eventos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Veja os próximos eventos: reuniões, atividades e treinamentos.',
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Fechar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EventsScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF059A00),
                            foregroundColor: const Color(0xFFFFFFFF),
                          ),
                          child: const Text('Entrar'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentNotices(BuildContext context) {
    final authService = AuthService();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Avisos recentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            FutureBuilder<bool>(
              future: authService.isAdmin(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF059A00)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddNoticeScreen()),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notices')
              .orderBy('createdAt', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Erro ao carregar avisos',
                style: TextStyle(color: Color(0xFFAFAFAF)),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF059A00)),
              );
            }

            final notices = snapshot.data!.docs;

            if (notices.isEmpty) {
              return const Text(
                'Nenhum aviso recente',
                style: TextStyle(color: Color(0xFFAFAFAF)),
              );
            }

            return Column(
              children: notices.map((doc) {
                final notice = NoticeModel.fromFirestore(doc);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildNoticeCard(
                    title: notice.title,
                    description: notice.description,
                    timeAgo: notice.getTimeAgo(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoticeCard({
    required String title,
    required String description,
    required String timeAgo,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 110),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF059A00),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF000000),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              timeAgo,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFAFAFAF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final Uri whatsappUrl = Uri.parse(
      'https://api.whatsapp.com/send?phone=%2B5516991385661&data=ARAS4x0OdBvanOLmwpq6EgbrzRhqqGzQavOL0LJAHmqkGe4Y2HW0jerhFAI69cjU1AcYYdUi0gxhIzbT5elFJEe3IhkcmeFv5R4fAOUk5e-n-0iwKVs9sD4NlsChPH1pDzwSUw9qrzFJcJD66C-DsmzQ-w&source=FB_Page&app=facebook&entry_point=page_cta&fbclid=IwAR1JWOTuaIobAOSxqwj705nb6VK2li9ahZ0RdW1hkecmsJSTrF7yTIwmgdA'
    );
    
    try {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // Handle error if WhatsApp cannot be opened
    }
  }

  Widget _buildContactButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _openWhatsApp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF059A00),
          foregroundColor: const Color(0xFFFAFAFA),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'CONTATO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
        currentIndex: 0, 
        onTap: (i) {
          if (i == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GalleryScreen()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ActivitiesScreen()),
            );
          } else if (i == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PerfilScreen()),
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
}

class _AnimatedInfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onSubtitleTap;

  const _AnimatedInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onSubtitleTap,
  });

  @override
  State<_AnimatedInfoCard> createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<_AnimatedInfoCard> {
  double _scale = 1.0;

  Future<void> _animatePressAndCall() async {
    setState(() => _scale = 0.96);
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _scale = 1.0);
    await Future.delayed(const Duration(milliseconds: 120));
    widget.onSubtitleTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 40,
              color: const Color(0xFF000000),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: _animatePressAndCall,
                splashFactory: InkRipple.splashFactory,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF059A00),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
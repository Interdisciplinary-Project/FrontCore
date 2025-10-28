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
import 'package:escoteiro/utils/page_transitions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F0E1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          _buildHeader(),
                        ],
                      ),
                    ),
                    const _ImageCarouselSection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildCommunityEventsCards(context),
                          const SizedBox(height: 16),
                          _buildRecentNotices(context),
                          const SizedBox(height: 16),
                          _buildGroupStats(),
                          const SizedBox(height: 16),
                          _buildTopMembersRanking(),
                          const SizedBox(height: 16),
                          _buildHighlightsSection(),
                          const SizedBox(height: 16),
                          _buildContactButton(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                              MaterialPageRoute(builder: (context) => const CommunityScreen()),
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
                              MaterialPageRoute(builder: (context) => const EventsScreen()),
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
                fontSize: 16,
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
                        MaterialPageRoute(builder: (context) => const AddNoticeScreen()),
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

  Widget _buildGroupStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas do Grupo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return _buildStatCard(
                    icon: Icons.people,
                    value: count.toString(),
                    label: 'Membros',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('activities').snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return _buildStatCard(
                    icon: Icons.check_circle,
                    value: count.toString(),
                    label: 'Atividades',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                  return _buildStatCard(
                    icon: Icons.event,
                    value: count.toString(),
                    label: 'Eventos',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
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
        children: [
          Icon(icon, color: const Color(0xFF059A00), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopMembersRanking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ranking de Membros',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .orderBy('pontos', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Erro ao carregar ranking',
                style: TextStyle(color: Color(0xFFAFAFAF)),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF059A00)),
              );
            }

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Text(
                'Nenhum membro encontrado',
                style: TextStyle(color: Color(0xFFAFAFAF)),
              );
            }

            return Column(
              children: users.asMap().entries.map((entry) {
                final index = entry.key;
                final doc = entry.value;
                final data = doc.data() as Map<String, dynamic>;
                final name = data['nome'] ?? 'Sem nome';
                final points = data['pontos'] ?? 0;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildRankingCard(
                    position: index + 1,
                    name: name,
                    points: points,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRankingCard({
    required int position,
    required String name,
    required int points,
  }) {
    Color medalColor;
    IconData medalIcon;
    
    switch (position) {
      case 1:
        medalColor = const Color(0xFFFFD700);
        medalIcon = Icons.emoji_events;
        break;
      case 2:
        medalColor = const Color(0xFFC0C0C0);
        medalIcon = Icons.emoji_events;
        break;
      case 3:
        medalColor = const Color(0xFFCD7F32);
        medalIcon = Icons.emoji_events;
        break;
      default:
        medalColor = const Color(0xFF059A00);
        medalIcon = Icons.emoji_events;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF059A00),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(medalIcon, color: medalColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$points pontos',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$positionº',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF059A00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Destaques',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 12),
        _buildHighlightCard(
          icon: Icons.emoji_events,
          title: 'Conquiste Pontos',
          description: 'Complete atividades e suba no ranking do grupo!',
          color: const Color(0xFF059A00),
        ),
        const SizedBox(height: 12),
        _buildHighlightCard(
          icon: Icons.groups,
          title: 'Participe da Comunidade',
          description: 'Conecte-se com outros membros e compartilhe experiências.',
          color: const Color(0xFF0277BD),
        ),
        const SizedBox(height: 12),
        _buildHighlightCard(
          icon: Icons.photo_library,
          title: 'Galeria de Momentos',
          description: 'Reviva os melhores momentos do grupo na galeria.',
          color: const Color(0xFFE65100),
        ),
      ],
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              PageTransitions.fadeSlideTransition(page: const GalleryScreen()),
            );
          } else if (i == 2) {
            Navigator.push(
              context,
              PageTransitions.fadeSlideTransition(page: const ActivitiesScreen()),
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

class _ImageCarouselSection extends StatefulWidget {
  const _ImageCarouselSection();

  @override
  State<_ImageCarouselSection> createState() => _ImageCarouselSectionState();
}

class _CarouselItem {
  final String imagePath;
  final String description;

  const _CarouselItem({
    required this.imagePath,
    required this.description,
  });
}

class _ImageCarouselSectionState extends State<_ImageCarouselSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<_CarouselItem> _carouselItems = [
    const _CarouselItem(
      imagePath: 'assets/images/imagem-1.jpg',
      description: 'Atividades ao ar livre e aprendizado prático',
    ),
    const _CarouselItem(
      imagePath: 'assets/images/imagem-2.jpg',
      description: 'Desenvolvendo habilidades e valores escoteiros',
    ),
    const _CarouselItem(
      imagePath: 'assets/images/imagem-3.jpg',
      description: 'Construindo amizades e memórias inesquecíveis',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _carouselItems.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'Nossa história',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _carouselItems.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
                      }
                      return Center(
                        child: SizedBox(
                          height: Curves.easeInOut.transform(value) * 220,
                          child: child,
                        ),
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          _carouselItems[index].imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Text(
                              _carouselItems[index].description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_currentPage > 0)
              Positioned(
                left: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _previousPage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059A00).withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentPage < _carouselItems.length - 1)
              Positioned(
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _nextPage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059A00).withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _carouselItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF059A00)
                    : const Color(0xFF059A00).withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF059A00),
                width: 1.5,
              ),
            ),
            child: const Text(
              'O Grupo Escoteiro Terra na Saudade (GETS) é uma comunidade dedicada ao desenvolvimento de jovens através dos valores escoteiros. Fundado com o propósito de formar cidadãos conscientes e preparados para os desafios da vida, promovemos atividades ao ar livre, trabalho em equipe e aprendizado prático. Nossa missão é cultivar liderança, responsabilidade e respeito pela natureza, criando experiências inesquecíveis que transformam vidas.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoteiro/app/homescreen.dart';
import 'package:escoteiro/app/galleryscreen.dart';
import 'package:escoteiro/app/activitiesscreen.dart';
import 'package:escoteiro/app/loginscreen.dart';
import 'package:escoteiro/app/datascreen.dart';
import 'package:escoteiro/app/settingsscreen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  static const Color primaryGreen = Color(0xFF059A00);
  static const Color lightBackground = Color(0xFFE2F0E1);
  static const Color cardColor = Color(0xFFFAFAFA);
  static const Color profileCardBg = Color(0xFFEAF5E9); 
  static const Color nextActivityBg = Color(0xFFE6F3FF);
  static const Color nextActivityColor = Color(0xFF007AFF);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Perfil',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildProfileCard(
                            context: context,
                            nome: 'Erro ao carregar',
                            ramo: '',
                            dataIngressao: '',
                          );
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return _buildProfileCard(
                            context: context,
                            nome: user?.email?.split('@')[0] ?? 'Usuário',
                            ramo: 'Não definido',
                            dataIngressao: 'Não definido',
                          );
                        }

                        final userData = snapshot.data!.data() as Map<String, dynamic>;
                        final nome = userData['nome'] ?? '';
                        final sobrenome = userData['sobrenome'] ?? '';
                        final nomeCompleto = '$nome $sobrenome'.trim();
                        
                        return _buildProfileCard(
                          context: context,
                          nome: nomeCompleto.isNotEmpty ? nomeCompleto : 'Usuário',
                          ramo: userData['ramo'] ?? 'Não definido',
                          dataIngressao: userData['dataIngressao'] ?? 'Não definido',
                          pontos: userData['pontos'] ?? 0,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final userData = snapshot.hasData && snapshot.data!.exists
                            ? snapshot.data!.data() as Map<String, dynamic>
                            : <String, dynamic>{};
                        
                        return Column(
                          children: [
                            _buildSettingsItem(
                              icon: Icons.person_outline,
                              title: 'Meus Dados',
                              subtitle: _buildUserDataSubtitle(userData),
                              onTap: () {
                                _showUserDataDialog(context, userData);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingsItem(
                              icon: Icons.settings_outlined,
                              title: 'Configurações',
                              subtitle: 'Notificações e privacidade',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildNextActivityCard(),
                    const SizedBox(height: 24),
                    _buildLogOutButton(context),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  String _buildUserDataSubtitle(Map<String, dynamic> userData) {
    final telefone = userData['telefone'] ?? '';
    final endereco = userData['endereco'] ?? '';
    
    if (telefone.isNotEmpty && endereco.isNotEmpty) {
      return '$telefone • ${endereco.split(',')[0]}';
    } else if (telefone.isNotEmpty) {
      return telefone;
    } else if (endereco.isNotEmpty) {
      return endereco.split(',')[0];
    }
    return 'Adicione suas informações';
  }

  void _showUserDataDialog(BuildContext context, Map<String, dynamic> userData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DataScreen(),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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

  Widget _buildProfileCard({
    required BuildContext context,
    required String nome,
    required String ramo,
    required String dataIngressao,
    int pontos = 0,
  }) {
    final anoIngressao = dataIngressao.isNotEmpty && dataIngressao.contains('/')
        ? dataIngressao.split('/').last
        : dataIngressao;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: profileCardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: primaryGreen,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nome,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ramo,
            style: const TextStyle(
              fontSize: 14,
              color: primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Membro desde $anoIngressao',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: 16,
                  color: primaryGreen,
                ),
                const SizedBox(width: 4),
                Text(
                  '$pontos pontos',
                  style: const TextStyle(
                    fontSize: 13,
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF000000),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF757575),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextActivityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: nextActivityBg, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: nextActivityColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Próxima Atividade',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: nextActivityColor, 
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.rocket_launch, 
                color: nextActivityColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Escola Patrulheira',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '25 de outubro de 2025',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Sair do Perfil',
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
        color: cardColor,
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
        backgroundColor: cardColor,
        selectedItemColor: primaryGreen,
        unselectedItemColor: const Color(0xFFAFAFAF),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (i == 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const GalleryScreen()),
            );
          } else if (i == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_outlined), label: 'Galeria'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Atividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
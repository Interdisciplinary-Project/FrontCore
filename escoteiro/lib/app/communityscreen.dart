import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoteiro/models/user_model.dart';
import 'package:escoteiro/models/discussion_model.dart';
import 'package:escoteiro/services/auth_service.dart';
import 'package:escoteiro/app/discussion_detail_screen.dart';
import 'package:escoteiro/app/create_discussion_screen.dart';
import 'package:escoteiro/app/members_list_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final AuthService _authService = AuthService();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _authService.isAdmin();
    setState(() => _isAdmin = isAdmin);
  }

  Future<void> _deleteDiscussion(String discussionId, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('discussions')
          .doc(discussionId)
          .delete();

      final replies = await FirebaseFirestore.instance
          .collection('replies')
          .where('discussionId', isEqualTo: discussionId)
          .get();

      for (var doc in replies.docs) {
        await doc.reference.delete();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excluído com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                
                if (_isAdmin) ...[
                  _buildSectionHeader('Membros Ativos', onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MembersList()),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildMembersSection(),
                  const SizedBox(height: 24),
                ],
                
                
                _buildSectionHeader('Discussões Recentes', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateDiscussion(type: 'discussion'),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                _buildDiscussionsSection('discussion'),
                const SizedBox(height: 24),
                
                _buildSectionHeader('Compartilhe suas ideias', onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateDiscussion(type: 'idea'),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                _buildDiscussionsSection('idea'),
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

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
        if (onTap != null)
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF059A00)),
            onPressed: onTap,
          ),
      ],
    );
  }

  Widget _buildMembersSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao carregar membros');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final members = snapshot.data!.docs;

        if (members.isEmpty) {
          return const Text('Nenhum membro encontrado');
        }

        return Column(
          children: members.map((doc) {
            final user = UserModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
            final data = doc.data() as Map<String, dynamic>;
            final isActive = data['isActive'] ?? true;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildMemberCard(
                user.nomeCompleto,
                isActive ? 'Ativo' : 'Desativo',
                isActive,
                Icons.person,
                const Color(0xFF059A00),
              ),
            );
          }).toList(),
        );
      },
    );
  }


  Widget _buildDiscussionsSection(String type) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('discussions')
          .where('type', isEqualTo: type)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao carregar discussões');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final discussions = snapshot.data!.docs;

        if (discussions.isEmpty) {
          return const Text('Nenhuma discussão encontrada');
        }

        return Column(
          children: discussions.map((doc) {
            final discussion = DiscussionModel.fromFirestore(doc);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildDiscussionCard(
                discussion.title,
                '${discussion.repliesCount} respostas',
                type == 'idea' ? Icons.lightbulb_outline : Icons.chat_bubble_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiscussionDetail(discussion: discussion),
                    ),
                  );
                },
                onDelete: _isAdmin
                    ? () => _deleteDiscussion(discussion.id, discussion.title)
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDiscussionCard(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF059A00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF059A00)),
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
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFAFAFAF),
                    ),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            if (onDelete != null) const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFAFAFAF)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(String name, String status, bool isActive, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? const Color(0xFF059A00).withOpacity(0.1)
                        : const Color(0xFFFF6B6B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive 
                          ? const Color(0xFF059A00)
                          : const Color(0xFFFF6B6B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
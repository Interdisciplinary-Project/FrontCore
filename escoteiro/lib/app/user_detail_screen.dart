import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoteiro/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  static const Color primaryGreen = Color(0xFF059A00);
  static const Color lightBackground = Color(0xFFE2F0E1);
  static const Color cardColor = Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text(
          'Detalhes do Usuário',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildPersonalInfo(),
            const SizedBox(height: 16),
            _buildContactInfo(),
            const SizedBox(height: 16),
            _buildAddressInfo(),
            const SizedBox(height: 16),
            _buildStats(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: const BoxDecoration(
        color: primaryGreen,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              user.nome.isNotEmpty ? user.nome[0].toUpperCase() : 'U',
              style: const TextStyle(
                color: primaryGreen,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.nomeCompleto,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.ramo.isNotEmpty ? user.ramo : 'Ramo não definido',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (user.isAdmin) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: 20,
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                Text(
                  '${user.pontos} pontos',
                  style: const TextStyle(
                    fontSize: 16,
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

  Widget _buildPersonalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: primaryGreen,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Informações Pessoais',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Nome Completo',
              user.nomeCompleto.isNotEmpty ? user.nomeCompleto : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Data de Nascimento',
              user.dataNascimento.isNotEmpty ? user.dataNascimento : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Data de Ingresso',
              user.dataIngressao.isNotEmpty ? user.dataIngressao : 'Não informado',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.contact_phone_outlined,
                  color: primaryGreen,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Contato',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Email',
              user.email.isNotEmpty ? user.email : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Telefone',
              user.telefone.isNotEmpty ? user.telefone : 'Não informado',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: primaryGreen,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Endereço',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Endereço',
              user.endereco.isNotEmpty ? user.endereco : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Bairro',
              user.bairro.isNotEmpty ? user.bairro : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'CEP',
              user.cep.isNotEmpty ? user.cep : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Cidade',
              user.cidade.isNotEmpty ? user.cidade : 'Não informado',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Estado',
              user.estado.isNotEmpty ? user.estado : 'Não informado',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user_activities')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final completedActivities = snapshot.hasData 
              ? snapshot.data!.docs.length 
              : 0;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: primaryGreen,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Estatísticas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.check_circle,
                      value: completedActivities.toString(),
                      label: 'Atividades\nConcluídas',
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: primaryGreen.withOpacity(0.2),
                    ),
                    _buildStatItem(
                      icon: Icons.star,
                      value: user.pontos.toString(),
                      label: 'Pontos\nAcumulados',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF000000),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryGreen,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
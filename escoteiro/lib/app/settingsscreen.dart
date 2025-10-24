import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color primaryGreen = Color(0xFF059A00);
  static const Color lightBackground = Color(0xFFE2F0E1);
  static const Color cardColor = Color(0xFFFAFAFA);

  bool _notificacoesAtividades = true;
  bool _notificacoesEventos = true;
  bool _notificacoesGaleria = false;
  bool _perfilPublico = true;
  bool _mostrarEmail = false;
  bool _mostrarTelefone = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>?;

        if (settings != null) {
          setState(() {
            _notificacoesAtividades = settings['notificacoesAtividades'] ?? true;
            _notificacoesEventos = settings['notificacoesEventos'] ?? true;
            _notificacoesGaleria = settings['notificacoesGaleria'] ?? false;
            _perfilPublico = settings['perfilPublico'] ?? true;
            _mostrarEmail = settings['mostrarEmail'] ?? false;
            _mostrarTelefone = settings['mostrarTelefone'] ?? true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar configurações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'settings': {
          'notificacoesAtividades': _notificacoesAtividades,
          'notificacoesEventos': _notificacoesEventos,
          'notificacoesGaleria': _notificacoesGaleria,
          'perfilPublico': _perfilPublico,
          'mostrarEmail': _mostrarEmail,
          'mostrarTelefone': _mostrarTelefone,
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configurações salvas com sucesso!'),
            backgroundColor: primaryGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar configurações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Notificações'),
              const SizedBox(height: 12),
              _buildSettingsCard(
                children: [
                  _buildSwitchTile(
                    title: 'Atividades',
                    subtitle: 'Receber notificações sobre novas atividades',
                    value: _notificacoesAtividades,
                    onChanged: (value) {
                      setState(() => _notificacoesAtividades = value);
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: 'Eventos',
                    subtitle: 'Receber notificações sobre eventos próximos',
                    value: _notificacoesEventos,
                    onChanged: (value) {
                      setState(() => _notificacoesEventos = value);
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: 'Galeria',
                    subtitle: 'Receber notificações sobre novas fotos',
                    value: _notificacoesGaleria,
                    onChanged: (value) {
                      setState(() => _notificacoesGaleria = value);
                      _saveSettings();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Privacidade'),
              const SizedBox(height: 12),
              _buildSettingsCard(
                children: [
                  _buildSwitchTile(
                    title: 'Perfil Público',
                    subtitle: 'Permitir que outros membros vejam seu perfil',
                    value: _perfilPublico,
                    onChanged: (value) {
                      setState(() => _perfilPublico = value);
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: 'Mostrar E-mail',
                    subtitle: 'Exibir seu e-mail no perfil público',
                    value: _mostrarEmail,
                    onChanged: (value) {
                      setState(() => _mostrarEmail = value);
                      _saveSettings();
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: 'Mostrar Telefone',
                    subtitle: 'Exibir seu telefone no perfil público',
                    value: _mostrarTelefone,
                    onChanged: (value) {
                      setState(() => _mostrarTelefone = value);
                      _saveSettings();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
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
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
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
                const SizedBox(height: 4),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: primaryGreen,
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escoteiro/models/discussion_model.dart';
import 'package:escoteiro/models/reply_model.dart';
import 'package:escoteiro/services/auth_service.dart';

class DiscussionDetail extends StatefulWidget {
  final DiscussionModel discussion;

  const DiscussionDetail({super.key, required this.discussion});

  @override
  State<DiscussionDetail> createState() => _DiscussionDetailState();
}

class _DiscussionDetailState extends State<DiscussionDetail> {
  final AuthService _authService = AuthService();
  final TextEditingController _replyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _addReply() async {
    if (_replyController.text.trim().isEmpty) return;

    final userData = await _authService.getCurrentUserData();
    if (userData == null) {
      print('ERROR: userData is null');
      return;
    }

    try {
      print('=== REPLY CREATION DEBUG ===');
      print('User authenticated: ${_authService.currentUser != null}');
      print('User UID: ${_authService.currentUser?.uid}');
      print('User email: ${_authService.currentUser?.email}');
      print('Discussion ID: ${widget.discussion.id}');
      print('Author ID: ${userData.uid}');
      print('Author Name: ${userData.nomeCompleto}');
      print('Content: ${_replyController.text.trim()}');
      print('Timestamp: ${Timestamp.now()}');
      
      final replyData = {
        'discussionId': widget.discussion.id,
        'content': _replyController.text.trim(),
        'authorId': userData.uid,
        'authorName': userData.nomeCompleto,
        'createdAt': Timestamp.now(),
      };
      
      print('Reply data to be sent: $replyData');
      print('Attempting to write to Firestore...');
      
      await _firestore.collection('replies').add(replyData);
      
      print('Reply added successfully!');

      await _firestore.collection('discussions').doc(widget.discussion.id).update({
        'repliesCount': FieldValue.increment(1),
      });

      _replyController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resposta adicionada com sucesso!')),
        );
      }
    } catch (e) {
      print('=== ERROR DETAILS ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace:');
      print(StackTrace.current);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar resposta: $e')),
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
        foregroundColor: const Color(0xFF000000),
        title: const Text('Discussão'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.discussion.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Por ${widget.discussion.authorName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAFAFAF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.discussion.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Respostas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('replies')
                        .where('discussionId', isEqualTo: widget.discussion.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Erro ao carregar respostas');
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final replies = snapshot.data!.docs;

                      if (replies.isEmpty) {
                        return const Text(
                          'Nenhuma resposta ainda. Seja o primeiro a comentar!',
                          style: TextStyle(color: Color(0xFFAFAFAF)),
                        );
                      }

                      final sortedReplies = List.from(replies);
                      sortedReplies.sort((a, b) {
                        final aData = a.data() as Map<String, dynamic>;
                        final bData = b.data() as Map<String, dynamic>;
                        final aTime = (aData['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970);
                        final bTime = (bData['createdAt'] as Timestamp?)?.toDate() ?? DateTime(1970);
                        return aTime.compareTo(bTime);
                      });

                      return Column(
                        children: sortedReplies.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final authorName = data['authorName'] ?? 'Anônimo';
                          final content = data['content'] ?? '';
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF059A00),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    content,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              border: Border(
                top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Escreva sua resposta...',
                      hintStyle: const TextStyle(color: Color(0xFFAFAFAF)),
                      filled: true,
                      fillColor: const Color(0xFFE2F0E1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addReply,
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF059A00),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF059A00).withOpacity(0.1),
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
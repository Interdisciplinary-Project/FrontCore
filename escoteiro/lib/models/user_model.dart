class UserModel {
  final String uid;
  final String email;
  final String nome;
  final String sobrenome;
  final String telefone;
  final String endereco;
  final String cep;
  final String bairro;
  final String cidade;
  final String estado;
  final String dataNascimento;
  final String dataIngressao;
  final String ramo;
  final String role;
  final int pontos;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.nome,
    required this.sobrenome,
    required this.telefone,
    required this.endereco,
    required this.cep,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.dataNascimento,
    required this.dataIngressao,
    required this.ramo,
    this.role = 'user',
    this.pontos = 0,
    this.createdAt,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      nome: data['nome'] ?? '',
      sobrenome: data['sobrenome'] ?? '',
      telefone: data['telefone'] ?? '',
      endereco: data['endereco'] ?? '',
      cep: data['cep'] ?? '',
      bairro: data['bairro'] ?? '',
      cidade: data['cidade'] ?? '',
      estado: data['estado'] ?? '',
      dataNascimento: data['dataNascimento'] ?? '',
      dataIngressao: data['dataIngressao'] ?? '',
      ramo: data['ramo'] ?? '',
      role: data['role'] ?? 'user',
      pontos: data['pontos'] ?? 0,
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nome': nome,
      'sobrenome': sobrenome,
      'telefone': telefone,
      'endereco': endereco,
      'cep': cep,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'dataNascimento': dataNascimento,
      'dataIngressao': dataIngressao,
      'ramo': ramo,
      'role': role,
      'pontos': pontos,
    };
  }

  String get nomeCompleto => '$nome $sobrenome'.trim();
  bool get isAdmin => role == 'admin';
}
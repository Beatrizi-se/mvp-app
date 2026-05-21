class UserModel {
  final String id;
  final String nome;
  final String email;
  final String token;
  final String? profileImage; // URL ou Base64 da imagem
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.token,
    this.profileImage,
    this.createdAt,
  });

  // Converte de JSON para Objeto
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Tenta pegar 'id' ou '_id' e converte para String, ou usa um valor vazio se não existir
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      nome: json['nome'] ?? 'Usuário',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      profileImage: json['profileImage'],
      // Se não vier data do banco, usamos a data atual como fallback "automático"
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  // Converte de Objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'token': token,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    String? token,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      token: token ?? this.token,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

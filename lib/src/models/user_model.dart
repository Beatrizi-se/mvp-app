class UserModel {
  final String id;
  final String nome;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.token,
  });

  // Converte de JSON para Objeto
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  // Converte de Objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'token': token,
    };
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../config/api_config.dart';

class AuthService {
  // As rotas de autenticação agora usam o prefixo /auth conforme a nova estrutura do servidor
  static const String _loginPath = '/auth/login';
  static const String _registerPath = '/auth/register';

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$_loginPath'),
        headers: ApiConfig.headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      return _handleUserResponse(response, 'Falha ao realizar login');
    } catch (e) {
      throw Exception(_parseErrorMessage(e));
    }
  }

  Future<void> register(String nome, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$_registerPath'),
        headers: ApiConfig.headers(),
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw await _handleError(response, 'Falha ao realizar cadastro');
      }
    } catch (e) {
      throw Exception(_parseErrorMessage(e));
    }
  }

  UserModel _handleUserResponse(http.Response response, String defaultError) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw _handleError(response, defaultError);
    }
  }

  dynamic _handleError(http.Response response, String defaultError) {
    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      final data = jsonDecode(response.body);
      return data['message'] ?? defaultError;
    } else {
      if (response.statusCode == 404) {
        return 'Rota não encontrada no servidor (404). Verifique se a API está usando /auth/login e /auth/register.';
      } else if (response.statusCode == 401) {
        return 'Não autorizado (401). Credenciais incorretas.';
      } else if (response.statusCode >= 500) {
        return 'Erro interno do servidor (500).';
      }
      return 'Erro inesperado do servidor (${response.statusCode}).';
    }
  }

  String _parseErrorMessage(dynamic e) {
    if (e.toString().contains('FormatException')) {
      return 'Resposta inválida do servidor. Verifique se o servidor está rodando em ${ApiConfig.baseUrl}';
    }
    if (e.toString().contains('Connection refused') || e.toString().contains('SocketException')) {
      return 'Não foi possível conectar ao servidor. Verifique se o IP ${ApiConfig.baseUrl} está correto e se o servidor está online.';
    }
    return e.toString().replaceAll('Exception: ', '');
  }
}

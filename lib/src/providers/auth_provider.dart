import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();
  final _authService = AuthService();

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    // Nota: Em um app real, você pode querer validar o token com o backend aqui
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      // Se tiver token, por enquanto assumimos que o usuário pode estar logado
      // Idealmente buscaríamos os dados do usuário do storage ou API
    }
  }

  Future<void> register(String nome, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.register(nome, email, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userModel = await _authService.login(email, password);
      _user = userModel;
      await _storage.write(key: 'jwt_token', value: userModel.token);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile(String nome, String email, {String? profileImage}) async {
    if (_user == null) {
      throw Exception('Usuário não autenticado');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await _authService.updateProfile(
        _user!.token, 
        nome, 
        email, 
        profileImage: profileImage
      );
      _user = updatedUser;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

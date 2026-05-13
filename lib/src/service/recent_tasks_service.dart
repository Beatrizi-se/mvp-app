import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class RecentTasksService {
  // Substitua pela URL da sua API
  final String _baseUrl = 'https://sua-api.com/v1';

  Future<List<TaskModel>> getAllTasks(String token) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/tasks'), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token',});

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar tarefas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }
}

import 'dart:convert';
import '../models/task_model.dart';
import 'api_client.dart';

class RecentTasksService {
  final ApiClient _apiClient = ApiClient();

  // Rota de tarefas conforme a nova estrutura do servidor
  static const String _tasksPath = '/tarefas';

  Future<List<TaskModel>> getAllTasks() async {
    try {
      final response = await _apiClient.get(_tasksPath);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TaskModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sessão expirada ou não autorizada. Por favor, faça login novamente.');
      } else {
        throw Exception('Falha ao carregar tarefas: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Connection refused')) {
        throw Exception('Servidor offline. Verifique a conexão.');
      }
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }

  Future<void> toggleFavorite(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(isFavorite: !task.isFavorite);
      final response = await _apiClient.patch(
        '$_tasksPath/${task.id}',
        body: updatedTask.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao atualizar favorito');
      }
    } catch (e) {
      throw Exception('Erro ao favoritar tarefa: $e');
    }
  }
}

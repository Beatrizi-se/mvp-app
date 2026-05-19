import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../models/task_model.dart';

class TaskService {
  final ApiClient _apiClient = ApiClient();

  static const String _tasksPath = '/tarefas';

  Future<void> createTask(Map<String, dynamic> taskData) async {
    try {
      final response = await _apiClient.post(_tasksPath, body: taskData);
      _handleResponse(response, 'Falha ao criar tarefa');
    } catch (e) {
      throw Exception(_parseErrorMessage(e));
    }
  }

  Future<void> updateTask(String id, Map<String, dynamic> taskData) async {
    try {
      // ATENÇÃO: O seu backend usa POST para a rota de atualização /tarefas/:id
      final response = await _apiClient.post('$_tasksPath/$id', body: taskData);
      _handleResponse(response, 'Falha ao atualizar tarefa');
    } catch (e) {
      throw Exception(_parseErrorMessage(e));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await _apiClient.delete('$_tasksPath/$id');
      _handleResponse(response, 'Falha ao remover tarefa');
    } catch (e) {
      throw Exception(_parseErrorMessage(e));
    }
  }

  Future<List<TaskStep>> generateStepsWithAI(String title, String subtitle) async {
    try {
      final response = await _apiClient.post('$_tasksPath/desmembrar', body: {
        'title': title,
        'subtitle': subtitle,
      });

      print('DEBUG: Resposta bruta da IA: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> stepsJson = data['steps'] ?? [];
        
        // Mapeamento flexível para aceitar diferentes formatos do backend
        return stepsJson.map((s) {
          if (s is String) {
            return TaskStep(title: s, isCompleted: false);
          } else if (s is Map) {
            return TaskStep(
              title: s['title']?.toString() ?? s['step']?.toString() ?? 'Passo sem título',
              isCompleted: s['isCompleted'] ?? false,
            );
          }
          return TaskStep(title: 'Passo desconhecido');
        }).toList();
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['erro'] ?? 'Falha ao gerar passos com IA');
      }
    } catch (e) {
      print('DEBUG: Erro ao processar passos da IA: $e');
      throw Exception(_parseErrorMessage(e));
    }
  }

  void _handleResponse(http.Response response, String defaultError) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? data['erro'] ?? defaultError;
    } else {
      if (response.statusCode == 404) {
        throw 'Rota não encontrada no servidor (404). Verifique se o ID da tarefa está correto.';
      } else if (response.statusCode == 401) {
        throw 'Sessão expirada ou não autorizada (401). Faça login novamente.';
      } else if (response.statusCode >= 500) {
        throw 'Erro interno do servidor (500).';
      }
      throw 'Erro inesperado do servidor (${response.statusCode}).';
    }
  }

  String _parseErrorMessage(dynamic e) {
    if (e.toString().contains('FormatException')) {
      return 'O servidor retornou uma resposta inesperada. Verifique se a rota está correta no backend.';
    }
    if (e.toString().contains('Connection refused') || e.toString().contains('SocketException')) {
      return 'Não foi possível conectar ao servidor. Verifique se ele está online.';
    }
    return e.toString().replaceAll('Exception: ', '');
  }
}

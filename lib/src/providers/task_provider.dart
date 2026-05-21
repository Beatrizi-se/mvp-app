import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../service/recent_tasks_service.dart';
import '../service/task_service.dart';

class TaskProvider with ChangeNotifier {
  final RecentTasksService _recentTasksService = RecentTasksService();
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<TaskModel> get recentTasks {
    return _tasks.take(3).toList();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _recentTasksService.getAllTasks();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTaskProgress(TaskModel updatedTask) async {
    // Atualiza localmente primeiro para resposta instantânea na UI
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }

    try {
      if (updatedTask.id != null) {
        await _taskService.updateTask(updatedTask.id!, updatedTask.toJson());
        // Opcional: fetch de novo para garantir sincronia com o banco
        // _tasks = await _recentTasksService.getAllTasks();
        // notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Falha ao salvar no servidor: $e';
      // Reverte em caso de erro se necessário, ou apenas avisa
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleFavorite(TaskModel task) async {
    try {
      await _recentTasksService.toggleFavorite(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(isFavorite: !task.isFavorite);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}

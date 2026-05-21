import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../models/task_step_model.dart';
import '../providers/task_provider.dart';
import '../service/task_service.dart';
import '../widgets/task_form_header.dart';
import '../widgets/task_form_selector_field.dart';
import '../widgets/task_form_ai_section.dart';
import '../widgets/task_form_steps_list.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../service/notification_service.dart';

class TaskFormPage extends StatefulWidget {
  final TaskModel? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late bool isEditing;
  bool _useAI = true;
  bool _isLoading = false;
  
  final TaskService _taskService = TaskService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final List<TaskStep> _steps = [];

  String _selectedCategory = 'Selecionar';
  String _selectedPriority = 'Normal';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Só é edição se tivermos uma tarefa E essa tarefa tiver um ID (do banco)
    isEditing = widget.task != null && (widget.task!.id != null);
    
    debugPrint('DEBUG: TaskFormPage - isEditing: $isEditing, id: ${widget.task?.id}');

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.subtitle;
      _selectedCategory = widget.task!.category;
      _selectedPriority = widget.task!.priority;
      _selectedDate = widget.task!.date;
      if (widget.task!.time != null) {
        final parts = widget.task!.time!.split(':');
        if (parts.length == 2) {
          _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      }
      _steps.addAll(widget.task!.steps);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String get _formattedDate => _selectedDate == null 
      ? 'Definir data' 
      : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";

  String get _formattedTime => _selectedTime == null 
      ? 'Definir horário' 
      : "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _pickCategory() {
    final categories = ['Estudos', 'Trabalho', 'Saúde', 'Lazer', 'Outros'];
    _showSelectionSheet('Categoria', categories, (value) {
      setState(() => _selectedCategory = value);
    });
  }

  void _pickPriority() {
    final priorities = ['Baixa', 'Normal', 'Média', 'Alta', 'Urgente'];
    _showSelectionSheet('Prioridade', priorities, (value) {
      setState(() => _selectedPriority = value);
    });
  }

  void _showSelectionSheet(String title, List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...options.map((option) => ListTile(
                title: Text(option, style: GoogleFonts.poppins()),
                onTap: () {
                  onSelect(option);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _showAddStepDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo Passo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Ex: Ler capítulo 1"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _steps.add(TaskStep(title: controller.text)));
              }
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGenerateAI() async {
    final title = _titleController.text.trim();
    final subtitle = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um título para que o Pato possa ajudar!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final aiSteps = await _taskService.generateStepsWithAI(title, subtitle);
      
      if (aiSteps.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('O Pato não conseguiu criar passos. Tente um título mais detalhado! 🦆😕')),
          );
        }
        return;
      }

      setState(() {
        _steps.addAll(aiSteps);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O Pato desmembrou a tarefa para você! 🦆✨')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na IA: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleStep(int index) {
    setState(() {
      final step = _steps[index];
      _steps[index] = step.copyWith(
        isCompleted: !step.isCompleted,
      );
    });
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final subtitle = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um título.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final taskJson = {
        'title': title,
        'subtitle': subtitle,
        'category': _selectedCategory,
        'priority': _selectedPriority,
        'date': _selectedDate?.toIso8601String(),
        'time': _selectedTime != null ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}' : null,
        'steps': _steps.map((s) => s.toJson()).toList(),
      };

      if (isEditing) {
        final taskId = widget.task!.id;
        if (taskId == null) {
          throw Exception('Erro interno: ID da tarefa não encontrado para edição.');
        }
        await _taskService.updateTask(taskId, taskJson);
      } else {
        await _taskService.createTask(taskJson);
      }

      // Notifica o Provider para atualizar todas as telas
      if (mounted) {
        context.read<TaskProvider>().fetchTasks();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa salva com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar tarefa: ${e.toString().replaceAll('Exception: ', '')}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskFormHeader(isEditing: isEditing),
            const SizedBox(height: 32),
            
            AppTextField(
              label: 'Título da tarefa',
              controller: _titleController,
              hintText: 'Ex: Estudar para prova',
              maxLength: 100,
              onChanged: (_) => setState(() {}),
            ),
            
            const SizedBox(height: 20),
            
            AppTextField(
              label: 'Descrição (opcional)',
              controller: _descController,
              hintText: 'Adicione mais detalhes sobre a tarefa...',
              maxLines: 3,
              maxLength: 300,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: TaskFormSelectorField(
                  label: 'Categoria', 
                  value: _selectedCategory, 
                  icon: Icons.book_outlined,
                  onTap: _pickCategory,
                )),
                const SizedBox(width: 16),
                Expanded(child: TaskFormSelectorField(
                  label: 'Prioridade', 
                  value: _selectedPriority, 
                  icon: Icons.flag_outlined, 
                  iconColor: Colors.amber,
                  onTap: _pickPriority,
                )),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: TaskFormSelectorField(
                  label: 'Data', 
                  value: _formattedDate, 
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                )),
                const SizedBox(width: 16),
                Expanded(child: TaskFormSelectorField(
                  label: 'Horário', 
                  value: _formattedTime, 
                  icon: Icons.access_time,
                  onTap: _pickTime,
                )),
              ],
            ),

            const SizedBox(height: 32),
            TaskFormAISection(
              useAI: _useAI,
              onToggleAI: (v) => setState(() => _useAI = v),
              onGenerateSteps: _handleGenerateAI,
            ),
            
            const SizedBox(height: 32),
            TaskFormStepsList(
              steps: _steps,
              onAddStep: _showAddStepDialog,
              onDeleteStep: (index) => setState(() => _steps.removeAt(index)),
              onToggleStep: _toggleStep,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final step = _steps.removeAt(oldIndex);
                  _steps.insert(newIndex, step);
                });
              },
            ),

            const SizedBox(height: 40),
            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : AppButton(
                  text: isEditing ? 'Salvar alterações' : 'Criar tarefa',
                  icon: Icons.check,
                  borderRadius: 16,
                  onPressed: () async {
          _handleSave(); 
          await NotificationService().testarLembrete(); 
        },
                ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Image.asset('assets/pato_logo.png', height: 60),
      centerTitle: true,
      actions: [
        if (isEditing)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Excluir Tarefa'),
                  content: const Text('Tem certeza que deseja remover esta tarefa?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                setState(() => _isLoading = true);
                try {
                  await _taskService.deleteTask(widget.task!.id!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tarefa removida!')));
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              }
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}

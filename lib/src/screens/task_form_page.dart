import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../widgets/task_step_item.dart';
import '../widgets/task_form_header.dart';
import '../widgets/task_form_selector_field.dart';
import '../widgets/task_form_ai_section.dart';
import '../widgets/task_form_steps_list.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

class TaskFormPage extends StatefulWidget {
  final TaskModel? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late bool isEditing;
  bool _useAI = true;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final List<String> _steps = [];

  // Variáveis de estado para os seletores
  String _selectedCategory = 'Selecionar';
  String _selectedPriority = 'Normal';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    isEditing = widget.task != null;
    if (isEditing) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.subtitle;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- Lógica de Formatação ---
  String get _formattedDate => _selectedDate == null 
      ? 'Definir data' 
      : "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";

  String get _formattedTime => _selectedTime == null 
      ? 'Definir horário' 
      : "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

  // --- Lógica de Seleção ---
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
                setState(() => _steps.add(controller.text));
              }
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
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
              onGenerateSteps: () {
                setState(() {
                  _steps.addAll(['Analisar requisitos', 'Esboçar design', 'Desenvolver protótipo']);
                });
              },
            ),
            
            const SizedBox(height: 32),
            TaskFormStepsList(
              steps: _steps,
              onAddStep: _showAddStepDialog,
              onDeleteStep: (index) => setState(() => _steps.removeAt(index)),
            ),

            const SizedBox(height: 40),
            AppButton(
              text: isEditing ? 'Salvar alterações' : 'Salvar tarefa',
              icon: Icons.check,
              borderRadius: 16,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widgets de Apoio Locais (AppBar) ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('P', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24)),
          Image.asset('assets/pato_logo.png', height: 30),
          const Text('TO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24)),
        ],
      ),
      centerTitle: true,
      actions: [
        if (isEditing)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: () {
              // Implementar lógica de deletar
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}

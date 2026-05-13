import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../widgets/subtasks_button.dart';
import '../widgets/task_step_item.dart';

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

  @override
  void initState() {
    super.initState();
    isEditing = widget.task != null;
    if (isEditing) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.subtitle;
      // Note: In a real app, you would also load steps from the task object here
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'P',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
            Image.asset('assets/pato_logo.png', height: 30),
            const Text(
              'TO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 24,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black87),
              onPressed: () {
                // Implement delete logic
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),

            _buildFieldLabel(
              'Título da tarefa',
              count: "${_titleController.text.length}/100",
            ),
            _buildCustomTextField(
              controller: _titleController,
              hintText: 'Ex: Estudar para prova',
              onChanged: (val) => setState(() {}),
            ),

            const SizedBox(height: 20),

            _buildFieldLabel(
              'Descrição (opcional)',
              count: "${_descController.text.length}/300",
            ),
            _buildCustomTextField(
              controller: _descController,
              hintText: 'Adicione mais detalhes sobre a tarefa...',
              maxLines: 3,
              onChanged: (val) => setState(() {}),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildSelector(
                    'Categoria',
                    'Selecione',
                    Icons.book_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSelector(
                    'Prioridade',
                    'Normal',
                    Icons.flag_outlined,
                    iconColor: Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildSelector(
                    'Data',
                    'Definir data',
                    Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSelector(
                    'Horário (opcional)',
                    'Definir horário',
                    Icons.access_time,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            _buildAISwitch(),
            const SizedBox(height: 16),
            if (_useAI) _buildAIBanner(),

            const SizedBox(height: 32),
            _buildStepsHeader(),
            const SizedBox(height: 16),

            if (_steps.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Nenhum passo adicionado ainda',
                    style: GoogleFonts.poppins(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ..._steps
                  .map(
                    (step) => TaskStepItem(
                      text: step,
                      onDelete: () {
                        setState(() {
                          _steps.remove(step);
                        });
                      },
                    ),
                  )
                  .toList(),

            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                // Logic to show a dialog or text field to add a new step
              },
              icon: const Icon(Icons.add, color: Color(0xFF6C63FF)),
              label: Text(
                'Adicionar passo manualmente',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6C63FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),
            SubtasksButton(
              text: isEditing ? 'Salvar alterações' : 'Salvar tarefa',
              icon: Icons.check,
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

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Editar tarefa' : 'Nova tarefa',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(color: Colors.black54, fontSize: 16),
                children: const [
                  TextSpan(text: 'Vamos dividir em '),
                  TextSpan(
                    text: 'passos ',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: 'menores?'),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: -10,
          top: -30,
          child: Image.asset('assets/pato_muito_feliz_image.png', width: 100),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {String? count}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          if (count != null)
            Text(
              count,
              style: const TextStyle(fontSize: 10, color: Colors.black26),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF)),
        ),
      ),
    );
  }

  Widget _buildSelector(
    String label,
    String value,
    IconData icon, {
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: iconColor ?? const Color(0xFF6C63FF)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black26),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAISwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Quebrar em passos com IA',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildBadge('Novo'),
                ],
              ),
              const Text(
                'Nossa IA divide sua tarefa em passos menores e mais fáceis de começar.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        Switch(
          value: _useAI,
          onChanged: (v) => setState(() => _useAI = v),
          activeColor: const Color(0xFF6C63FF),
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6C63FF),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAIBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFF6C63FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A IA vai sugerir passos para essa tarefa.',
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
                Text(
                  'Você poderá editar, remover ou adicionar novos passos depois.',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Gerar passos com IA',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.auto_awesome, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsHeader() {
    return Row(
      children: [
        Text(
          'Passos da tarefa',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        if (_steps.isNotEmpty) _buildBadge('${_steps.length} passos sugeridos'),
      ],
    );
  }
}

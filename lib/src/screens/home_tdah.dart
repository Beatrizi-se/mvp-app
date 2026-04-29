import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeTdah extends StatefulWidget {
  const HomeTdah({super.key});
  @override
  State<HomeTdah> createState() => _HomeTdahState();
}

class _HomeTdahState extends State<HomeTdah> {
  late ConfettiController _confettiController;
  bool _tarefaConcluida = false;
  List _listaTarefas = [];
  bool _carregando = true;

  final String apiUrl = 'URL_DA_API_AQUI'; 
  final TextEditingController _ideiaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _buscarTarefasDaAPI();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _ideiaController.dispose(); 
    super.dispose();
  }

  Future<void> _buscarTarefasDaAPI() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          _listaTarefas = json.decode(response.body);
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  Future<void> _salvarNovaIdeia() async {
    if (_ideiaController.text.isEmpty) return; 
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'titulo': _ideiaController.text}), 
      );
      if (response.statusCode == 201) {
        _ideiaController.clear(); 
        _buscarTarefasDaAPI(); 
        Navigator.pop(context);
      }
    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    final tarefaFoco = _listaTarefas.firstWhere(
      (t) => t['tipo'] == 'foco', 
      orElse: () => {'titulo': 'Nenhum foco definido'}
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Olá, Jhonata', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Foco de agora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _buildCardDopamina(tarefaFoco),
                const SizedBox(height: 32),
                _buildListaTarefas(),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFabEsvaziarMente(),
    );
  }

  Widget _buildCardDopamina(Map tarefaFoco) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
        ),
      child: Column(
        children: [
          Text(
            _tarefaConcluida ? 'Tarefa Finalizada! 🎉' : (_carregando ? 'Carregando...' : tarefaFoco['titulo']),
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
            onPressed: _tarefaConcluida || _carregando ? null : () {
              setState(() => _tarefaConcluida = true);
              _confettiController.play();
            },
            child: Text(_tarefaConcluida ? 'Dopamina Resgatada!' : 'Concluir e ganhar dopamina +10'),
          ),
        ],
    ),
    );
  }

  Widget _buildListaTarefas() {
    return Expanded(
      child: _carregando 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView.builder(
            itemCount: _listaTarefas.length,
            itemBuilder: (context, index) {
              final tarefa = _listaTarefas[index];
              if (tarefa['tipo'] == 'proxima_acao') {
                return _itemTarefa(tarefa['titulo']);
              }
              return const SizedBox.shrink();
            },
          ),
    );
  }

  Widget _itemTarefa(String titulo) {
    return Card(child: ListTile(title: Text(titulo), leading: const Icon(Icons.circle_outlined)));
  }

  Widget _buildFabEsvaziarMente() {
    return FloatingActionButton.extended(
      onPressed: () => _showModalEsvaziarMente(),
      label: const Text('Esvaziar mente'),
      icon: const Icon(Icons.psychology),
    );
  }

  void _showModalEsvaziarMente() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _ideiaController, decoration: const InputDecoration(hintText: 'Escreva a ideia solta aqui...')),
            ElevatedButton(onPressed: _salvarNovaIdeia, child: const Text('Salvar ideia')),
          ],
        ),
      ),
    );
  }
}

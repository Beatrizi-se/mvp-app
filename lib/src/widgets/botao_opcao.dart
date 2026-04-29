import 'package:flutter/material.dart';

class BotaoOpcao extends StatelessWidget {
  final String texto;
  final IconData icone;
  final Widget destino;

  const BotaoOpcao({
    super.key,
    required this.texto,
    required this.icone,
    required this.destino,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destino));
        },
        icon: Icon(icone, size: 24, color: Colors.deepPurple),
        label: Text(
          texto,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.deepPurple.shade100, width: 1),
          ),
        ),
      ),
    );
  }
}
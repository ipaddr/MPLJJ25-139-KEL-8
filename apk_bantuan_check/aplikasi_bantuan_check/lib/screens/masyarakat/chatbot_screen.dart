import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _messageController.text.trim(),
          isUser: true,
        ));
        _messageController.clear();
        // TODO: Integrasikan dengan Chatbot API di sini
        // Contoh balasan (ganti dengan logika chatbot Anda)
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _messages.add(ChatMessage(
              text: 'Halo! Bagaimana saya bisa membantu?',
              isUser: false,
            ));
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0C72C3), // Warna biru latar belakang utama
      appBar: AppBar(
        title: const Text('Chat Bot (AI)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF9800), // Warna oranye header
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7E7), // Warna krem untuk input
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Color(0xFF28A745)), // Warna hijau untuk kirim
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isUser
            ? const Color(0xFFDCF8C6)
            : Colors.white, // Warna pesan user: hijau muda
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(text, style: const TextStyle(fontSize: 16.0)),
    );
  }
}

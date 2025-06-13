import 'package:aplikasi_bantuan_check/services/firestore_service.dart';
import 'package:aplikasi_bantuan_check/services/gemini_service.dart'; // Import GeminiService
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Tetap diperlukan untuk Timestamp

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiService _geminiService =
      GeminiService(); // Inisialisasi GeminiService
  final ScrollController _scrollController = ScrollController();
  String? _currentUserId;

  List<ChatMessageData> _messages = []; // Menggunakan data model untuk pesan

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_currentUserId != null) {
      _loadChatHistory();
    }
  }

  void _loadChatHistory() {
    _firestoreService
        .getChatMessages(_currentUserId!)
        .listen((snapshotMessages) {
      if (mounted) {
        // Karena Firestore mengembalikan pesan dalam urutan descending, kita perlu membalikkan
        // agar pesan terbaru ada di bawah saat ditampilkan di ListView
        List<ChatMessageData> loadedMessages = snapshotMessages
            .map((data) => ChatMessageData(
                  text: data['message'] ?? '',
                  isUser: data['sender'] == 'user',
                  timestamp: (data['timestamp'] as Timestamp?)?.toDate() ??
                      DateTime.now(),
                ))
            .toList();

        // Urutkan berdasarkan waktu agar tampilan urut dari lama ke baru
        loadedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        setState(() {
          _messages = loadedMessages;
        });
        // Scroll ke bawah setelah pesan dimuat
        _scrollToBottom();
      }
    }).onError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat riwayat chat: $error')),
        );
      }
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    if (_currentUserId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Anda harus login untuk menggunakan chatbot.')),
        );
      }
      return;
    }

    String userMessage = _messageController.text.trim();
    _messageController.clear(); // Bersihkan input segera

    // Tampilkan pesan pengguna di UI
    setState(() {
      _messages.add(ChatMessageData(
          text: userMessage, isUser: true, timestamp: DateTime.now()));
    });
    // Simpan pesan pengguna ke Firestore
    _firestoreService.sendChatMessage(_currentUserId!, userMessage, 'user');
    _scrollToBottom();

    // Dapatkan respons dari Gemini API
    String geminiResponse = await _geminiService.getGeminiResponse(userMessage);

    // Tampilkan respons Gemini di UI
    setState(() {
      _messages.add(ChatMessageData(
          text: geminiResponse, isUser: false, timestamp: DateTime.now()));
    });
    // Simpan respons Gemini ke Firestore
    _firestoreService.sendChatMessage(
        _currentUserId!, geminiResponse, 'chatbot');
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return const Center(
          child: Text('Silakan login untuk menggunakan chatbot.'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C72C3),
      appBar: AppBar(
        title: const Text('Chat Bot (AI)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF9800),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatMessageBubble(
                  text: message.text,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF7E7),
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
                  icon: const Icon(Icons.send, color: Color(0xFF28A745)),
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

// Widget untuk menampilkan bubble pesan chat
class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessageBubble({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFFE0F7FA)
              : Colors.white, // Warna latar belakang pesan
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
            bottomLeft: isUser
                ? const Radius.circular(15.0)
                : const Radius.circular(0.0),
            bottomRight: isUser
                ? const Radius.circular(0.0)
                : const Radius.circular(15.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *
                0.75), // Batasi lebar bubble
        child: Text(text,
            style: const TextStyle(fontSize: 15.0, color: Colors.black87)),
      ),
    );
  }
}

// Model data sederhana untuk pesan chat (opsional, tapi disarankan)
class ChatMessageData {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessageData(
      {required this.text, required this.isUser, required this.timestamp});
}

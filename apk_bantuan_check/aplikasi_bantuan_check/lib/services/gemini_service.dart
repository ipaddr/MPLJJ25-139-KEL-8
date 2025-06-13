import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:aplikasi_bantuan_check/app_constants.dart'; // Untuk mendapatkan kunci API

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
      model:
          'gemini-1.5-flash', // Atau model lain yang tersedia, misalnya 'gemini-1.5-pro'
      apiKey: AppConstants.geminiApiKey,
    );
    _chat =
        _model.startChat(history: []); // Mulai sesi chat dengan histori kosong
  }

  Future<String> getGeminiResponse(String userMessage) async {
    try {
      final response = await _chat.sendMessage(Content.text(userMessage));
      return response.text ??
          'Maaf, saya tidak dapat memproses permintaan ini.';
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'Maaf, terjadi kesalahan saat menghubungi AI. Silakan coba lagi.';
    }
  }

  // Opsional: Jika Anda ingin mereset histori chat
  void resetChatSession() {
    _chat = _model.startChat(history: []);
  }
}

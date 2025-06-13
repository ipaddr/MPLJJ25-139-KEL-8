import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({super.key});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      // Ganti dengan URL video edukasi yang valid
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edukasi Usaha & Literasi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Video Edukasi Terkini",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              "Video ini berisi panduan usaha kecil dan tips literasi keuangan untuk masyarakat.",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EdukasiPage extends StatelessWidget {
  final videoUrl = 'https://www.youtube.com/watch?v=9bZkp7q19f0'; // contoh

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
      flags: YoutubePlayerFlags(autoPlay: false),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Video Edukasi')),
      body: YoutubePlayer(controller: controller),
    );
  }
}

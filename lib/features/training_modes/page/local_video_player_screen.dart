import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class LocalVideoPlayerScreen extends StatefulWidget {
  final String videoAssetPath;

  const LocalVideoPlayerScreen({
    super.key,
    required this.videoAssetPath,
  });

  @override
  State<LocalVideoPlayerScreen> createState() => _LocalVideoPlayerScreenState();
}

class _LocalVideoPlayerScreenState extends State<LocalVideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();

  }

  void initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.asset(widget.videoAssetPath);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoPlayerController,
      );
    }).catchError((error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể tải video: ${widget.videoAssetPath}'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || !_videoPlayerController.value.isInitialized) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 50),
                    SizedBox(height: 10),
                    Text(
                      'Không thể tải video',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }
            return CustomVideoPlayer(
              customVideoPlayerController: _customVideoPlayerController,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _customVideoPlayerController.dispose();
    super.dispose();
  }
}
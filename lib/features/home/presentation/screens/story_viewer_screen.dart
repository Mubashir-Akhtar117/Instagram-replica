import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';

import 'package:sample/features/home/model/story_model.dart';
import '../bloc/story_bloc.dart';
import '../bloc/upload_story_events.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> stories;

  const StoryViewerScreen({super.key, required this.stories});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  late AnimationController _controller;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _nextStory();
            }
          });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markSeen();
      _loadMedia();
    });
  }

  void _loadMedia() {
    final story = widget.stories[currentIndex];

    _videoController?.dispose();
    _videoController = null;

    if (story.type == "video") {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(story.mediaUrl))
            ..initialize()
                .then((_) {
                  if (!mounted) return;

                  setState(() {});
                  _videoController!.play();

                  _controller.duration = _videoController!.value.duration;
                  _controller.forward(from: 0);
                })
                .catchError((e) {
                  debugPrint("Video error: $e");
                  _nextStory();
                });
    } else {
      _controller.duration = const Duration(seconds: 5);
      _controller.forward(from: 0);
    }
  }

  void _markSeen() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final bloc = context.read<StoryBloc>();

    for (final story in widget.stories) {
      bloc.add(MarkStorySeenEvent(story.id, userId));
    }
  }

  void _nextStory() {
    if (currentIndex < widget.stories.length - 1) {
      setState(() => currentIndex++);
      _loadMedia();
    } else {
      Navigator.pop(context);
    }
  }

  void _prevStory() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _loadMedia();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, color: Colors.white, size: 50);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final width = MediaQuery.of(context).size.width;

          if (details.globalPosition.dx < width / 2) {
            _prevStory();
          } else {
            _nextStory();
          }
        },
        child: Stack(
          children: [
            Center(
              child: story.type == "video"
                  ? (_videoController != null &&
                            _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : const CircularProgressIndicator())
                  : _buildImage(story.mediaUrl),
            ),

            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(widget.stories.length, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      child: Stack(
                        children: [
                          Container(color: Colors.white24),
                          if (index < currentIndex)
                            Container(color: Colors.white)
                          else if (index == currentIndex)
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return FractionallySizedBox(
                                  widthFactor: _controller.value,
                                  child: Container(color: Colors.white),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            Positioned(
              top: 50,
              right: 15,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

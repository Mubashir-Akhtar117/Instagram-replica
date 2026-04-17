import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'package:sample/features/home/presentation/bloc/story_bloc.dart';
import 'package:sample/features/home/presentation/bloc/story_state.dart';
import 'package:sample/features/home/presentation/bloc/upload_story_events.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  bool _navigated = false;

  VideoPlayerController? _videoController;

  void pickFromGallery() {
    context.read<StoryBloc>().add(PickStoryEvent());
  }

  void openCamera() {
    context.read<StoryBloc>().add(PickStoryEventFromCamera());
  }

  void uploadStory() {
    context.read<StoryBloc>().add(UploadStoryEvent());
  }

  bool _isVideo(File file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.mkv');
  }

  void _loadVideo(File file) {
    _videoController?.dispose();

    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _videoController!.play();
        _videoController!.setLooping(true);
      });
  }

  Widget _preview(File file) {
    if (_isVideo(file)) {
      if (_videoController == null) {
        _loadVideo(file);
        return const Center(child: CircularProgressIndicator());
      }

      if (_videoController!.value.isInitialized) {
        return AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        );
      }

      return const Center(child: CircularProgressIndicator());
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, color: Colors.white, size: 60);
      },
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<StoryBloc, StoryState>(
        listenWhen: (prev, curr) =>
            prev.uploadSuccess != curr.uploadSuccess ||
            prev.error != curr.error,
        listener: (context, state) {
          if (state.uploadSuccess == true && !_navigated) {
            _navigated = true;
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<StoryBloc, StoryState>(
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: state.file == null
                      ? const Center(
                          child: Text(
                            "Hold to Capture / Select Media",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : _preview(state.file!),
                ),

                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.photo_library,
                              color: Colors.white,
                            ),
                            onPressed: pickFromGallery,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: openCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: state.file != null
                        ? ElevatedButton(
                            onPressed: state.uploading ? null : uploadStory,
                            child: state.uploading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : const Text("Share Story"),
                          )
                        : const SizedBox(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

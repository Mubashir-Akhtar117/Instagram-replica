import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/post_event.dart';
import 'package:sample/features/home/presentation/bloc/post_state.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController captionController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostBloc>().add(ClearMediaEvent());
    });
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  Future<XFile?> _pickMediaBottomSheet() async {
    final picker = ImagePicker();

    return await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Pick Image"),
                onTap: () async {
                  final file = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_collection),
                title: const Text("Pick Video"),
                onTap: () async {
                  final file = await picker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listenWhen: (prev, curr) => prev.uploadSuccess != curr.uploadSuccess,
      listener: (context, state) async {
        if (state.uploadSuccess) {
          await Future.delayed(const Duration(milliseconds: 200));

          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text("Create Post"),
          actions: [
            BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state.selectedFile == null || state.uploading
                      ? null
                      : () {
                          context.read<PostBloc>().add(UploadPostEvent());
                        },
                  child: state.uploading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Post"),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<PostBloc, PostState>(
                buildWhen: (prev, curr) =>
                    prev.selectedFile != curr.selectedFile ||
                    prev.mediaType != curr.mediaType,
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () async {
                      final picked = await _pickMediaBottomSheet();

                      if (picked != null) {
                        context.read<PostBloc>().add(PickMediaEvent(picked));
                      }
                    },
                    child: Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state.selectedFile == null
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                          : state.mediaType == MediaType.video
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(color: Colors.black),
                                const Icon(
                                  Icons.play_circle,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(state.selectedFile!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              TextField(
                controller: captionController,
                onChanged: (value) {
                  context.read<PostBloc>().add(CaptionChangedEvent(value));
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

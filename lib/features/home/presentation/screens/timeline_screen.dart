import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/core/routes/app_routes_name.dart';

import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/post_event.dart';
import 'package:sample/features/home/presentation/bloc/post_state.dart';
import 'package:sample/features/home/presentation/bloc/story_bloc.dart';
import 'package:sample/features/home/presentation/bloc/upload_story_events.dart';

import 'package:sample/features/home/widgets/CreateActionBottomSheet.dart';
import 'package:sample/features/home/widgets/post_item.dart';
import 'package:sample/features/home/widgets/stories_list.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PostBloc>().add(LoadPosts());
    context.read<StoryBloc>().add(LoadStoriesEvent());
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PostBloc>(),
        child: const CreateActionBottomSheet(),
      ),
    );
  }

  void openCreateStory() async {
    await Navigator.pushNamed(context, AppRoutesName.createStory);
  }

  void openCreatePost() async {
    await Navigator.pushNamed(context, AppRoutesName.createPost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text('Instagram'),
        actions: const [Icon(Icons.favorite_border), SizedBox(width: 16)],
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: openBottomSheet,
        ),
      ),
      body: Column(
        children: [
          const StoriesList(),

          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                // 🔥 SHOW LOADER ONLY FIRST TIME
                if (state.loading && state.posts.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.posts.isEmpty && state.loading) {
                  return const SizedBox();
                }

                if (state.posts.isEmpty && !state.loading) {
                  return const Center(child: Text("No Posts Available"));
                }

                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (_, index) {
                    return PostItem(post: state.posts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

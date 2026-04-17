import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sample/features/home/model/story_model.dart';
import 'package:sample/features/home/presentation/bloc/story_bloc.dart';
import 'package:sample/features/home/presentation/bloc/story_state.dart';
import 'package:sample/features/home/presentation/bloc/upload_story_events.dart';
import 'package:sample/features/home/presentation/screens/story_viewer_screen.dart';
import 'package:sample/features/home/widgets/story_item.dart';

class StoriesList extends StatelessWidget {
  const StoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocBuilder<StoryBloc, StoryState>(
      builder: (context, state) {
        final stories = state.stories;

        final Map<String, List<StoryModel>> grouped = {};

        for (final story in stories) {
          grouped.putIfAbsent(story.userId, () => []);
          grouped[story.userId]!.add(story);
        }

        final users = grouped.keys.toList();

        if (users.isEmpty) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("No Stories")),
          );
        }

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (_, index) {
              final userId = users[index];
              final userStories = grouped[userId]!;

              final isSeen = userStories.every(
                (s) => s.viewedBy.contains(currentUserId),
              );

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<StoryBloc>(),
                        child: StoryViewerScreen(stories: userStories),
                      ),
                    ),
                  ).then((_) {
                    context.read<StoryBloc>().add(LoadStoriesEvent());
                  });
                },
                child: StoryItem(
                  imageUrl: userStories.first.mediaUrl,
                  isSeen: isSeen,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
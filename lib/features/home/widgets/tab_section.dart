import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/post_state.dart';
import 'package:sample/features/home/widgets/post_grid.dart';

class TabSection extends StatelessWidget {
  final TabController controller;
  const TabSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: controller,
          indicatorColor: AppColors.textPrimary,
          indicatorWeight: 1.5,
          tabs: const [
            Tab(icon: Icon(Icons.grid_on_rounded)),
            Tab(icon: Icon(Icons.play_circle_outline_rounded)),
            Tab(icon: Icon(Icons.loop_rounded)),
            Tab(icon: Icon(Icons.person_outline_rounded)),
          ],
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
        ),
        SizedBox(
          height: 600,
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.posts.isEmpty) {
                return const Center(
                  child: Text(
                    "No Posts Available",
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return PostsGrid(posts: state.posts);
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/core/routes/app_routes_name.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/post_event.dart';

class CreateActionBottomSheet extends StatelessWidget {
  const CreateActionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Create",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.amp_stories),
            title: const Text("Create Story"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutesName.createStory);
            },
          ),

          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text("Create Post"),
            onTap: () {
              Navigator.pop(context);
              context.read<PostBloc>().add(ClearMediaEvent());
              Navigator.pushNamed(context, AppRoutesName.createPost);
            },
          ),
        ],
      ),
    );
  }
}

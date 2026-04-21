import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/core/di/injector.dart';

import 'package:sample/features/auth/presentation/bloc/signin_bloc.dart';
import 'package:sample/features/auth/presentation/screens/signin_screen.dart';
import 'package:sample/features/auth/presentation/screens/signup_screen.dart';
import 'package:sample/features/auth/presentation/bloc/signup_bloc.dart';

import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/post_event.dart';
import 'package:sample/features/home/presentation/bloc/story_bloc.dart';
import 'package:sample/features/home/presentation/bloc/profile_bloc.dart';
import 'package:sample/features/home/presentation/bloc/upload_story_events.dart';

import 'package:sample/features/home/presentation/screens/home_screen.dart';
import 'package:sample/features/home/presentation/screens/create_post_screen.dart';
import 'package:sample/features/home/presentation/screens/create_story_screen.dart';

import 'app_routes_name.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.signin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<SigninBloc>(),
            child: const SigninScreen(),
          ),
        );

      case AppRoutesName.signup:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<SignupBloc>(),
            child: const SignupScreen(),
          ),
        );

      case AppRoutesName.home:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => sl<PostBloc>()
                  ..add(LoadPosts())
                  ..startPostsListener(),
              ),
              BlocProvider(
                create: (_) => sl<StoryBloc>()..add(LoadStoriesEvent()),
              ),
              BlocProvider(create: (_) => sl<ProfileBloc>()),
            ],
            child: const HomeScreen(),
          ),
        );

      case AppRoutesName.createPost:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<PostBloc>(),
            child: const CreatePostScreen(),
          ),
        );

      case AppRoutesName.createStory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<StoryBloc>(),
            child: const CreateStoryScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}

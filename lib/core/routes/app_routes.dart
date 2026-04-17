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
  static PostBloc? _postBloc;
  static StoryBloc? _storyBloc;
  static ProfileBloc? _profileBloc;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutesName.signin:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SigninBloc(),
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
        _postBloc ??= sl<PostBloc>()
          ..add(LoadPosts())
          ..startPostsListener();

        _storyBloc ??= sl<StoryBloc>()..add(LoadStoriesEvent());

        _profileBloc ??= sl<ProfileBloc>();

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _postBloc!),
              BlocProvider.value(value: _storyBloc!),
              BlocProvider.value(value: _profileBloc!),
            ],
            child: const HomeScreen(),
          ),
        );

      case AppRoutesName.createPost:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _postBloc!,
            child: const CreatePostScreen(),
          ),
        );

      case AppRoutesName.createStory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _storyBloc!,
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

import 'package:get_it/get_it.dart';

import 'package:sample/features/auth/data/dataSource/auth_remote_datasource_impl.dart';
import 'package:sample/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:sample/features/auth/donain/usecase/signup_usecase.dart';

import 'package:sample/features/home/data/dataSource/post_remote_datasource.dart';
import 'package:sample/features/home/data/dataSource/post_repository_impl.dart';
import 'package:sample/features/home/domain/usecase/get_posts_usecase.dart';
import 'package:sample/features/home/domain/usecase/create_post_usecase.dart';

import 'package:sample/features/home/data/dataSource/story_remote_datasource.dart';
import 'package:sample/features/home/data/local/story_local_datasource.dart';
import 'package:sample/features/home/data/repository/story_repository_impl.dart';
import 'package:sample/features/home/domain/usecase/create_story_usecase.dart';
import 'package:sample/features/home/domain/usecase/get_stories_usecase.dart';

import 'package:sample/features/home/data/datasource/user_remote_datasource_impl.dart';
import 'package:sample/features/home/data/repository/user_repository_impl.dart';
import 'package:sample/features/home/domain/usecase/get_user_profile_usecase.dart';

import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/story_bloc.dart';
import 'package:sample/features/home/presentation/bloc/profile_bloc.dart';
import 'package:sample/features/auth/presentation/bloc/signup_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // ---------------- AUTH ----------------
  sl.registerLazySingleton<AuthRemoteDataSourceImpl>(
      () => AuthRemoteDataSourceImpl());

  sl.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSourceImpl>()));

  sl.registerLazySingleton<SignupUseCase>(
      () => SignupUseCase(sl<AuthRepositoryImpl>()));

  sl.registerFactory<SignupBloc>(() => SignupBloc(sl<SignupUseCase>()));

  // ---------------- POST ----------------
  sl.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSource());

  sl.registerLazySingleton<PostRepositoryImpl>(
      () => PostRepositoryImpl(sl<PostRemoteDataSource>()));

  sl.registerLazySingleton<GetPostsUseCase>(
      () => GetPostsUseCase(sl<PostRepositoryImpl>()));

  sl.registerLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(sl<PostRepositoryImpl>()));

  sl.registerFactory<PostBloc>(() => PostBloc(
        sl<GetPostsUseCase>(),
        sl<CreatePostUseCase>(),
        sl<PostRepositoryImpl>(),
      ));

  // ---------------- STORY ----------------
  sl.registerLazySingleton<StoryRemoteDataSource>(
      () => StoryRemoteDataSource());

  sl.registerLazySingleton<StoryLocalDataSource>(
      () => StoryLocalDataSource());

  sl.registerLazySingleton<StoryRepositoryImpl>(() =>
      StoryRepositoryImpl(sl<StoryRemoteDataSource>(), sl<StoryLocalDataSource>()));

  sl.registerLazySingleton<CreateStoryUseCase>(
      () => CreateStoryUseCase(sl<StoryRepositoryImpl>()));

  sl.registerLazySingleton<GetStoriesUseCase>(
      () => GetStoriesUseCase(sl<StoryRepositoryImpl>()));

  sl.registerFactory<StoryBloc>(() => StoryBloc(
        sl<CreateStoryUseCase>(),
        sl<GetStoriesUseCase>(),
      ));

  // ---------------- PROFILE ----------------
  sl.registerLazySingleton<UserRemoteDataSourceImpl>(
      () => UserRemoteDataSourceImpl());

  sl.registerLazySingleton<UserRepositoryImpl>(
      () => UserRepositoryImpl(sl<UserRemoteDataSourceImpl>()));

  sl.registerLazySingleton<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(sl<UserRepositoryImpl>()));

  sl.registerFactory<ProfileBloc>(
      () => ProfileBloc(sl<GetUserProfileUseCase>()));
}
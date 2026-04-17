import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sample/core/di/injector.dart';

import 'package:sample/core/routes/app_routes.dart';
import 'package:sample/features/home/domain/entities/media_type_adapter.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/model/comment_model.dart';
import 'package:sample/features/home/model/story_model.dart';
import 'package:sample/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sample/core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(StoryModelAdapter());
  Hive.registerAdapter(PostEntityAdapter());
  Hive.registerAdapter(CommentModelAdapter());
  Hive.registerAdapter(MediaTypeAdapter());

  await Hive.openBox<StoryModel>('storyBox');
  await Hive.openBox('postBox');
  await Hive.openBox('commentBox');
  await Supabase.initialize(
    url: "https://stuvbfdlajoirscbuvyi.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0dXZiZmRsYWpvaXJzY2J1dnlpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2Mzk3MzEsImV4cCI6MjA5MTIxNTczMX0.dh2ILAQuenH3usjpzw99QjEq2A1-Cq5MYsP69arWUsQ",
  );
  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

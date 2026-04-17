import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/home/domain/usecase/get_user_profile_usecase.dart';
import 'package:sample/features/home/presentation/screens/profile_screen.dart';
import 'package:sample/features/home/presentation/screens/timeline_screen.dart';
import 'package:sample/features/home/presentation/bloc/profile_bloc.dart';
import 'package:sample/features/home/data/datasource/user_remote_datasource_impl.dart';
import 'package:sample/features/home/data/repository/user_repository_impl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();

    final dataSource = UserRemoteDataSourceImpl();
    final repository = UserRepositoryImpl(dataSource);
    final useCase = GetUserProfileUseCase(repository);

    _profileBloc = ProfileBloc(useCase);
  }

  final List<Widget> _screens = const [
    TimelineScreen(),
    Center(child: Text("Search")),
    Center(child: Text("Add Post")),
    Center(child: Text("Reels")),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileBloc,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.textPrimary,
          unselectedItemColor: AppColors.textSecondary,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: "",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.video_library), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }
}

import 'package:eventify/core/widgets/navigation_bar_widget.dart';
import 'package:eventify/features/events/presentation/providers/screens/home_screen.dart';
import 'package:eventify/features/media/presentation/camera_tab_screen.dart';
import 'package:eventify/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    CameraTabScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBarWidget(
          index: _currentIndex, 
          onTap: (index) => {
            setState(() {
              _currentIndex = index;
            })
          }
        ),
      ),
    );
  }
}
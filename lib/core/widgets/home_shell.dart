import 'package:eventify/features/events/presentation/providers/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    _PlaceholderScreen(title: "Camera"),
    _PlaceholderScreen(title: "profile")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.house()), 
            selectedIcon: PhosphorIcon(
              PhosphorIcons.house(),
              
            ),
            label: ""
          ),
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.camera()), 
            selectedIcon: PhosphorIcon(PhosphorIcons.camera(PhosphorIconsStyle.fill)),
            label: ""
          ),
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.person()), 
            selectedIcon: PhosphorIcon(PhosphorIcons.person(PhosphorIconsStyle.fill)),
            label: ""
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall
        ),
      ),
    );
  }
}
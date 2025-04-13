
import 'package:flutter/material.dart';
import 'package:kotel_pellet_app/views/main_view.dart';
import 'package:kotel_pellet_app/views/settings_view.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(initialIndex: 0, length: 2, child: Scaffold(
      appBar: AppBar(
        title: const Text('Kotel Pellets App'),
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          MainView(),
          SettingsView()
        ],
      ),
    ));
  }
}
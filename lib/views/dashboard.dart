import 'package:flutter/material.dart';
import 'package:task4/views/play_music.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.bar_chart_rounded, size: 22),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.notifications_outlined, size: 22),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.settings_outlined, size: 22),
          ),
        ],
        title: Text(
          "Welcome Back!",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), label: 'Explore'),
        BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined), label: 'Library'),
      ],
      backgroundColor: Colors.white,),
    
      body: const MusicPlayer(),
    );
  }
}

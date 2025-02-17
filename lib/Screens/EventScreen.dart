import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperxapp/Screens/HomeScreen.dart';
import 'package:wallpaperxapp/Screens/ProfileScreen.dart';
import '../Providers/TabProvider.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    return Scaffold(
      drawer: Drawer(),
      body: _getScreen(tabProvider.selectedIndex), // Change screen dynamically
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        height: 55,
        color: Theme.of(context).primaryColor,
        items: <Widget>[
          Icon(Icons.home, size: 20, color: Theme.of(context).scaffoldBackgroundColor),
          Icon(Icons.search, size: 20, color: Theme.of(context).scaffoldBackgroundColor),
          Icon(Icons.person, size: 20, color: Theme.of(context).scaffoldBackgroundColor),
        ],
        index: tabProvider.selectedIndex, // Set the active tab
        onTap: (index) {
          tabProvider.changeTab(index); // Update tab using Provider
        },
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return Center(child: Text('Search Screen', style: TextStyle(fontSize: 24)));
      case 2:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}

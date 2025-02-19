import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperxapp/Screens/HomeScreen.dart';
import 'package:wallpaperxapp/Screens/ProfileScreen.dart';
import 'package:wallpaperxapp/Screens/SearchScreen.dart';
import '../Providers/TabProvider.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper App'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,

        child: Column(
          children: [
            DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                )),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text('H O M E'),
                leading: Icon(Icons.home),
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text('S E T T I N G'),
                leading: Icon(Icons.settings),
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>SettingScreen()));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text('L O G O U T'),
                leading: Icon(Icons.logout),
                onTap: (){
                },
              ),
            ),
          ],
        ),
      ),
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
        return SearchScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }
}

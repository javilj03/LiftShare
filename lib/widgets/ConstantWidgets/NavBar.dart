import 'package:flutter/material.dart';
import 'package:lift_share/modules/User.dart';
import '../mainPage.dart';
import '../Routines.dart';
import '../Post.dart';
import './Header.dart';

class NavBar extends StatefulWidget {
  
  

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  
  int _selectedIndex = 1;
  Widget selectedWidget = MainPage();
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(_selectedIndex){
      case 0: 
        selectedWidget = Routines();
        break;
      case 1: 
        selectedWidget = MainPage();
        break;
      case 2: 
        selectedWidget = Post();
        break;
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: selectedWidget,
      bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Rutinas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Lifts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_sharp),
                label: 'Subir',
              ),
            ],
            backgroundColor: const Color(0xFFFCA311),
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFFE5E5E5),
            onTap: _onItemTapped,
          ),
    );
  }
}

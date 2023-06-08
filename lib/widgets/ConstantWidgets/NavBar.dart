import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/Search.dart';
import '../mainPage.dart';
import '../Routines.dart';
import '../Camera.dart';
import './Header.dart';
import '../Profile.dart';
class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 2;
  Widget selectedWidget = MainPage();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        selectedWidget = Routines();
        break;
      case 1: 
        selectedWidget = Search();
        break;
      case 2:
        selectedWidget = MainPage();
        break;
      case 3:
        selectedWidget = Camera();
        break;
      case 4: 
        selectedWidget = Profile();
        break;
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: selectedWidget,
     
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(ORANGE),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Rutinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Lifts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_sharp),
            label: 'Subir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFE5E5E5),
        onTap: _onItemTapped,
      ),
    );
  }
}

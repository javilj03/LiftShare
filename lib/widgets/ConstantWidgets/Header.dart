import 'package:flutter/material.dart';
import '../Profile.dart';
class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Lift Share'),
      backgroundColor: Color(0xFFFCA311),
      elevation: 0,
      actions: [
        
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
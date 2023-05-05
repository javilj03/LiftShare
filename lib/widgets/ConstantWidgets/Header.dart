import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Lift Share'),
      backgroundColor: Color(0xFFFCA311),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/user');
          },
          icon: Icon(Icons.account_circle, size: 40),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
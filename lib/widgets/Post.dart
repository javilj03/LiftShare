import 'package:flutter/material.dart';
import './ConstantWidgets/Header.dart';
import './ConstantWidgets/NavBar.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Estoy en post'),
    );
  }
}

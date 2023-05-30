import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        color: Colors.blueGrey,
        elevation: 8,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('User name'),
              trailing: Text('Hace 10h'),
            ),
            Container(
              width: double.infinity,
              child: Image.asset(
                'assets/img/liftShare.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

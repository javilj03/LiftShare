import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchText = '';
  List<String> userNames = [];

  void makeHttpRequest() async {
    var url = Uri.parse('https://ejemplo.com/buscar?query=$searchText');
    var response = await http.get(url);

    setState(() {
      // Parsea la respuesta y actualiza la lista de nombres de usuario
      List<dynamic> data = jsonDecode(response.body);
      userNames = data.map((user) => user['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  makeHttpRequest();
                },
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Buscar',
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: userNames.length,
            itemBuilder: (context, index) {
              return UserCard(userNames[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget UserCard(String name) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Row(
          children: [
            Icon(Icons.account_circle),
            Text(name),
          ],
        ),
      ),
    );
  }
}
